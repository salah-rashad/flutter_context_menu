part of 'demo_page.dart';

final _defaultContextMenuItems = 
   <ContextMenuEntry>[
    DefaultContextMenuItem.submenu(
      title: "New",
      icon: Icons.add_rounded,
      items: [
        DefaultContextMenuItem(
          title: "Node",
          value: "Node",
        ),
        DefaultContextMenuItem(
          title: "Item",
          value: "Item",
        ),
        DefaultContextMenuItem(
          title: "Group",
          value: "Group",
        ),
      ],
    ),
    DefaultContextMenuItem(
      title: "Open...",
      value: "Open...",
      icon: Icons.file_open_rounded,
    ),
    DefaultContextMenuItem.submenu(
      title: "View",
      icon: Icons.view_comfy_alt_rounded,
      items: [
        const DefaultContextMenuTextHeader(text: "Visibility"),
        DefaultContextMenuItem(
          title: "Comapct",
          value: "Comapct",
          icon: Icons.view_compact_rounded,
        ),
        DefaultContextMenuItem(
          title: "Comfortable",
          value: "Comfortable",
          icon: Icons.view_comfortable_rounded,
        ),
        const DefaultContextMenuDivider(),
        DefaultContextMenuItem(
          title: "Show Mini Map",
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
