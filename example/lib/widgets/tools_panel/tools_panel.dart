import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'structure_tab/structure_tab.dart';

/// Two-level tabs container for the tools panel using shadcn_flutter.
///
/// Primary tabs:
/// - "Structure" - Entry tree editor and property editor
/// - "Theming" - Style configuration (placeholder for Phase 6+)
class ToolsPanel extends StatefulWidget {
  const ToolsPanel({super.key});

  @override
  State<ToolsPanel> createState() => _ToolsPanelState();
}

class _ToolsPanelState extends State<ToolsPanel> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Column(
      children: [
        // Tab bar
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.border,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildTab(
                index: 0,
                label: 'Structure',
                icon: LucideIcons.network,
                colorScheme: colorScheme,
              ),
              _buildTab(
                index: 1,
                label: 'Theming',
                icon: LucideIcons.palette,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        // Tab content
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              StructureTab(),
              _ThemingTabPlaceholder(),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a tab button.
  Widget _buildTab({
    required int index,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? colorScheme.primary : null;

    return Expanded(
      child: GhostButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder widget for the Theming tab.
///
/// Will be replaced in Phase 6 (US4) with inline style editor.
class _ThemingTabPlaceholder extends StatelessWidget {
  const _ThemingTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.palette).muted(),
            const SizedBox(height: 8),
            const Text('Theming').xSmall().muted(),
            const SizedBox(height: 4),
            const Text('Style configuration coming in Phase 6+')
                .xSmall()
                .muted(),
          ],
        ),
      ),
    );
  }
}
