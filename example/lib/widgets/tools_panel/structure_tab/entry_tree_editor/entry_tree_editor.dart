import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';
import '../../../../state/playground_state.dart';
import 'add_entry_dropdown.dart';
import 'entry_empty_state.dart';
import 'entry_item_view.dart';
import 'entry_tree_header.dart';
import 'hoverable_tree_item.dart';
import 'tree_node_utils.dart';

/// Full tree editor for menu entries using the shadcn_flutter TreeView.
///
/// Features:
/// - Tree structure with branch lines
/// - Add button (MenuItem / MenuHeader / MenuDivider)
/// - Expand All / Collapse All
/// - Reorder via move-up / move-down
/// - Delete entries
/// - Selection forwarded to the property panel
class EntryTreeEditor extends StatefulWidget {
  /// Called when the user selects (or deselects) an entry.
  final ValueChanged<EntryNode?>? onEntrySelected;

  /// The currently selected entry ID (drives highlight state).
  final String? selectedEntryId;

  const EntryTreeEditor({
    super.key,
    this.onEntrySelected,
    this.selectedEntryId,
  });

  @override
  State<EntryTreeEditor> createState() => _EntryTreeEditorState();
}

class _EntryTreeEditorState extends State<EntryTreeEditor> {
  List<TreeNode<String>> _treeNodes = [];
  final Map<String, EntryNode> _entryMap = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTreeNodes();
  }

  // ---------------------------------------------------------------------------
  // Tree sync
  // ---------------------------------------------------------------------------

  void _syncTreeNodes() {
    final entries = context.read<PlaygroundState>().entries;
    _entryMap.clear();
    _treeNodes = _buildTreeNodes(entries);
    setState(() {});
  }

  List<TreeNode<String>> _buildTreeNodes(List<EntryNode> entries) =>
      entries.map(_buildTreeNode).toList();

  TreeNode<String> _buildTreeNode(EntryNode entry) {
    _entryMap[entry.id] = entry;
    final isSelected = widget.selectedEntryId == entry.id;

    if (entry.type == EntryType.item &&
        entry.isSubmenu &&
        entry.children.isNotEmpty) {
      return TreeItem(
        data: entry.id,
        expanded: findNodeExpanded(_treeNodes, entry.id) ?? false,
        selected: isSelected,
        children: _buildTreeNodes(entry.children),
      );
    }
    return TreeItem(data: entry.id, selected: isSelected);
  }

  bool _needsResync(List<EntryNode> entries) {
    final currentIds = _entryMap.keys.toSet();
    final newIds = getAllEntryIds(entries);
    return !setEquals(currentIds, newIds);
  }

  // ---------------------------------------------------------------------------
  // Expand / collapse
  // ---------------------------------------------------------------------------

  void _expandAll() => setState(() => _treeNodes = _treeNodes.expandAll());

  void _collapseAll() => setState(() => _treeNodes = _treeNodes.collapseAll());

  // ---------------------------------------------------------------------------
  // Entry actions
  // ---------------------------------------------------------------------------

  void _moveEntry(PlaygroundState state, EntryNode entry, int direction) {
    final result = findEntryIndex(state.entries, entry.id);
    if (result == null) return;

    final newIndex = result.$1 + direction;
    final parentPath = findParentPath(state.entries, entry.id);

    if (parentPath.isEmpty) {
      state.reorderEntry(entry.id, newIndex);
    } else {
      state.reorderEntry(entry.id, newIndex, parentPath.last);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final playgroundState = context.watch<PlaygroundState>();

    if (_needsResync(playgroundState.entries)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncTreeNodes());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EntryTreeHeader(
          canExpandAll: hasCollapsedNodes(_treeNodes),
          canCollapseAll: hasExpandedNodes(_treeNodes),
          onExpandAll: _expandAll,
          onCollapseAll: _collapseAll,
          addButton: Builder(
            builder: (btnCtx) => PrimaryButton(
              onPressed: () => showAddEntryDropdown(
                btnCtx,
                playgroundState,
                widget.onEntrySelected,
              ),
              density: ButtonDensity.icon,
              child: const Icon(LucideIcons.plus, size: 14),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: playgroundState.entries.isEmpty
              ? const EntryEmptyState()
              : _buildTreeView(playgroundState),
        ),
      ],
    );
  }

  Widget _buildTreeView(PlaygroundState playgroundState) {
    return TreeView<String>(
      nodes: _treeNodes,
      branchLine: BranchLine.path,
      recursiveSelection: false,
      allowMultiSelect: false,
      onSelectionChanged: TreeView.defaultSelectionHandler(
        _treeNodes,
        (newNodes) {
          setState(() => _treeNodes = newNodes);
          final selectedId = getSelectedId(newNodes);
          if (selectedId != null) {
            widget.onEntrySelected
                ?.call(findEntryById(playgroundState.entries, selectedId));
          } else {
            widget.onEntrySelected?.call(null);
          }
        },
      ),
      builder: (context, node) {
        final entry = findEntryById(playgroundState.entries, node.data);
        if (entry == null) {
          return const TreeItemView(child: Text('Unknown entry'));
        }

        final indexResult = findEntryIndex(playgroundState.entries, entry.id);
        final canMoveUp = (indexResult?.$1 ?? 0) > 0;
        final canMoveDown =
            indexResult != null && indexResult.$1 < indexResult.$2 - 1;

        return HoverableTreeItem(
          isSelected: widget.selectedEntryId == entry.id,
          onPressed: () => widget.onEntrySelected?.call(entry),
          leading: buildEntryIcon(context, entry),
          trailing: EntryItemTrailing(
            entry: entry,
            canMoveUp: canMoveUp,
            canMoveDown: canMoveDown,
            onMoveUp: () => _moveEntry(playgroundState, entry, -1),
            onMoveDown: () => _moveEntry(playgroundState, entry, 1),
            onDelete: () => playgroundState.removeEntry(entry.id),
          ),
          onExpand: node.leaf
              ? null
              : TreeView.defaultItemExpandHandler(
                  _treeNodes,
                  node,
                  (newNodes) => setState(() => _treeNodes = newNodes),
                ),
          child: buildEntryLabel(entry),
        );
      },
    );
  }
}
