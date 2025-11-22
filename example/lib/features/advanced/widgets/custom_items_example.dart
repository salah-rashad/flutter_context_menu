import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../../entries/switch_menu_item.dart';

class CustomItemsExample extends StatefulWidget {
  const CustomItemsExample({super.key});

  @override
  State<CustomItemsExample> createState() => _CustomItemsExampleState();
}

class _CustomItemsExampleState extends State<CustomItemsExample> {
  bool darkMode = false;
  bool notifications = true;
  bool autoSave = false;

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenu<dynamic>(
        entries: _menuEntries(context),
      ),
      onItemSelected: _onItemSelected,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Right-click or long-press to see custom menu items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSetting('Dark Mode', darkMode, Icons.dark_mode_outlined),
            _buildSetting(
                'Notifications', notifications, Icons.notifications_none),
            _buildSetting('Auto-save', autoSave, Icons.save_outlined),
          ],
        ),
      ),
    );
  }

  List<ContextMenuEntry<dynamic>> _menuEntries(BuildContext context) {
    return [
      const MenuHeader(text: 'Appearance'),
      SwitchMenuItem(
        label: 'Dark Mode',
        value: darkMode,
        icon: const Icon(Icons.dark_mode_outlined),
        onChanged: (value) {
          if (value == null) return;
          setState(() => darkMode = value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dark Mode ${value ? 'Enabled' : 'Disabled'}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
      const MenuDivider(),
      const MenuHeader(text: 'Preferences'),
      SwitchMenuItem(
        label: 'Enable Notifications',
        value: notifications,
        icon: const Icon(Icons.notifications_none),
        onChanged: (value) {
          if (value == null) return;
          setState(() => notifications = value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notifications ${value ? 'Enabled' : 'Disabled'}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
      SwitchMenuItem(
        label: 'Auto-save Changes',
        value: autoSave,
        icon: const Icon(Icons.save_outlined),
        onChanged: (value) {
          if (value == null) return;
          setState(() => autoSave = value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Auto-save ${value ? 'Enabled' : 'Disabled'}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
      const MenuDivider(),
      const MenuItem(
        label: 'Reset to Defaults',
        value: 'reset',
        icon: Icon(Icons.restore_outlined),
      ),
    ];
  }

  Widget _buildSetting(String label, bool value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).hintColor),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value ? 'Enabled' : 'Disabled',
            style: Theme.of(context).textTheme.bodyMedium?.apply(
                  color: value ? Colors.green : Colors.red,
                ),
          ),
        ],
      ),
    );
  }

  void _onItemSelected(value) {
    if (value == 'reset') {
      setState(() {
        darkMode = false;
        notifications = true;
        autoSave = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings reset to defaults'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
