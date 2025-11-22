import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class FileExplorerExample extends StatelessWidget {
  const FileExplorerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion<String>(
      contextMenu: ContextMenu(
        entries: [
          const MenuItem(
            label: 'Open',
            value: 'open',
            icon: Icon(Icons.folder_open, size: 20),
          ),
          const MenuItem(
            label: 'Download',
            value: 'download',
            icon: Icon(Icons.download, size: 20),
          ),
          const MenuDivider(),
          const MenuItem.submenu(
            label: 'Share',
            icon: Icon(Icons.share, size: 20),
            items: [
              MenuItem(
                label: 'Email',
                value: 'share_email',
                icon: Icon(Icons.email, size: 20),
              ),
              MenuItem(
                label: 'Copy link',
                value: 'copy_link',
                icon: Icon(Icons.link, size: 20),
              ),
            ],
          ),
          const MenuDivider(),
          const MenuItem(
            label: 'Rename',
            value: 'rename',
            icon: Icon(Icons.edit, size: 20),
          ),
          const MenuItem(
            label: 'Delete',
            value: 'delete',
            icon: Icon(Icons.delete, size: 20, color: Colors.red),
            textColor: Colors.red,
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
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            const Text(
              'document.pdf',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '2.4 MB • PDF',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Right-click to see file context menu',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
