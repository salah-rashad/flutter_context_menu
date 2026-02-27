import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../state/playground_state.dart';
import '../utils/theme_bridge.dart';
import '../widgets/playground_area.dart';

/// Main playground screen with split layout.
///
/// Layout:
/// - Left pane: Tools panel (placeholder for Phase 4+)
/// - Right pane: Playground area with embedded context menu
///
/// Uses shadcn_flutter [ResizablePanel.horizontal] for the split layout.
class PlaygroundScreen extends material.StatelessWidget {
  const PlaygroundScreen({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    final playgroundState = context.watch<PlaygroundState>();
    final brightness = resolvedBrightness(
      context,
      playgroundState.appSettings.themeMode,
    );

    return material.Theme(
      data: buildMaterialTheme(
        brightness: brightness,
        contextMenuStyle: playgroundState.buildThemeExtensionStyle(),
      ),
      child: material.Scaffold(
        body: ResizablePanel.horizontal(
          children: [
            // Left pane - Tools panel
            ResizablePane(
              initialSize: 350,
              minSize: 250,
              maxSize: 500,
              child: material.Container(
                color: brightness.mutedColor,
                child: const _ToolsPanelPlaceholder(),
              ),
            ),
            // Right pane - Playground area with embedded context menu
            ResizablePane.flex(
              initialFlex: 1,
              child: material.Container(
                color: brightness.surfaceColor,
                child: const PlaygroundArea(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder widget for the tools panel.
///
/// Will be replaced in Phase 4 (US2) with the full entry tree editor.
class _ToolsPanelPlaceholder extends material.StatelessWidget {
  const _ToolsPanelPlaceholder();

  @override
  material.Widget build(material.BuildContext context) {
    final theme = material.Theme.of(context);
    return material.Center(
      child: material.Column(
        mainAxisSize: material.MainAxisSize.min,
        children: [
          material.Icon(
            material.Icons.build_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const material.SizedBox(height: 16),
          material.Text(
            'Tools Panel',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const material.SizedBox(height: 8),
          material.Text(
            'Phase 3+',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
