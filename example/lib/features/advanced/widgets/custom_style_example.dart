import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class CustomStyleExample extends StatelessWidget {
  const CustomStyleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion<String>(
      contextMenu: ContextMenu(
        entries: const [
          MenuItem(
            label: 'Copy',
            value: 'copy',
            icon: Icon(Icons.content_copy, size: 20),
          ),
          MenuItem(
            label: 'Paste',
            value: 'paste',
            icon: Icon(Icons.content_paste, size: 20),
          ),
          MenuDivider(),
          MenuItem(
            label: 'Share',
            value: 'share',
            icon: Icon(Icons.share, size: 20),
          ),
          MenuItem(
            label: 'Delete',
            value: 'delete',
            icon: Icon(Icons.delete, size: 20, color: Colors.red),
            textColor: Colors.red,
          ),
          MenuDivider(),
          MenuItem(
            label: 'Rename',
            value: 'rename',
            icon: Icon(Icons.edit, size: 20),
          ),
          MenuItem(
            label: 'Move',
            value: 'move',
            icon: Icon(Icons.move_to_inbox, size: 20),
          ),
          MenuItem(
            label: 'Properties',
            value: 'properties',
            icon: Icon(Icons.info, size: 20),
          ),
          MenuDivider(),
          MenuItem(
            label: 'Exit',
            value: 'exit',
            icon: Icon(Icons.exit_to_app, size: 20),
          ),
        ],
        boxDecoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.zero,
        maxHeight: 200,
      ),
      onItemSelected: (value) {
        debugPrint('Selected: $value');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: $value')),
        );
      },
      enableDefaultGestures: false,
      builder: (context, contextMenu, pointerPosition, showMenu, child) {
        return GestureDetector(
          onLongPressEnd: (details) {
            showMenu(details.globalPosition);
          },
          onDoubleTapDown: (details) {
            showMenu(details.globalPosition);
          },
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          '"Double tap" or "long press" to see custom styled menu, ',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
