import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Main playground screen with split layout.
///
/// This is a minimal implementation for Phase 1 setup.
/// Full implementation with ResizablePanel will be completed in Phase 2.
///
/// Layout:
/// - Left pane: Tools panel (placeholder)
/// - Right pane: Playground area (placeholder)
class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      child: Row(
        children: [
          // Left pane - Tools panel placeholder
          Container(
            width: 350,
            color: colorScheme.secondary,
            child: const Center(
              child: Text('Tools Panel (Phase 2)'),
            ),
          ),
          // Divider
          Container(
            width: 1,
            color: colorScheme.border,
          ),
          // Right pane - Playground area placeholder
          const Expanded(
            child: Center(
              child: Text('Playground Area (Phase 2)'),
            ),
          ),
        ],
      ),
    );
  }
}
