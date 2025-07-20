import 'package:example/pages/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

Map<String, ContextMenu> _contextMenus(BuildContext context) => {
      "Default (built-in)": ContextMenu(entries: defaultContextMenuItems),
      "Custom\n\nmax width: 200\npadding: 0": ContextMenu(
        entries: customContextMenuItems,
        maxWidth: 200,
        padding: EdgeInsets.zero,
      ),
      "Custom with box decoration\n\npadding: horizontal(8)": ContextMenu(
        entries: customContextMenuItems,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        boxDecoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.zero,
          boxShadow: const [
            BoxShadow(
              offset: Offset(-5, 5),
              blurRadius: 0.5,
            )
          ],
        ),
      ),
      "Default\n\nposition (x: 50, y: 30)\npadding: 0": ContextMenu(
        entries: defaultContextMenuItems,
        padding: EdgeInsets.zero,
        position: const Offset(50, 30),
      ),
      "Long Menu": ContextMenu(
        entries: getLongContextMenuItems(context),
      ),
    };

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = _contextMenus(context);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Context Menu Demo"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 16 / 9,
        ),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final colors = [
            const Color(0xFF17202a),
            const Color(0xFF1c2833),
            const Color(0xFF212f3d),
            const Color(0xFF273746),
            const Color(0xFF2c3e50),
          ];
          final color = colors[index % colors.length];
          final entry = menus.entries.toList()[index];
          final text = entry.key;
          final menu = entry.value;

          return ContextMenuRegion(
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
