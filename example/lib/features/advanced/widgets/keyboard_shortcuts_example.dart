import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class KeyboardShortcutsExample extends StatefulWidget {
  const KeyboardShortcutsExample({super.key});

  @override
  State<KeyboardShortcutsExample> createState() =>
      _KeyboardShortcutsExampleState();
}

class _KeyboardShortcutsExampleState extends State<KeyboardShortcutsExample> {
  final String defaultText = 'Hello World';
  late final TextEditingController _textController;
  String _lastAction = 'No action performed yet';
  TextStyle _textFieldStyle = const TextStyle();
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  final entries = const <ContextMenuEntry<String>>[
    MenuHeader(text: 'Edit'),
    MenuItem(
      label: 'Undo',
      value: 'undo',
      icon: Icon(Icons.undo, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyZ,
        control: true,
      ),
    ),
    MenuItem(
      label: 'Redo',
      value: 'redo',
      icon: Icon(Icons.redo, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyZ,
        control: true,
        shift: true,
      ),
    ),
    MenuDivider(),
    MenuItem(
      label: 'Cut',
      value: 'cut',
      icon: Icon(Icons.content_cut, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyX,
        control: true,
      ),
    ),
    MenuItem(
      label: 'Copy',
      value: 'copy',
      icon: Icon(Icons.content_copy, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyC,
        control: true,
      ),
    ),
    MenuItem(
      label: 'Paste',
      value: 'paste',
      icon: Icon(Icons.content_paste, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyV,
        control: true,
      ),
    ),
    MenuDivider(),
    MenuHeader(text: 'Format'),
    MenuItem(
      label: 'Bold',
      value: 'bold',
      icon: Icon(Icons.format_bold, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyB,
        control: true,
      ),
    ),
    MenuItem(
      label: 'Italic',
      value: 'italic',
      icon: Icon(Icons.format_italic, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyI,
        control: true,
      ),
    ),
    MenuItem(
      label: 'Underline',
      value: 'underline',
      icon: Icon(Icons.format_underline, size: 20),
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyU,
        control: true,
      ),
    ),
  ];

  @override
  void initState() {
    _textController = TextEditingController(text: defaultText);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onItemSelected(String? action) {
    if (action == null) return;
    setState(() {
      _lastAction = 'Last action: $action';
      _applyAction(action);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: $action'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: ContextMenu(
        entries: entries,
      ),
      onItemSelected: (value) {
        // Handle menu item selection
        debugPrint('Selected: $value');
        _onItemSelected(value);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Editor with Keyboard Shortcuts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Right-click or long-press to see available actions with their keyboard shortcuts',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              showCursor: true,
              controller: _textController,
              maxLines: 5,
              style: _textFieldStyle,
              // onTap: () {
              //   showContextMenu<String>(
              //     context,
              //     contextMenu: ContextMenu(entries: entries),
              //     onItemSelected: _onItemSelected,
              //   );
              // },
              contextMenuBuilder: (context, editableTextState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showContextMenu<String>(
                    context,
                    contextMenu: ContextMenu(entries: entries),
                    onItemSelected: _onItemSelected,
                  );
                });
                return const SizedBox.shrink();
              },
              decoration: InputDecoration(
                // hintText: 'Type here and try the context menu actions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _lastAction,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try these shortcuts:\n'
              '• Ctrl+Z - Undo\n'
              '• Ctrl+Shift+Z - Redo\n'
              '• Ctrl+X - Cut\n'
              '• Ctrl+C - Copy\n'
              '• Ctrl+V - Paste\n'
              '• Ctrl+B - Bold\n'
              '• Ctrl+I - Italic\n'
              '• Ctrl+U - Underline',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyAction(String action) async {
    if (action == 'bold') {
      _isBold = !_isBold;
      _textFieldStyle = _textFieldStyle.copyWith(
        fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      );
    } else if (action == 'italic') {
      _isItalic = !_isItalic;
      _textFieldStyle = _textFieldStyle.copyWith(
        fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      );
    } else if (action == 'underline') {
      _isUnderline = !_isUnderline;
      _textFieldStyle = _textFieldStyle.copyWith(
        decoration:
            _isUnderline ? TextDecoration.underline : TextDecoration.none,
      );
    } else if (action == 'cut') {
      final text = _textController.text.substring(
          _textController.selection.start, _textController.selection.end);
      await Clipboard.setData(ClipboardData(text: text));
      _textController.text = _textController.text.replaceRange(
          _textController.selection.start, _textController.selection.end, '');
    } else if (action == 'copy') {
      final text = _textController.text.substring(
          _textController.selection.start, _textController.selection.end);
      await Clipboard.setData(ClipboardData(text: text));
    } else if (action == 'paste') {
      final clipboard = (await Clipboard.getData('text/plain'))?.text ?? '';
      _textController.text = _textController.text.replaceRange(
          _textController.selection.start,
          _textController.selection.end,
          clipboard);
    } else if (action == 'undo') {
      _textController.clear();
    } else if (action == 'redo') {
      _textController.text = defaultText;
    }
  }
}
