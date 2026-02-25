import 'package:example/pages/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

Map<String, ContextMenu> _contextMenus(BuildContext context) => {
      // Uses global style from MaterialApp (grey.shade900 surface, 12px radius)
      "Uses Global Style\n\n(Theme Extension)":
          const ContextMenu(entries: defaultContextMenuItems),

      // Inline style override: different borderRadius while keeping other global style values
      "Custom menu items that doesn't follow the menu item style override\n\n"
          "Inline Overrides:\n\n"
          "borderRadius: 4": const ContextMenu(
        entries: customContextMenuItems,
        style: ContextMenuStyle(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),

      // Full inline style: completely replaces global style
      "Full Override\n\nblue surface, no shadow": ContextMenu(
        entries: customContextMenuItems,
        style: ContextMenuStyle(
          surfaceColor: Colors.blue.shade900,
          borderRadius: BorderRadius.zero,
          shadowColor: Colors.black,
          shadowOffset: const Offset(-5, 5),
          shadowBlurRadius: 0.5,
          menuItemStyle: MenuItemStyle(
            textColor: Colors.white,
            focusedTextColor: Colors.white,
          ),
        ),
      ),

      // Inline override with specific position
      "Position Override\n\n(x: 50, y: 30)": const ContextMenu(
        entries: defaultContextMenuItems,
        position: Offset(50, 30),
      ),

      // Long menu demonstrating scrolling with global style
      "Long Menu": ContextMenu(
        entries: getLongContextMenuItems(context),
      ),

      "ContextMenuTheme\n\nInheritedWidget override":
          const ContextMenu(entries: defaultContextMenuItems),
    };

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  static const _tileColors = [
    Color(0xFF17202a),
    Color(0xFF1c2833),
    Color(0xFF212f3d),
    Color(0xFF273746),
    Color(0xFF2c3e50),
    Color(0xff34485e),
  ];

  @override
  Widget build(BuildContext context) {
    final menus = _contextMenus(context);
    final totalItems = menus.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Context Menu Demo"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 16 / 9,
        ),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          final color = _tileColors[index % _tileColors.length];

          // // Last tile: ContextMenuTheme InheritedWidget demo
          // if (index == menus.length) {
          //   return _buildInheritedThemeTile(context, color);
          // }

          final entry = menus.entries.toList()[index];
          final text = entry.key;
          final menu = entry.value;

          final item = ContextMenuRegion(
            contextMenu: menu,
            onItemSelected: (value) => onItemSelected(context, value),
            routeOptions: const MenuRouteOptions(
              routeSettings: RouteSettings(name: "/menu"),
            ),
            child: Container(
              color: color,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );

          // Last tile: ContextMenuTheme InheritedWidget demo
          if (index == menus.length - 1) {
            return _buildInheritedThemeTile(item);
          }

          return item;
        },
      ),
    );
  }

  /// Demonstrates using [ContextMenuTheme] InheritedWidget to override the
  /// style for a specific subtree, independent of the global ThemeExtension.
  Widget _buildInheritedThemeTile(Widget item) {
    return ContextMenuTheme(
      style: ContextMenuStyle(
        surfaceColor: Colors.teal.shade900,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        shadowColor: Colors.tealAccent.withValues(alpha: 0.3),
        menuItemStyle: MenuItemStyle(
          borderRadius: BorderRadius.circular(16.0),
        ),
        menuHeaderStyle: const MenuHeaderStyle(
          textColor: Colors.tealAccent,
        ),
        menuDividerStyle: MenuDividerStyle(
          color: Colors.tealAccent.withValues(alpha: 0.3),
        ),
      ),
      child: item,
    );
  }

  void onItemSelected(BuildContext context, dynamic value) {
    if (value == null) return;
    ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "[ $value ] Selected",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
