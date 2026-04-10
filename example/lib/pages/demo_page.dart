import 'package:example/pages/menu_items.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

Map<String, ContextMenu<String>> _contextMenus(BuildContext context) => {
      "Default (built-in)":
          ContextMenu<String>(entries: defaultContextMenuItems),
      "Custom\n\nmax width: 200\npadding: 0": ContextMenu(
        entries: customContextMenuItems,
        maxWidth: 200,
        padding: EdgeInsets.zero,
      ),
      "Custom with box decoration\n\npadding: horizontal(8)":
          ContextMenu<String>(
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
      "Default\n\nposition (x: 50, y: 30)\npadding: 0": ContextMenu<String>(
        entries: defaultContextMenuItems,
        padding: EdgeInsets.zero,
        position: const Offset(50, 30),
      ),
      "Long Menu": ContextMenu(
        entries: getLongContextMenuItems(context),
      ),
    };

/// A widget that demonstrates checkable menu items with state management.
class CheckableMenuDemo extends StatefulWidget {
  const CheckableMenuDemo({super.key});

  @override
  State<CheckableMenuDemo> createState() => _CheckableMenuDemoState();
}

class _CheckableMenuDemoState extends State<CheckableMenuDemo> {
  // Use ValueNotifier for reactive updates while the menu is open
  final ValueNotifier<bool> _showGrid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _snapToGuides = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _autoSave = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _darkMode = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _showGrid.dispose();
    _snapToGuides.dispose();
    _autoSave.dispose();
    _darkMode.dispose();
    super.dispose();
  }

  ContextMenu<String> _buildCheckableMenu() {
    return ContextMenu<String>(
      entries: [
        const MenuHeader(text: "View Options"),
        CheckableMenuItem(
          label: const Text("Show grid"),
          checkedNotifier: _showGrid,
          onToggle: (value) => _showGrid.value = value,
        ),
        CheckableMenuItem(
          label: const Text("Snap to guides"),
          checkedNotifier: _snapToGuides,
          onToggle: (value) => _snapToGuides.value = value,
        ),
        CheckableMenuItem(
          label: const Text("Auto-save"),
          checkedNotifier: _autoSave,
          shortcut:
              const SingleActivator(LogicalKeyboardKey.keyS, control: true),
          onToggle: (value) => _autoSave.value = value,
        ),
        CheckableMenuItem(
          label: const Text("Disabled option"),
          checked: true,
          enabled: false,
          onToggle: (value) {}, // Won't be called since enabled=false
        ),
        const MenuDivider(),
        MenuItem.submenu(
          label: const Text("More Settings"),
          icon: const Icon(Icons.settings),
          items: [
            CheckableMenuItem(
              label: const Text("Dark mode"),
              checkedNotifier: _darkMode,
              icon: const Icon(Icons.dark_mode),
              onToggle: (value) => _darkMode.value = value,
            ),
            const MenuDivider(),
            const MenuHeader(text: "Nested Options"),
            CheckableMenuItem(
              label: const Text("Enable notifications"),
              checked: false,
              onToggle: (value) {},
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: _buildCheckableMenu(),
      onItemSelected: (value) {
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
      },
      routeOptions: const MenuRouteOptions(
        routeSettings: RouteSettings(name: "/checkable-menu"),
      ),
      child: Container(
        color: const Color(0xFF1a237e),
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Checkable Menu Items\n\nToggle without closing",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              _ValueListenableBuilder3<bool, bool, bool>(
                first: _showGrid,
                second: _snapToGuides,
                third: _autoSave,
                builder: (context, showGrid, snapToGuides, autoSave, child) {
                  return Text(
                    "Grid: ${showGrid ? '✓' : '✗'} | Snap: ${snapToGuides ? '✓' : '✗'} | Auto-save: ${autoSave ? '✓' : '✗'}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A helper widget that listens to 3 ValueListenables.
class _ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget Function(BuildContext context, A a, B b, C c, Widget? child)
      builder;
  final Widget? child;

  const _ValueListenableBuilder3({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, child) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, child) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, c, child) {
                return builder(context, a, b, c, child);
              },
              child: child,
            );
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

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
        itemCount: menus.length + 1, // +1 for checkable menu demo
        itemBuilder: (context, index) {
          // Add checkable menu demo as the first item
          if (index == 0) {
            return const CheckableMenuDemo();
          }

          final colors = [
            const Color(0xFF17202a),
            const Color(0xFF1c2833),
            const Color(0xFF212f3d),
            const Color(0xFF273746),
            const Color(0xFF2c3e50),
          ];
          final color = colors[(index - 1) % colors.length];
          final entry = menus.entries.toList()[index - 1];
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
