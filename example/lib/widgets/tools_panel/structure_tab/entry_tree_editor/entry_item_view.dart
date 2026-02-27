import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';

/// Builds the leading icon for a tree entry.
Widget buildEntryIcon(BuildContext context, EntryNode entry) {
  final colorScheme = ColorScheme.of(context);
  IconData iconData;
  Color? color;

  switch (entry.type) {
    case EntryType.item:
      if (entry.isSubmenu) {
        iconData = entry.children.isNotEmpty
            ? LucideIcons.folderOpen
            : LucideIcons.folder;
        color = colorScheme.primary;
      } else if (entry.icon != null) {
        return Icon(entry.icon, size: 14);
      } else {
        iconData = LucideIcons.circle;
      }
      break;
    case EntryType.header:
      iconData = LucideIcons.tag;
      color = colorScheme.accent;
      break;
    case EntryType.divider:
      iconData = LucideIcons.minus;
  }

  return Icon(iconData, color: color, size: 14);
}

/// Builds the label widget for a tree entry.
Widget buildEntryLabel(EntryNode entry) {
  final label = entry.type == EntryType.divider ? 'Divider' : entry.label;
  final isDisabled = entry.type == EntryType.item && !entry.enabled;

  if (isDisabled) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        decoration: TextDecoration.lineThrough,
      ),
    ).muted();
  }
  return Text(label, style: const TextStyle(fontSize: 12));
}

/// Trailing action buttons row for a single tree entry.
class EntryItemTrailing extends StatelessWidget {
  final EntryNode entry;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback onDelete;

  const EntryItemTrailing({
    super.key,
    required this.entry,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Submenu child-count badge
        if (entry.type == EntryType.item && entry.isSubmenu)
          Container(
            margin: const EdgeInsets.only(right: 2),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: ColorScheme.of(context).secondary,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              '${entry.children.length}',
              style: const TextStyle(fontSize: 10),
            ),
          ),
        // Move up
        GhostButton(
          onPressed: canMoveUp ? onMoveUp : null,
          density: ButtonDensity.dense,
          enableFeedback: false,
          child: const Icon(LucideIcons.chevronUp, size: 8),
        ),
        // Move down
        GhostButton(
          onPressed: canMoveDown ? onMoveDown : null,
          density: ButtonDensity.dense,
          child: const Icon(LucideIcons.chevronDown, size: 8),
        ),
        // Delete
        DestructiveButton(
          onPressed: onDelete,
          density: ButtonDensity.dense,
          child: const Icon(LucideIcons.trash2, size: 8),
        ),
      ],
    );
  }
}
