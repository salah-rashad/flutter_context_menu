import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class MenuWithIconsExample extends StatelessWidget {
  const MenuWithIconsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion<String>(
      contextMenu: ContextMenu(
        entries: [
          const MenuItem(
            label: 'Copy',
            value: 'copy',
            icon: Icon(Icons.content_copy, size: 20),
          ),
          const MenuItem(
            label: 'Cut',
            value: 'cut',
            icon: Icon(Icons.content_cut, size: 20),
          ),
          const MenuItem(
            label: 'Paste',
            value: 'paste',
            icon: Icon(Icons.content_paste, size: 20),
          ),
          const MenuDivider(),
          const MenuItem(
            label: 'Share',
            value: 'share',
            icon: Icon(Icons.share, size: 20),
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
          'Right-click or long-press to see menu with icons',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
