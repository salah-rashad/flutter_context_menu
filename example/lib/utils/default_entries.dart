import 'package:flutter/material.dart';

import '../state/entry_node.dart';

/// Creates default sample entries for the playground.
///
/// Provides a representative set of entries demonstrating:
/// - Menu headers
/// - Menu items with icons and shortcuts
/// - Menu dividers
/// - Submenus
/// - Disabled items
List<EntryNode> createDefaultEntries() {
  return const [
    // Header
    EntryNode(
      id: 'entry-1',
      type: EntryType.header,
      label: 'File',
    ),
    // Items with icons and shortcuts
    EntryNode(
      id: 'entry-2',
      type: EntryType.item,
      label: 'New File',
      icon: Icons.add,
      shortcutLabel: 'Ctrl+N',
      value: 'new_file',
    ),
    EntryNode(
      id: 'entry-3',
      type: EntryType.item,
      label: 'Open',
      icon: Icons.folder_open,
      shortcutLabel: 'Ctrl+O',
      value: 'open',
    ),
    EntryNode(
      id: 'entry-4',
      type: EntryType.item,
      label: 'Save',
      icon: Icons.save,
      shortcutLabel: 'Ctrl+S',
      value: 'save',
    ),
    // Divider
    EntryNode(
      id: 'entry-5',
      type: EntryType.divider,
    ),
    // Submenu
    EntryNode(
      id: 'entry-6',
      type: EntryType.item,
      label: 'Recent Files',
      icon: Icons.history,
      isSubmenu: true,
      children: [
        EntryNode(
          id: 'entry-6-1',
          type: EntryType.item,
          label: 'document.txt',
          value: 'recent_1',
        ),
        EntryNode(
          id: 'entry-6-2',
          type: EntryType.item,
          label: 'image.png',
          value: 'recent_2',
        ),
        EntryNode(
          id: 'entry-6-3',
          type: EntryType.item,
          label: 'data.csv',
          value: 'recent_3',
        ),
      ],
    ),
    // Divider
    EntryNode(
      id: 'entry-7',
      type: EntryType.divider,
    ),
    // Disabled item
    EntryNode(
      id: 'entry-8',
      type: EntryType.item,
      label: 'Exit',
      icon: Icons.close,
      value: 'exit',
      enabled: false,
    ),
  ];
}
