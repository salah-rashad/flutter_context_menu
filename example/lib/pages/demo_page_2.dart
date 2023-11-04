part of 'demo_page.dart';

final _defaultContextMenuItems = <ContextMenuEntry>[
  DefaultContextMenuItem.submenu(
    label: "New",
    icon: Icons.add_rounded,
    items: [
      DefaultContextMenuItem(
        label: "Node",
        value: "Node",
      ),
      DefaultContextMenuItem(
        label: "Item",
        value: "Item",
      ),
      DefaultContextMenuItem(
        label: "Group",
        value: "Group",
      ),
    ],
  ),
  DefaultContextMenuItem(
    label: "Open...",
    value: "Open...",
    icon: Icons.file_open_rounded,
  ),
  DefaultContextMenuItem.submenu(
    label: "View",
    icon: Icons.view_comfy_alt_rounded,
    items: [
      const DefaultContextMenuTextHeader(text: "Visibility"),
      DefaultContextMenuItem(
        label: "Comapct",
        value: "Comapct",
        icon: Icons.view_compact_rounded,
      ),
      DefaultContextMenuItem(
        label: "Comfortable",
        value: "Comfortable",
        icon: Icons.view_comfortable_rounded,
      ),
      const DefaultContextMenuDivider(),
      DefaultContextMenuItem(
        label: "Show Mini Map",
        value: "Show Mini Map",
        icon: Icons.screen_search_desktop_rounded,
      ),
    ],
  ),
];

final _customContextMenuItems = <ContextMenuEntry>[
  CustomContextMenuItem(label: "First", value: "First"),
  CustomContextMenuItem.submenu(
    label: "menu 1",
    items: [
      CustomContextMenuItem.submenu(
        label: "menu 2",
        items: [
          CustomContextMenuItem.submenu(label: "menu 3", items: [
            CustomContextMenuItem(label: "item 1", value: "item 1"),
            CustomContextMenuItem(label: "item 2", value: "item 2"),
            CustomContextMenuItem(label: "item 3", value: "item 3"),
          ]),
        ],
      ),
    ],
  ),
];
