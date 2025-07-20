import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../entries/custom_context_menu_item.dart';

const defaultContextMenuItems = <ContextMenuEntry>[
  MenuItem.submenu(
    label: "New",
    icon: Icons.add_rounded,
    color: Colors.green,
    items: [
      MenuItem(
        label: "Node",
        value: "Node",
      ),
      MenuItem(
        label: "Item",
        value: "Item",
      ),
      MenuItem(
        enabled: false,
        label: "Group",
        value: "Group",
      ),
    ],
  ),
  MenuItem(
    label: "Open...",
    value: "Open...",
    icon: Icons.file_open_rounded,
  ),
  MenuItem.submenu(
    label: "View",
    icon: Icons.view_comfy_alt_rounded,
    items: [
      MenuHeader(text: "Visibility"),
      MenuItem(
        label: "Comapct",
        value: "Comapct",
        icon: Icons.view_compact_rounded,
      ),
      MenuItem(
        label: "Comfortable",
        value: "Comfortable",
        icon: Icons.view_comfortable_rounded,
      ),
      MenuDivider(),
      MenuItem.submenu(
          label: "Show Mini Map",
          icon: Icons.screen_search_desktop_rounded,
          items: [
            MenuItem(
              label: "Show",
              value: "Show",
            ),
            MenuItem(
              enabled: false,
              label: "Hide",
              value: "Hide",
            ),
            MenuItem.submenu(label: "Position", items: [
              MenuItem(
                label: "Left",
                value: "Left",
              ),
              MenuItem(
                label: "Right",
                value: "Right",
              ),
              MenuItem(
                label: "Top",
                value: "Top",
              ),
              MenuItem(
                label: "Bottom",
                value: "Bottom",
              ),
              MenuItem(
                label: "Center",
                value: "Center",
              ),
            ]),
          ]),
    ],
  ),
];

const customContextMenuItems = <ContextMenuEntry>[
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

List<ContextMenuEntry> getLongContextMenuItems(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  const itemHeight = 32.0;
  final itemsCount = (screenSize.height / itemHeight).floor() * 1.5;
  final items = <ContextMenuEntry>[];

  for (int i = 1; i <= itemsCount; i++) {
    items.add(MenuItem(
      label: "Item $i",
      value: "Item $i",
      icon: i % 2 == 0 ? Icons.star_rounded : Icons.circle,
      color: i % 3 == 0 ? Colors.blue : null,
      enabled: i % 5 != 0,
    ));
  }
  items.add(const MenuDivider());
  items.add(MenuItem.submenu(
    label: "More Options",
    icon: Icons.more_horiz,
    items: [
      for (int j = 1; j <= 10; j++)
        MenuItem(
          label: "Option $j",
          value: "Option $j",
          icon: Icons.settings,
        ),
    ],
  ));

  return items;
}
