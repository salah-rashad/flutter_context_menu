import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../state/playground_state.dart';
import '../utils/theme_bridge.dart';
import '../widgets/playground_area.dart';
import '../widgets/tools_panel/tools_panel.dart';

/// Main playground screen with split layout.
///
/// Layout:
/// - Left pane: Tools panel with Structure and Theming tabs
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
                color: context.theme.colorScheme.slate.background,
                child: const ToolsPanel(),
              ),
            ),
            // Right pane - Playground area with embedded context menu
            ResizablePane.flex(
              initialFlex: 1,
              child: material.Container(
                color: context.theme.colorScheme.background,
                child: const PlaygroundArea(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
