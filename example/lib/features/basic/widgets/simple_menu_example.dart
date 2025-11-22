import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class SimpleMenuExample extends StatelessWidget {
  const SimpleMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion<String>(
      contextMenu: ContextMenu(
        entries: [
          const MenuItem(
            label: 'Copy',
            value: 'copy',
          ),
          const MenuItem(
            label: 'Paste',
            value: 'paste',
          ),
          const MenuDivider(),
          const MenuItem(
            label: 'Share',
            value: 'share',
          ),
        ],
      ),
      onItemSelected: (value) {
        debugPrint('Selected: $value');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: $value')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Right-click or long-press anywhere in this area',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
