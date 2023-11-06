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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

final entries = <ContextMenuEntry>[
  const MenuHeader(text: "Menu Header"),
  MenuItem(
    label: 'Copy',
    icon: Icons.copy,
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

final myContextMenu = ContextMenu(
  entries: entries,
  position: const Offset(300, 300),
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
);
