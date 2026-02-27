import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Top header row of the entry tree: title, expand/collapse toggles, and an
/// add-entry button.
class EntryTreeHeader extends StatelessWidget {
  final bool canExpandAll;
  final bool canCollapseAll;
  final VoidCallback? onExpandAll;
  final VoidCallback? onCollapseAll;

  /// Pre-built add button (e.g. a [PrimaryButton] wrapped in [Builder] for
  /// correct context).
  final Widget addButton;

  const EntryTreeHeader({
    super.key,
    required this.canExpandAll,
    required this.canCollapseAll,
    required this.onExpandAll,
    required this.onCollapseAll,
    required this.addButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: const Text('Menu Entries', style: TextStyle(fontSize: 11))
                .semiBold(),
          ),
          GhostButton(
            onPressed: canExpandAll ? onExpandAll : null,
            density: ButtonDensity.icon,
            child: const Icon(BootstrapIcons.chevronExpand, size: 12),
          ),
          GhostButton(
            onPressed: canCollapseAll ? onCollapseAll : null,
            density: ButtonDensity.icon,
            child: const Icon(BootstrapIcons.chevronContract, size: 12),
          ),
          addButton,
        ],
      ),
    );
  }
}
