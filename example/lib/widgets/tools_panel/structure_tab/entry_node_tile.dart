import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../state/entry_node.dart';
import '../../../state/playground_state.dart';

/// Single tree node widget for displaying an entry in the tree editor.
///
/// Shows:
/// - Entry type icon (item, header, or divider)
/// - Label text
/// - Action buttons (delete, move up/down)
/// - Submenu indicator and expand/collapse for submenus
///
/// Tappable to select for property editing.
class EntryNodeTile extends StatelessWidget {
  /// The entry node to display.
  final EntryNode entry;

  /// The depth level in the tree (for indentation).
  final int depth;

  /// Whether this entry is currently selected.
  final bool isSelected;

  /// Called when the entry is tapped.
  final VoidCallback? onTap;

  /// Whether this entry can be moved up.
  final bool canMoveUp;

  /// Whether this entry can be moved down.
  final bool canMoveDown;

  /// Whether this node has children and is expanded.
  final bool isExpanded;

  /// Called when the expand/collapse button is tapped.
  final VoidCallback? onToggleExpand;

  const EntryNodeTile({
    super.key,
    required this.entry,
    this.depth = 0,
    this.isSelected = false,
    this.onTap,
    this.canMoveUp = false,
    this.canMoveDown = false,
    this.isExpanded = true,
    this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final playgroundState = context.read<PlaygroundState>();
    final colorScheme = ColorScheme.of(context);

    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: GhostButton(
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: depth * 12.0 + 2,
            right: 2,
          ),
          child: Row(
            children: [
              // Expand/collapse button for submenus
              if (entry.type == EntryType.item && entry.isSubmenu)
                GhostButton(
                  onPressed: onToggleExpand,
                  density: ButtonDensity.icon,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.25 : 0,
                    child:
                        const Icon(LucideIcons.chevronRight, size: 12).muted(),
                  ),
                )
              else
                const SizedBox(width: 20),
              const SizedBox(width: 2),
              // Entry type icon
              _buildTypeIcon(context, colorScheme),
              const SizedBox(width: 6),
              // Label
              Expanded(
                child: _buildLabel(),
              ),
              // Submenu badge
              if (entry.type == EntryType.item && entry.isSubmenu)
                Container(
                  margin: const EdgeInsets.only(right: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text('${entry.children.length}',
                      style: const TextStyle(fontSize: 10)),
                ),
              // Action buttons
              _buildActionButton(
                icon: LucideIcons.chevronUp,
                onPressed:
                    canMoveUp ? () => _moveEntry(playgroundState, -1) : null,
                tooltip: 'Move up',
              ),
              _buildActionButton(
                icon: LucideIcons.chevronDown,
                onPressed:
                    canMoveDown ? () => _moveEntry(playgroundState, 1) : null,
                tooltip: 'Move down',
              ),
              _buildActionButton(
                icon: LucideIcons.trash2,
                onPressed: () => _removeEntry(playgroundState),
                tooltip: 'Delete',
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the label widget with optional strikethrough for disabled items.
  Widget _buildLabel() {
    final label = _getDisplayLabel();
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

  /// Builds the entry type icon.
  Widget _buildTypeIcon(BuildContext context, ColorScheme colorScheme) {
    IconData iconData;
    Color? color;

    switch (entry.type) {
      case EntryType.item:
        if (entry.isSubmenu) {
          iconData = LucideIcons.folderOpen;
          color = colorScheme.primary;
        } else if (entry.icon != null) {
          // Keep Material icon for user-selected icons (from icon picker)
          iconData = entry.icon!;
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
        break;
    }

    return Icon(iconData, color: color, size: 14);
  }

  /// Gets the display label for the entry.
  String _getDisplayLabel() {
    switch (entry.type) {
      case EntryType.item:
        return entry.label;
      case EntryType.header:
        return entry.label;
      case EntryType.divider:
        return 'Divider';
    }
  }

  /// Builds an action button.
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
    bool isDestructive = false,
  }) {
    return Tooltip(
      tooltip: (context) => TooltipContainer(
        child: Text(tooltip),
      ),
      child: isDestructive
          ? DestructiveButton(
              onPressed: onPressed,
              density: ButtonDensity.icon,
              child: Icon(icon, size: 12),
            )
          : GhostButton(
              onPressed: onPressed,
              density: ButtonDensity.icon,
              child: Icon(icon, size: 12),
            ),
    );
  }

  /// Moves the entry up or down.
  void _moveEntry(PlaygroundState playgroundState, int direction) {
    // Find current index and parent
    final result = _findEntryIndex(playgroundState.entries, entry.id);
    if (result == null) return;

    final currentIndex = result.$1;
    final parentPath = result.$2;
    final newIndex = currentIndex + direction;

    if (parentPath.isEmpty) {
      // Root level entry
      playgroundState.reorderEntry(entry.id, newIndex);
    } else {
      // Nested entry - move within parent
      playgroundState.reorderEntry(entry.id, newIndex, parentPath.last);
    }
  }

  /// Finds the index of an entry and their parent path.
  (int, List<String>)? _findEntryIndex(
    List<EntryNode> nodes,
    String id, [
    List<String> parentPath = const [],
  ]) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == id) {
        return (i, parentPath);
      }
      if (nodes[i].children.isNotEmpty) {
        final result = _findEntryIndex(
          nodes[i].children,
          id,
          [...parentPath, nodes[i].id],
        );
        if (result != null) return result;
      }
    }
    return null;
  }

  /// Removes the entry.
  void _removeEntry(PlaygroundState playgroundState) {
    playgroundState.removeEntry(entry.id);
  }
}
