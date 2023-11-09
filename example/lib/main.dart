import 'package:example/pages/demo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Context Menu Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

final entries = <ContextMenuEntry>[
  const MenuHeader(text: "Context Menu"),
  MenuItem(
    label: 'Copy',
    icon: Icons.copy,
    onSelected: () {
      // implement copy
    },
  ),
  MenuItem(
    label: 'Paste',
    icon: Icons.paste,
    onSelected: () {
      // implement paste
    },
  ),
  const MenuDivider(),
  MenuItem.submenu(
    label: 'Edit',
    icon: Icons.edit,
    items: [
      MenuItem(
        label: 'Undo',
        value: "Undo",
        icon: Icons.undo,
        onSelected: () {
          // implement undo
        },
      ),
      MenuItem(
        label: 'Redo',
        value: 'Redo',
        icon: Icons.redo,
        onSelected: () {
          // implement redo
        },
      ),
    ],
  ),
];

final contextMenu = ContextMenu(
  entries: entries,
  position: const Offset(300, 300),
  padding: const EdgeInsets.all(8.0),
);

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      ContextMenuRegion(
        contextMenu: contextMenu,
        onItemSelected: (value) {
          print(value);
        },
        child: Container(
          color: Colors.indigo,
          height: 300,
          width: 300,
          child: const Center(
            child: Text(
              'Right click or long press!',
            ),
          ),
        ),
      )
    ],
  );
}
