import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BuildContextExtensions on BuildContext {
  Rect? getWidgetBounds() {
    final widgetRenderBox = findRenderObject() as RenderBox?;
    if (widgetRenderBox == null) return null;
    final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
    final widgetSize = widgetRenderBox.size;
    return widgetPosition & widgetSize;
  }

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension SingleActivatorExtensions on SingleActivator {
  /// Converts a SingleActivator (a keyboard shortcut definition) into a
  /// human-readable string like "Ctrl+Shift+A" or "F5".

  String toKeyString() {
    final List<String> parts = [];

    // 1. Check for modifier keys
    if (control) {
      // Platform-aware check for Control key
      if (LogicalKeyboardKey.control.keyLabel == 'Meta') {
        parts.add('Cmd');
      } else {
        parts.add('Ctrl');
      }
    }
    if (shift) {
      parts.add('Shift');
    }
    if (alt) {
      parts.add('Alt');
    }
    if (meta) {
      // Platform-aware check for Meta (Windows/Command) key
      if (LogicalKeyboardKey.meta.keyLabel == 'Control') {
        parts.add('Ctrl');
      } else {
        parts.add('Meta');
      }
    }

    // 2. Get the main key's label
    final LogicalKeyboardKey triggerKey = trigger;
    String keyLabel = triggerKey.keyLabel;

    // Cleanup: LogicalKeyboardKey.keyA.keyLabel is often 'A', but for non-alphabetic
    // keys, the label might be verbose (e.g., 'Delete' for LogicalKeyboardKey.delete).
    // We can shorten or title-case some common ones.
    if (keyLabel.length > 1) {
      // For keys like 'Escape', 'Enter', 'Arrow Left', etc. we often capitalize.
      keyLabel = keyLabel[0].toUpperCase() + keyLabel.substring(1);

      // For arrow keys, shorten the label.
      if (keyLabel.startsWith('Arrow')) {
        keyLabel = keyLabel.replaceFirst('Arrow ', '');
      }

      // Replace some common key names with symbols
      keyLabel = keyLabel.replaceAll('Add', '+');
      keyLabel = keyLabel.replaceAll('Subtract', '-');
      keyLabel = keyLabel.replaceAll('Multiply', '*');
      keyLabel = keyLabel.replaceAll('Divide', '/');
      keyLabel = keyLabel.replaceAll('Equal', '=');
      keyLabel = keyLabel.replaceAll('Decimal', '.');
      keyLabel = keyLabel.replaceAll('Comma', ',');
      keyLabel = keyLabel.replaceAll('Paren Left', '(');
      keyLabel = keyLabel.replaceAll('Paren Right', ')');
    }

    // 3. Add the key label and combine all parts
    if (keyLabel.isNotEmpty) {
      parts.add(keyLabel);
    }

    return parts.join('+');
  }
}
