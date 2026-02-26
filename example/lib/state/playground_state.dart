import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../utils/default_entries.dart';
import 'app_settings_state.dart';
import 'entry_node.dart';
import 'inherited_theme_state.dart';
import 'inline_style_state.dart';
import 'menu_properties_state.dart';
import 'theme_extension_state.dart';

/// Central state object for the context menu playground.
///
/// Manages all menu configuration, styling, and app settings.
/// Exposed via [ChangeNotifierProvider] at the app root.
///
/// Implements the state mutation interface defined in contracts/state-contracts.md.
class PlaygroundState extends ChangeNotifier {
  /// Tree of menu entry configurations.
  List<EntryNode> entries;

  /// ContextMenu-level properties.
  MenuPropertiesState menuProperties;

  /// Direct ContextMenuStyle overrides.
  InlineStyleState inlineStyle;

  /// ContextMenuTheme wrapper config.
  InheritedThemeState inheritedTheme;

  /// ThemeData.extensions config.
  ThemeExtensionState themeExtension;

  /// App-level settings.
  AppSettingsState appSettings;

  /// Last selected item value for feedback display.
  String? lastSelectedValue;

  /// Creates playground state with default values.
  PlaygroundState({
    List<EntryNode>? entries,
    MenuPropertiesState? menuProperties,
    InlineStyleState? inlineStyle,
    InheritedThemeState? inheritedTheme,
    ThemeExtensionState? themeExtension,
    AppSettingsState? appSettings,
    this.lastSelectedValue,
  })  : entries = entries ?? createDefaultEntries(),
        menuProperties = menuProperties ?? const MenuPropertiesState(),
        inlineStyle = inlineStyle ?? const InlineStyleState.empty(),
        inheritedTheme = inheritedTheme ?? const InheritedThemeState(),
        themeExtension = themeExtension ?? const ThemeExtensionState(),
        appSettings = appSettings ?? AppSettingsState();

  // ============================================================
  // Entry Management
  // ============================================================

  /// Adds new entry at end of list (or as child of parentId for submenus).
  void addEntry(EntryType type, [String? parentId]) {
    final newEntry = _createDefaultEntry(type);

    if (parentId == null) {
      entries = [...entries, newEntry];
    } else {
      entries = _addEntryToParent(entries, parentId, newEntry);
    }
    notifyListeners();
  }

  List<EntryNode> _addEntryToParent(
    List<EntryNode> nodes,
    String parentId,
    EntryNode newEntry,
  ) {
    return nodes.map((node) {
      if (node.id == parentId && node.type == EntryType.item) {
        // Found the parent - add as child and mark as submenu
        return node.copyWith(
          isSubmenu: true,
          children: [...node.children, newEntry],
        );
      }
      // Recursively search in children
      if (node.children.isNotEmpty) {
        return node.copyWith(
          children: _addEntryToParent(node.children, parentId, newEntry),
        );
      }
      return node;
    }).toList();
  }

  EntryNode _createDefaultEntry(EntryType type) {
    final id = 'entry-${DateTime.now().millisecondsSinceEpoch}';
    switch (type) {
      case EntryType.item:
        return EntryNode(id: id, type: type, label: 'New Item', value: id);
      case EntryType.header:
        return EntryNode(id: id, type: type, label: 'Header');
      case EntryType.divider:
        return EntryNode(id: id, type: type);
    }
  }

  /// Removes entry by id (recursively searches children).
  void removeEntry(String id) {
    entries = _removeEntryById(entries, id);
    notifyListeners();
  }

  List<EntryNode> _removeEntryById(List<EntryNode> nodes, String id) {
    return nodes.where((node) => node.id != id).map((node) {
      if (node.children.isNotEmpty) {
        return node.copyWith(
          children: _removeEntryById(node.children, id),
        );
      }
      return node;
    }).toList();
  }

  /// Moves entry to new position.
  void reorderEntry(String id, int newIndex, [String? newParentId]) {
    // First, remove the entry from its current location
    final entry = _findEntryById(entries, id);
    if (entry == null) return;

    entries = _removeEntryById(entries, id);

    // Then, add it to the new location
    if (newParentId == null) {
      // Add to root level
      final newEntries = [...entries];
      newEntries.insert(newIndex.clamp(0, newEntries.length), entry);
      entries = newEntries;
    } else {
      // Add as child of newParentId
      entries = _addEntryToParentAtIndex(entries, newParentId, entry, newIndex);
    }
    notifyListeners();
  }

