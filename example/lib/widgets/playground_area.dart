import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../state/playground_state.dart';
import '../utils/theme_bridge.dart';
import 'embedded_context_menu.dart';

/// The playground area widget that displays the embedded context menu.
///
/// This widget:
/// - Reads [PlaygroundState] via `context.watch`
/// - Wraps content in a Material [Theme] widget (bridge from [buildMaterialTheme])
/// - Centers the [EmbeddedContextMenu]
/// - Shows selection feedback when [PlaygroundState.lastSelectedValue] changes
///
/// Note: ContextMenuTheme wrapping is NOT added here - that is handled by T048 (US5).
class PlaygroundArea extends material.StatefulWidget {
  /// Creates the playground area widget.
  const PlaygroundArea({super.key});

  @override
  material.State<PlaygroundArea> createState() => _PlaygroundAreaState();
}

class _PlaygroundAreaState extends material.State<PlaygroundArea> {
  String? _lastDisplayedValue;

  /// Shows a toast notification with the selected value.
  void _showSelectionFeedback(String value) {
    // Use shadcn_flutter toast to show selection feedback
    showToast(
      context: context,
      builder: (context, overlay) {
        return SurfaceCard(
          child: Basic(
            title: Text('Selected: $value'),
            leading: const Icon(
              material.Icons.check_circle,
              color: Color(0xFF22C55E),
              size: 20,
            ),
          ),
        );
      },
      location: ToastLocation.bottomCenter,
      showDuration: const Duration(seconds: 2),
    );
  }

  @override
  material.Widget build(material.BuildContext context) {
    final playgroundState = context.watch<PlaygroundState>();
    final brightness = resolvedBrightness(
      context,
      playgroundState.appSettings.themeMode,
    );

    // Schedule feedback side effect after build completes — never call
    // showToast directly inside build().
    final currentValue = playgroundState.lastSelectedValue;
    if (currentValue != null && currentValue != _lastDisplayedValue) {
      _lastDisplayedValue = currentValue;
      material.WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSelectionFeedback(currentValue);
      });
    }

    return material.Theme(
      data: buildMaterialTheme(
        brightness: brightness,
        contextMenuStyle: playgroundState.buildThemeExtensionStyle(),
      ),
      child: material.Material(
        color: material.Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate center position based on constraints
            final position = Offset(
              constraints.maxWidth / 2,
              constraints.maxHeight / 2,
            );

            return Stack(
              children: [
                // Centered embedded context menu
                EmbeddedContextMenu(
                  position: position,
                ),
                // Selection feedback indicator at bottom
                if (playgroundState.lastSelectedValue != null)
                  material.Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: material.Center(
                      child: _SelectionIndicator(
                        value: playgroundState.lastSelectedValue!,
                        brightness: brightness,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// A widget that displays the last selected value at the bottom of the playground.
class _SelectionIndicator extends material.StatelessWidget {
  const _SelectionIndicator({
    required this.value,
    required this.brightness,
  });

  final String value;
  final material.Brightness brightness;

  @override
  material.Widget build(material.BuildContext context) {
    final backgroundColor = brightness == material.Brightness.light
        ? const Color(0xFFF4F4F5) // Zinc-100
        : const Color(0xFF27272A); // Zinc-800

    final textColor = brightness == material.Brightness.light
        ? const Color(0xFF18181B)
        : const Color(0xFFFAFAFA);

    return material.Container(
      padding: const material.EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: material.BoxDecoration(
        color: backgroundColor,
        borderRadius: material.BorderRadius.circular(8),
        border: material.Border.all(
          color: brightness.borderColor,
          width: 1,
        ),
      ),
      child: material.Row(
        mainAxisSize: material.MainAxisSize.min,
        children: [
          const material.Icon(
            material.Icons.check_circle_outline,
            size: 16,
            color: Color(0xFF22C55E),
          ),
          const material.SizedBox(width: 8),
          material.Text(
            'Last selected: ',
            style: material.TextStyle(
              color: textColor.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          material.Text(
            value,
            style: material.TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: material.FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
