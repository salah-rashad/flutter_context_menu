import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';

/// Returns true if both sets contain the same elements.
bool setEquals<T>(Set<T> a, Set<T> b) {
  if (a.length != b.length) return false;
  return a.containsAll(b);
}

/// Collects all entry IDs recursively.
Set<String> getAllEntryIds(List<EntryNode> entries) {
  final ids = <String>{};
  for (final entry in entries) {
    ids.add(entry.id);
    if (entry.children.isNotEmpty) {
      ids.addAll(getAllEntryIds(entry.children));
    }
  }
  return ids;
}

/// Returns the data of the first selected node in the tree, or null.
String? getSelectedId(List<TreeNode<String>> nodes) {
  for (final node in nodes) {
    if (node is TreeItem<String> && node.selected) {
      return node.data;
    }
    if (node.children.isNotEmpty) {
      final result = getSelectedId(node.children);
      if (result != null) return result;
    }
  }
  return null;
}

/// Recursively finds an entry by ID.
EntryNode? findEntryById(List<EntryNode> entries, String id) {
  for (final entry in entries) {
    if (entry.id == id) return entry;
    if (entry.children.isNotEmpty) {
      final found = findEntryById(entry.children, id);
      if (found != null) return found;
    }
  }
  return null;
}

/// Returns the (index, siblingCount) of an entry, or null if not found.
(int, int)? findEntryIndex(List<EntryNode> entries, String id) {
  for (int i = 0; i < entries.length; i++) {
    if (entries[i].id == id) {
      return (i, entries.length);
    }
    if (entries[i].children.isNotEmpty) {
      final result = findEntryIndex(entries[i].children, id);
      if (result != null) return result;
    }
  }
  return null;
}

/// Returns the chain of parent IDs leading to [id], or an empty list.
List<String> findParentPath(List<EntryNode> entries, String id) {
  for (final entry in entries) {
    if (entry.children.any((child) => child.id == id)) {
      return [entry.id];
    }
    if (entry.children.isNotEmpty) {
      final path = findParentPath(entry.children, id);
      if (path.isNotEmpty) {
        return [entry.id, ...path];
      }
    }
  }
  return [];
}

/// Returns the expanded state of the node with [entryId], or null if not found.
bool? findNodeExpanded(List<TreeNode<String>> nodes, String entryId) {
  for (final node in nodes) {
    if (node is TreeItem<String>) {
      if (node.data == entryId) return node.expanded;
      if (node.children.isNotEmpty) {
        final result = findNodeExpanded(node.children, entryId);
        if (result != null) return result;
      }
    }
  }
  return null;
}

/// Returns true if any node in the tree is collapsed (has children and is not expanded).
bool hasCollapsedNodes(List<TreeNode<String>> nodes) {
  for (final node in nodes) {
    if (node is TreeItem<String>) {
      if (node.children.isNotEmpty && !node.expanded) return true;
      if (hasCollapsedNodes(node.children)) return true;
    }
  }
  return false;
}

/// Returns true if any node in the tree is expanded.
bool hasExpandedNodes(List<TreeNode<String>> nodes) {
  for (final node in nodes) {
    if (node is TreeItem<String>) {
      if (node.expanded) return true;
      if (hasExpandedNodes(node.children)) return true;
    }
  }
  return false;
}
