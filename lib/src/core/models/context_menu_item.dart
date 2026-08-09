import 'package:flutter/material.dart';

import '../../widgets/context_menu_state.dart';
import 'context_menu_entry.dart';
import 'context_menu_interactive_entry.dart';

/// Represents a selectable item in a context menu.
///
/// The [ContextMenuItem] class is used to define individual items that can be displayed
/// within a context menu. It extends the [ContextMenuInteractiveEntry] class, providing additional
/// functionality for handling item selection, submenus, and associated values.
///
/// A [ContextMenuItem] can have an associated [value] that can be returned when the item
/// is selected. It can also contain a list of [items] to represent submenus, enabling a
/// hierarchical structure within the context menu.
///
/// #### Parameters:
/// - [value] - The value associated with the context menu item.
/// - [items] - The list of subitems associated with the context menu item.
/// - [onSelected] - The callback that is triggered when the context menu item is selected.
///
/// see:
/// - [ContextMenuEntry]
/// - [ContextMenuInteractiveEntry]
/// - [MenuItem]
/// - [MenuHeader]
/// - [MenuDivider]
///
abstract base class ContextMenuItem<T> extends ContextMenuInteractiveEntry<T> {
  final T? value;
  final List<ContextMenuEntry<T>>? items;
  final ValueChanged<T?>? onSelected;

  const ContextMenuItem({
    this.value,
    this.onSelected,
    super.enabled,
  }) : items = null;

  const ContextMenuItem.submenu({
    required this.items,
    this.onSelected,
    super.enabled,
  }) : value = null;

  /// Indicates whether the menu item has subitems.
  ///
  /// Can be used to determine whether the item is a submenu.
  ///
  /// see:
  /// - [MenuItem]
  bool get isSubmenuItem => items != null;

  @override
  VoidCallback? createActivator(
          BuildContext context, ContextMenuState<T> menuState) =>
      () => menuState.activateMenuItem(context, this);

  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]);
}
