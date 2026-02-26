import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// Type of menu entry.
enum EntryType {
  /// Selectable menu item with optional icon, shortcut, and submenu support.
  item,

  /// Non-interactive header label.
  header,

  /// Visual divider separator.
  divider,
}

/// Type of trailing widget for menu items.
enum TrailingType {
  /// No trailing widget.
  none,

  /// Chevron/arrow icon indicating submenu.
  chevron,

  /// Custom text widget.
  customText,
}

/// Represents a single menu entry in the tree editor.
///
/// Recursive structure supports submenus via [children].
/// Converts to package types via [toEntry].
class EntryNode {
  /// Unique identifier for tree operations.
  final String id;

  /// Type of this entry.
  final EntryType type;

  /// Display text (items and headers).
  final String label;

  /// Material icon (items only).
  final IconData? icon;

  /// Shortcut display text, e.g., "Ctrl+C" (items only).
  final String? shortcutLabel;

  /// Whether the item is selectable (items only).
  final bool enabled;

  /// Inline text color override (items only).
  final Color? textColor;

  /// Associated value returned on selection (items only).
  final String? value;

  /// Trailing widget type (items only).
  final TrailingType trailingType;

  /// Custom trailing text when trailingType is customText (items only).
  final String? trailingText;

  /// Whether this item has children (items only).
  final bool isSubmenu;

  /// Child entries for submenus.
  final List<EntryNode> children;

  /// Disable auto-uppercase (headers only).
  final bool disableUppercase;

  /// Custom height (dividers only).
  final double? dividerHeight;

  /// Custom thickness (dividers only).
  final double? dividerThickness;

  /// Custom indent (dividers only).
  final double? dividerIndent;

  /// Custom end indent (dividers only).
  final double? dividerEndIndent;

  /// Custom color (dividers only).
  final Color? dividerColor;

  /// Creates an entry node.
  const EntryNode({
    required this.id,
    required this.type,
    this.label = 'New Item',
    this.icon,
    this.shortcutLabel,
    this.enabled = true,
    this.textColor,
    this.value,
    this.trailingType = TrailingType.none,
    this.trailingText,
    this.isSubmenu = false,
    this.children = const [],
    this.disableUppercase = false,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerIndent,
    this.dividerEndIndent,
    this.dividerColor,
  });

