import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/context_menu_state.dart';
import 'context_menu_entry.dart';

/// Represents a selectable item in a context menu.
///
/// The [ContextMenuItem] class is used to define individual items that can be displayed
/// within a context menu. It extends the [ContextMenuEntry] class, providing additional
/// functionality for handling item selection, submenus, and associated values.
///
/// A [ContextMenuItem] can have an associated [value] that can be returned when the item
/// is selected. It can also contain a list of [items] to represent submenus, enabling a
/// hierarchical structure within the context menu.
///
/// When a [ContextMenuItem] is selected, it triggers the [handleItemSelection] method, which
/// determines whether the item has subitems. If it does, it toggles the visibility of
/// the submenu associated with the item. If not, it pops the current context menu and
/// returns the associated [value].
///
/// #### Parameters:
/// [value] - The value associated with the context menu item.
///
/// [items] - The list of subitems associated with the context menu item.
abstract class ContextMenuItem<T> extends ContextMenuEntry {
  final T? value;
  final List<ContextMenuEntry>? items;
  final VoidCallback? onSelected;

  const ContextMenuItem({
    this.value,
    this.onSelected,
  }) : items = null;

  const ContextMenuItem.submenu({
    required this.items,
    this.onSelected,
  }) : value = null;

  /// Indicates whether the menu item has subitems.
  bool get isSubmenuItem => items != null;

  /// Handles the selection of the context menu item.
  ///
  /// If the item has subitems, it toggles the submenu's visibility.
  /// Otherwise, it pops the current context menu and returns the [value].
  void handleItemSelection(BuildContext context) {
    onSelected?.call();
    if (isSubmenuItem) {
      final menuState = context.read<ContextMenuState>();
      _toggleSubmenu(context, menuState);
    } else {
      Navigator.pop(context, value);
    }
  }

  /// Toggles the visibility of the submenu associated with this menu item.
  void _toggleSubmenu(BuildContext context, ContextMenuState menuState) {
    if (menuState.isSubmenuOpen &&
        menuState.focusedEntry == menuState.openedEntry) {
      menuState.closeCurrentSubmenu();
    } else {
      menuState.showSubmenu(item: this, context: context, items: items!);
    }
  }
}
