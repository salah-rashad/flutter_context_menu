import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/context_menu_state.dart';
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
/// When a [ContextMenuItem] is selected, it triggers the [onSelect] method, which
/// determines whether the item has subitems. If it does, it toggles the visibility of
/// the submenu associated with the item. If not, it pops the current context menu and
/// returns the associated [value].
///
/// Example usage:
/// ```
/// class ContextMenuListTileItem extends ContextMenuItem {
///   final String title;
///   ContextMenuListTileItem({
///     required this.title,
///     super.value,
///     super.onPressed,
///   });
/// 
///   @override
///   Widget builder(BuildContext context) {
///     return ListTile(
///       title: Text(title),
///       onTap: () => onSelect(context),
///       trailing: Icon(isSubmenuItem ? Icons.arrow_right : null),
///     );
///   }
/// }
/// ```
///
/// The above implementation shows how to define the [builder] method within a [ContextMenuItem].
/// It creates a [ListTile] widget with a title, an onTap callback that triggers the [onSelect] method,
/// and a trailing "right arrow" icon shows if the item has subitems.

abstract class ContextMenuItem<T> extends ContextMenuEntry {
  final T? value;
  final List<ContextMenuEntry>? items;
  final VoidCallback? _onPressed;

  const ContextMenuItem({
    this.value,
    VoidCallback? onPressed,
  })  : _onPressed = onPressed,
        items = null;

  const ContextMenuItem.submenu({
    required this.items,
    VoidCallback? onPressed,
  })  : _onPressed = onPressed,
        value = null;

  /// Indicates whether the menu item has subitems.
  bool get isSubmenuItem => items != null;

  /// Handles the selection of the context menu item.
  ///
  /// If the item has subitems, it toggles the submenu's visibility.
  /// Otherwise, it pops the current context menu and returns the [value].
  void onSelect(BuildContext context) {
    _onPressed?.call();
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