  /// Creates a copy of this node with the given fields replaced.
  EntryNode copyWith({
    String? id,
    EntryType? type,
    String? label,
    IconData? icon,
    String? shortcutLabel,
    bool? enabled,
    Color? textColor,
    String? value,
    TrailingType? trailingType,
    String? trailingText,
    bool? isSubmenu,
    List<EntryNode>? children,
    bool? disableUppercase,
    double? dividerHeight,
    double? dividerThickness,
    double? dividerIndent,
    double? dividerEndIndent,
    Color? dividerColor,
  }) {
    return EntryNode(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      shortcutLabel: shortcutLabel ?? this.shortcutLabel,
      enabled: enabled ?? this.enabled,
      textColor: textColor ?? this.textColor,
      value: value ?? this.value,
      trailingType: trailingType ?? this.trailingType,
      trailingText: trailingText ?? this.trailingText,
      isSubmenu: isSubmenu ?? this.isSubmenu,
      children: children ?? this.children,
      disableUppercase: disableUppercase ?? this.disableUppercase,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      dividerIndent: dividerIndent ?? this.dividerIndent,
      dividerEndIndent: dividerEndIndent ?? this.dividerEndIndent,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  /// Converts this node to a package [ContextMenuEntry].
  ContextMenuEntry<String> toEntry() {
    switch (type) {
      case EntryType.item:
        return _buildMenuItem();
      case EntryType.header:
        return MenuHeader(
          text: label,
          disableUppercase: disableUppercase,
        );
      case EntryType.divider:
        return MenuDivider(
          height: dividerHeight,
          thickness: dividerThickness,
          indent: dividerIndent,
          endIndent: dividerEndIndent,
          color: dividerColor,
        );
    }
  }

  /// Builds a [MenuItem] from this node.
  MenuItem<String> _buildMenuItem() {
    final Widget? iconWidget = icon != null ? Icon(icon) : null;

    final Widget? trailingWidget = _buildTrailingWidget();

    if (isSubmenu && children.isNotEmpty) {
      return MenuItem<String>.submenu(
        icon: iconWidget,
        label: Text(label),
        items: children.map((child) => child.toEntry()).toList(),
        enabled: enabled,
        textColor: textColor,
        trailing: trailingWidget,
      );
    }

    return MenuItem<String>(
      icon: iconWidget,
      label: Text(label),
      shortcut: _parseShortcut(),
      value: value,
      enabled: enabled,
      textColor: textColor,
      trailing: trailingWidget,
    );
  }

  /// Builds the trailing widget based on [trailingType].
  Widget? _buildTrailingWidget() {
    switch (trailingType) {
      case TrailingType.none:
        return null;
      case TrailingType.chevron:
        return const Icon(Icons.chevron_right);
      case TrailingType.customText:
        if (trailingText != null && trailingText!.isNotEmpty) {
          return Text(trailingText!);
        }
        return null;
    }
  }

  /// Parses the shortcut label into a [SingleActivator].
  ///
  /// Supports formats like "Ctrl+C", "Cmd+S", "Shift+Delete", etc.
  SingleActivator? _parseShortcut() {
    if (shortcutLabel == null || shortcutLabel!.isEmpty) {
      return null;
    }

    final parts = shortcutLabel!.split('+');
    if (parts.isEmpty) return null;

    // Parse modifiers
    bool control = false;
    bool shift = false;
    bool alt = false;
    bool meta = false;
    String? keyPart;

    for (int i = 0; i < parts.length; i++) {
      final part = parts[i].trim().toLowerCase();
      if (i == parts.length - 1) {
        // Last part is the key
        keyPart = part;
      } else {
        switch (part) {
          case 'ctrl':
          case 'control':
            control = true;
            break;
          case 'shift':
            shift = true;
            break;
          case 'alt':
          case 'option':
            alt = true;
            break;
          case 'cmd':
          case 'meta':
          case 'command':
            meta = true;
            break;
        }
      }
    }

    if (keyPart == null) return null;

    // Map common key names to LogicalKeyboardKey
    final logicalKey = _mapKeyToLogical(keyPart);
    if (logicalKey == null) return null;

    return SingleActivator(
      logicalKey,
      control: control,
      shift: shift,
      alt: alt,
      meta: meta,
    );
  }

  /// Maps a key name string to a [LogicalKeyboardKey].
  static LogicalKeyboardKey? _mapKeyToLogical(String keyName) {
    // Letter keys A-Z
    final letterKeys = <String, LogicalKeyboardKey>{
      'a': LogicalKeyboardKey.keyA,
      'b': LogicalKeyboardKey.keyB,
      'c': LogicalKeyboardKey.keyC,
      'd': LogicalKeyboardKey.keyD,
      'e': LogicalKeyboardKey.keyE,
      'f': LogicalKeyboardKey.keyF,
      'g': LogicalKeyboardKey.keyG,
      'h': LogicalKeyboardKey.keyH,
      'i': LogicalKeyboardKey.keyI,
      'j': LogicalKeyboardKey.keyJ,
      'k': LogicalKeyboardKey.keyK,
      'l': LogicalKeyboardKey.keyL,
      'm': LogicalKeyboardKey.keyM,
      'n': LogicalKeyboardKey.keyN,
      'o': LogicalKeyboardKey.keyO,
      'p': LogicalKeyboardKey.keyP,
      'q': LogicalKeyboardKey.keyQ,
      'r': LogicalKeyboardKey.keyR,
      's': LogicalKeyboardKey.keyS,
      't': LogicalKeyboardKey.keyT,
      'u': LogicalKeyboardKey.keyU,
      'v': LogicalKeyboardKey.keyV,
      'w': LogicalKeyboardKey.keyW,
      'x': LogicalKeyboardKey.keyX,
      'y': LogicalKeyboardKey.keyY,
      'z': LogicalKeyboardKey.keyZ,
    };

    final lowerKeyName = keyName.toLowerCase();
    if (letterKeys.containsKey(lowerKeyName)) {
      return letterKeys[lowerKeyName];
    }

    // Special keys
    switch (lowerKeyName) {
      case 'numpad0':
        return LogicalKeyboardKey.numpad0;
      case 'enter':
      case 'return':
        return LogicalKeyboardKey.enter;
      case 'escape':
      case 'esc':
        return LogicalKeyboardKey.escape;
      case 'delete':
        return LogicalKeyboardKey.delete;
      case 'backspace':
        return LogicalKeyboardKey.backspace;
      case 'tab':
        return LogicalKeyboardKey.tab;
      case 'space':
        return LogicalKeyboardKey.space;
      case 'arrowup':
      case 'up':
        return LogicalKeyboardKey.arrowUp;
      case 'arrowdown':
      case 'down':
        return LogicalKeyboardKey.arrowDown;
      case 'arrowleft':
      case 'left':
        return LogicalKeyboardKey.arrowLeft;
      case 'arrowright':
      case 'right':
        return LogicalKeyboardKey.arrowRight;
      case 'home':
        return LogicalKeyboardKey.home;
      case 'end':
        return LogicalKeyboardKey.end;
      case 'pageup':
        return LogicalKeyboardKey.pageUp;
      case 'pagedown':
        return LogicalKeyboardKey.pageDown;
      case 'f1':
        return LogicalKeyboardKey.f1;
      case 'f2':
        return LogicalKeyboardKey.f2;
      case 'f3':
        return LogicalKeyboardKey.f3;
      case 'f4':
        return LogicalKeyboardKey.f4;
      case 'f5':
        return LogicalKeyboardKey.f5;
      case 'f6':
        return LogicalKeyboardKey.f6;
      case 'f7':
        return LogicalKeyboardKey.f7;
      case 'f8':
        return LogicalKeyboardKey.f8;
      case 'f9':
        return LogicalKeyboardKey.f9;
      case 'f10':
        return LogicalKeyboardKey.f10;
      case 'f11':
        return LogicalKeyboardKey.f11;
      case 'f12':
        return LogicalKeyboardKey.f12;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'EntryNode(id: $id, type: $type, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EntryNode &&
        other.id == id &&
        other.type == type &&
        other.label == label &&
        other.icon == icon &&
        other.shortcutLabel == shortcutLabel &&
        other.enabled == enabled &&
        other.textColor == textColor &&
        other.value == value &&
        other.trailingType == trailingType &&
        other.trailingText == trailingText &&
        other.isSubmenu == isSubmenu &&
        other.disableUppercase == disableUppercase &&
        other.dividerHeight == dividerHeight &&
        other.dividerThickness == dividerThickness &&
        other.dividerIndent == dividerIndent &&
        other.dividerEndIndent == dividerEndIndent &&
        other.dividerColor == dividerColor &&
        _listEquals(other.children, children);
  }

  static bool _listEquals(List<EntryNode> a, List<EntryNode> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        type,
        label,
        icon,
        shortcutLabel,
        enabled,
        textColor,
        value,
        trailingType,
        trailingText,
        isSubmenu,
        children,
        disableUppercase,
        dividerHeight,
        dividerThickness,
        dividerIndent,
        dividerEndIndent,
        dividerColor,
      ]);
}
