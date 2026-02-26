import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../entries/custom_context_menu_item.dart';

const _openShortcut = SingleActivator(LogicalKeyboardKey.keyO, control: true);
const _copyShortcut = SingleActivator(LogicalKeyboardKey.keyC, control: true);
const _pasteShortcut = SingleActivator(LogicalKeyboardKey.keyV, control: true);
const _cutShortcut = SingleActivator(LogicalKeyboardKey.keyX, control: true);
const _selectAllShortcut =
    SingleActivator(LogicalKeyboardKey.keyA, control: true);
const _deleteShortcut = SingleActivator(LogicalKeyboardKey.delete);
const _undoShortcut = SingleActivator(LogicalKeyboardKey.keyZ, control: true);
const _redoShortcut =
    SingleActivator(LogicalKeyboardKey.keyZ, control: true, shift: true);
const _exitShortcut = SingleActivator(LogicalKeyboardKey.f4, alt: true);
const _viewCompactShortcut = SingleActivator(LogicalKeyboardKey.numpadSubtract,
    control: true, alt: true);
const _viewComfortableShortcut =
    SingleActivator(LogicalKeyboardKey.numpadAdd, control: true, alt: true);

const defaultContextMenuItems = <ContextMenuEntry<String>>[
  MenuItem.submenu(
    label: Text("New"),
    icon: Icon(Icons.add_rounded),
    textColor: Colors.green,
    items: [
      MenuItem(
        label: Text("Node"),
        value: "Node",
      ),
      MenuItem(
        label: Text("Item"),
        value: "Item",
      ),
      MenuItem(
        enabled: false,
        label: Text("Group"),
        value: "Group",
      ),
    ],
  ),
  MenuItem(
    label: Text("Open..."),
    value: "Open...",
    icon: Icon(Icons.folder_outlined),
    shortcut: _openShortcut,
  ),
  MenuItem.submenu(
    label: Text("View"),
    icon: Icon(Icons.view_comfy_alt_rounded),
    items: [
      MenuHeader(text: "Visibility"),
      MenuItem(
        label: Text("Comapct"),
        value: "Comapct",
        icon: Icon(Icons.view_compact_rounded),
        shortcut: _viewCompactShortcut,
      ),
      MenuItem(
        label: Text("Comfortable"),
        value: "Comfortable",
        icon: Icon(Icons.view_comfortable_rounded),
        shortcut: _viewComfortableShortcut,
      ),
      MenuDivider(),
      MenuItem.submenu(
          label: Text("Mini Map"),
          icon: Icon(Icons.screen_search_desktop_rounded),
          items: [
            MenuItem(
              label: Text("Show"),
              value: "Show",
            ),
            MenuItem(
              enabled: false,
              label: Text("Hide"),
              value: "Hide",
            ),
            MenuItem.submenu(label: Text("Position"), items: [
              MenuItem(
                label: Text("Left"),
                value: "Left",
              ),
              MenuItem(
                label: Text("Right"),
                value: "Right",
              ),
              MenuItem(
                label: Text("Top"),
                value: "Top",
              ),
              MenuItem(
                label: Text("Bottom"),
                value: "Bottom",
              ),
              MenuItem(
                label: Text("Center"),
                value: "Center",
              ),
            ]),
          ]),
    ],
  ),
  MenuHeader(text: "Edit"),
  MenuItem(
    label: Text("Copy"),
    value: "Copy",
    icon: Icon(Icons.copy_rounded),
    shortcut: _copyShortcut,
  ),
  MenuItem(
    label: Text("Paste"),
    value: "Paste",
    icon: Icon(Icons.paste_rounded),
    shortcut: _pasteShortcut,
  ),
  MenuItem(
    label: Text("Cut"),
    value: "Cut",
    icon: Icon(Icons.cut_rounded),
    shortcut: _cutShortcut,
  ),
  MenuItem(
    label: Text("Select All"),
    value: "Select All",
    icon: Icon(Icons.select_all_rounded),
    shortcut: _selectAllShortcut,
  ),
  MenuItem(
    label: Text("Delete"),
    value: "Delete",
    icon: Icon(Icons.delete_rounded),
    shortcut: _deleteShortcut,
  ),
  MenuDivider(),
  MenuHeader(text: "History"),
  MenuItem(
    label: Text("Undo"),
    value: "Undo",
    icon: Icon(Icons.undo_rounded),
    shortcut: _undoShortcut,
  ),
  MenuItem(
    label: Text("Redo"),
    value: "Redo",
    icon: Icon(Icons.redo_rounded),
    shortcut: _redoShortcut,
  ),
  MenuDivider(),
  MenuItem(
    label: Text("Exit"),
    value: "Exit",
    icon: Icon(Icons.exit_to_app_rounded),
    shortcut: _exitShortcut,
  ),
];

