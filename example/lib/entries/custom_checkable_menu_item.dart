import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// A custom checkable entry that renders a switch instead of a checkmark.
///
/// Demonstrates the extensibility contract: only [builder] is overridden —
/// toggle behavior, keyboard activation (Space/Enter) and focus handling are
/// inherited from [ContextMenuCheckableItem].
final class SwitchMenuItem<T> extends ContextMenuCheckableItem<T> {
  final String label;
  final IconData? icon;

  /// The controller is required here so the switch can rebuild itself when
  /// the state changes, without needing a [StatefulWidget].
  const SwitchMenuItem({
    required this.label,
    required CheckableController super.controller,
    this.icon,
    super.onToggle,
    super.enabled,
  });

  @override
  String get debugLabel => "${super.debugLabel} - $label";

  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFocused = menuState.focusedEntry == this;
    final foregroundColor = enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.2);

    return ValueListenableBuilder<bool>(
      valueListenable: controller!,
      builder: (context, isChecked, child) {
        return Material(
          color: isFocused ? colorScheme.surfaceContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // Same public toggle the keyboard activator calls.
            onTap: enabled ? toggle : null,
            canRequestFocus: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16.0, color: foregroundColor),
                    const SizedBox(width: 8.0),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: foregroundColor, height: 1.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  SizedBox(
                    height: 24.0,
                    child: FittedBox(
                      child: Switch(
                        value: isChecked,
                        // Tapping the switch goes through the same toggle.
                        onChanged: enabled ? (_) => toggle() : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