  List<EntryNode> _addEntryToParentAtIndex(
    List<EntryNode> nodes,
    String parentId,
    EntryNode newEntry,
    int index,
  ) {
    return nodes.map((node) {
      if (node.id == parentId && node.type == EntryType.item) {
        final newChildren = [...node.children];
        newChildren.insert(index.clamp(0, newChildren.length), newEntry);
        return node.copyWith(
          isSubmenu: true,
          children: newChildren,
        );
      }
      if (node.children.isNotEmpty) {
        return node.copyWith(
          children: _addEntryToParentAtIndex(
              node.children, parentId, newEntry, index),
        );
      }
      return node;
    }).toList();
  }

  EntryNode? _findEntryById(List<EntryNode> nodes, String id) {
    for (final node in nodes) {
      if (node.id == id) return node;
      if (node.children.isNotEmpty) {
        final found = _findEntryById(node.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Replaces entry properties.
  void updateEntry(String id, EntryNode updated) {
    entries = _updateEntryById(entries, id, updated);
    notifyListeners();
  }

  List<EntryNode> _updateEntryById(
    List<EntryNode> nodes,
    String id,
    EntryNode updated,
  ) {
    return nodes.map((node) {
      if (node.id == id) {
        return updated;
      }
      if (node.children.isNotEmpty) {
        return node.copyWith(
          children: _updateEntryById(node.children, id, updated),
        );
      }
      return node;
    }).toList();
  }

  // ============================================================
  // Menu Properties
  // ============================================================

  /// Updates clipBehavior.
  void setClipBehavior(Clip value) {
    menuProperties = menuProperties.copyWith(clipBehavior: value);
    notifyListeners();
  }

  /// Updates respectPadding.
  void setRespectPadding(bool value) {
    menuProperties = menuProperties.copyWith(respectPadding: value);
    notifyListeners();
  }

  // ============================================================
  // Style Layers
  // ============================================================

  /// Replaces inline style state.
  void updateInlineStyle(InlineStyleState style) {
    inlineStyle = style;
    notifyListeners();
  }

  /// Toggles inherited theme.
  void setInheritedThemeEnabled(bool value) {
    inheritedTheme = inheritedTheme.copyWith(enabled: value);
    notifyListeners();
  }

  /// Replaces inherited theme style.
  void updateInheritedThemeStyle(InlineStyleState style) {
    inheritedTheme = inheritedTheme.copyWith(style: style);
    notifyListeners();
  }

  /// Toggles theme extension.
  void setThemeExtensionEnabled(bool value) {
    themeExtension = themeExtension.copyWith(enabled: value);
    notifyListeners();
  }

  /// Replaces theme extension style.
  void updateThemeExtensionStyle(InlineStyleState style) {
    themeExtension = themeExtension.copyWith(style: style);
    notifyListeners();
  }

  // ============================================================
  // App Settings
  // ============================================================

  /// Switches light/dark mode.
  void setThemeMode(ThemeMode mode) {
    appSettings.setThemeMode(mode);
    notifyListeners();
  }

  // ============================================================
  // Selection Feedback
  // ============================================================

  /// Updates the last selected value for display.
  void setLastSelectedValue(String? value) {
    lastSelectedValue = value;
    notifyListeners();
  }

  // ============================================================
  // Read-Only Builders
  // ============================================================

  /// Constructs a [ContextMenu] from current entries + menuProperties + inlineStyle.
  ContextMenu<String> buildContextMenu() {
    return ContextMenu<String>(
      entries: entries.map((e) => e.toEntry()).toList(),
      clipBehavior: menuProperties.clipBehavior,
      respectPadding: menuProperties.respectPadding,
      style: buildInlineStyle(),
    );
  }

  /// Builds the inline [ContextMenuStyle] from inlineStyle (null if empty).
  ContextMenuStyle? buildInlineStyle() {
    return inlineStyle.toContextMenuStyle();
  }

  /// Builds the inherited [ContextMenuStyle] (null if disabled).
  ContextMenuStyle? buildInheritedStyle() {
    if (!inheritedTheme.enabled) return null;
    return inheritedTheme.style.toContextMenuStyle();
  }

  /// Builds the extension [ContextMenuStyle] (null if disabled).
  ContextMenuStyle? buildThemeExtensionStyle() {
    if (!themeExtension.enabled) return null;
    return themeExtension.style.toContextMenuStyle();
  }

  // ============================================================
  // Reset
  // ============================================================

  /// Resets all state to initial defaults.
  void resetToDefaults() {
    entries = createDefaultEntries();
    menuProperties = const MenuPropertiesState();
    inlineStyle = const InlineStyleState.empty();
    inheritedTheme = const InheritedThemeState();
    themeExtension = const ThemeExtensionState();
    lastSelectedValue = null;
    notifyListeners();
  }
}