const customContextMenuItems = <ContextMenuEntry<String>>[
  CustomContextMenuItem(
    label: "SPIRO SPATHIS",
    value: "SPIRO SPATHIS",
    subtitle: "First Soda Water in Egypt – Since 1920",
    icon: Icons.local_drink_rounded,
  ),
  CustomContextMenuItem.submenu(
    label: "Food",
    icon: Icons.dining_rounded,
    items: [
      CustomContextMenuItem.submenu(
        label: "Fruits",
        subtitle: "Healthy",
        items: [
          CustomContextMenuItem(
            label: "Apple",
            value: "Apple",
            subtitle: "Red",
            icon: Icons.star_rounded,
          ),
          CustomContextMenuItem(
            label: "Orange",
            value: "Orange",
            subtitle: "Orange",
            icon: Icons.star_rounded,
          ),
          CustomContextMenuItem(
            label: "Banana",
            value: "Banana",
            subtitle: "Yellow",
            icon: Icons.star_rounded,
          ),
          CustomContextMenuItem(
            label: "Strawberry",
            value: "Strawberry",
            subtitle: "Red",
            icon: Icons.star_rounded,
          ),
          CustomContextMenuItem(
            label: "Watermelon",
            value: "Watermelon",
            subtitle: "Green",
            icon: Icons.star_rounded,
          )
        ],
      ),
      CustomContextMenuItem.submenu(
        label: "Vegetables",
        subtitle: "Healthier",
        items: [
          CustomContextMenuItem(
            label: "Carrot",
            value: "Carrot",
            subtitle: "Orange",
            icon: Icons.star_rounded,
          ),
          CustomContextMenuItem.submenu(
              label: "Potato",
              subtitle: "Brown",
              icon: Icons.star_rounded,
              items: [
                CustomContextMenuItem(
                  label: "Sweet",
                  value: "Sweet",
                  subtitle: "Sweet",
                  icon: Icons.star_rounded,
                ),
                CustomContextMenuItem(
                  label: "Sour",
                  value: "Sour",
                  subtitle: "Sour",
                  icon: Icons.star_rounded,
                ),
                CustomContextMenuItem(
                  label: "Salty",
                  value: "Salty",
                  subtitle: "Salty",
                  icon: Icons.star_rounded,
                ),
              ]),
          CustomContextMenuItem(
            label: "Cucumber",
            value: "Cucumber",
            subtitle: "Green",
            icon: Icons.star_rounded,
          ),
        ],
      ),
    ],
  ),
];

List<ContextMenuEntry<String>> getLongContextMenuItems(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final itemsCount = (screenSize.height / kMenuItemHeight).floor() * 1.5;
  final items = <ContextMenuEntry<String>>[];

  for (int i = 1; i <= itemsCount; i++) {
    items.add(MenuItem(
      label: Text("Item $i"),
      value: "Item $i",
      icon: Icon(i % 2 == 0 ? Icons.star_rounded : Icons.circle),
      textColor: i % 3 == 0 ? Colors.blue : null,
      enabled: i % 5 != 0,
    ));
  }
  items.add(const MenuDivider());
  items.add(MenuItem.submenu(
    label: const Text("More Options"),
    icon: const Icon(Icons.more_horiz),
    items: [
      for (int j = 1; j <= 10; j++)
        MenuItem(
          label: Text("Option $j"),
          value: "Option $j",
          icon: const Icon(Icons.settings),
        ),
    ],
  ));

  return items;
}
