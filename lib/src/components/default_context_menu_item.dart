import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../widgets/context_menu_state.dart';

/// Represents a selectable item in a context menu.
///
/// The [DefaultContextMenuItem] class is used to define individual items that can be displayed
/// within a context menu. It extends the [ContextMenuEntry] class, providing additional
/// functionality for handling item selection, submenus, and associated values.
///
/// A [DefaultContextMenuItem] can have an associated [value] that can be returned when the item
/// is selected. It can also contain a list of [items] to represent submenus, enabling a
/// hierarchical structure within the context menu.
///
/// When a [DefaultContextMenuItem] is selected, it triggers the [handleItemSelection] method, which
/// determines whether the item has subitems. If it does, it toggles the visibility of
/// the submenu associated with the item. If not, it pops the current context menu and
/// returns the associated [value].
///
///
/// #### Parameters:
/// - [title] - The title of the context menu item
/// - [icon] - The icon of the context menu item.
/// - [constraints] - The height of the context menu item.
/// - [focusNode] - The focus node of the context menu item.
/// - [value] - The value associated with the context menu item.
/// - [items] - The list of subitems associated with the context menu item.
/// - [onSelected] - The callback that is triggered when the context menu item is selected. If the item has subitems, it toggles the visibility of the submenu. If not, it pops the current context menu and returns the associated value.
/// - [constraints] - The constraints of the context menu item.
///
/// @see ContextMenuItem
/// @see ContextMenu
/// @see ContextMenuState
class DefaultContextMenuItem<T> extends ContextMenuItem<T> {
  final String title;
  final IconData? icon;
  final BoxConstraints? constraints;
  final FocusNode focusNode = FocusNode();

  DefaultContextMenuItem({
    required this.title,
    this.icon,
    super.value,
    super.onSelected,
    this.constraints,
  });

  DefaultContextMenuItem.submenu({
    required this.title,
    required List<ContextMenuEntry> items,
    this.icon,
    super.onSelected,
    this.constraints,
  }) : super.submenu(items: items);

  @override
  Widget builder(BuildContext context, ContextMenuState menuState) {
    bool isFocused = menuState.focusedEntry == this;

    final background = context.colorScheme.surface;
    final normalTextColor = Color.alphaBlend(
      context.colorScheme.onSurface.withOpacity(0.7),
      background,
    );
    final focusedTextColor = context.colorScheme.onSurface;
    final foregroundColor = isFocused ? focusedTextColor : normalTextColor;
    final textStyle = TextStyle(color: foregroundColor, height: 1.0);

    // ~~~~~~~~~~ //

    return CallbackShortcuts(
      bindings: _keybindings(context, menuState),
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (value) {
          if (value) {
            _setAsFocusedItem(menuState);
          }
        },
        child: ConstrainedBox(
          constraints: constraints ?? const BoxConstraints.expand(height: 32.0),
          child: Material(
            color:
                isFocused ? context.theme.focusColor.withAlpha(20) : background,
            borderRadius: BorderRadius.circular(4.0),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => handleItemSelection(context),
              canRequestFocus: false,
              onHover: (value) {
                if (value) {
                  _setAsFocusedItem(menuState);
                }
              },
              child: DefaultTextStyle(
                style: textStyle,
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 32.0,
                      child: Icon(
                        icon,
                        size: 16.0,
                        color: foregroundColor,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    SizedBox.square(
                      dimension: 32.0,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(
                          isSubmenuItem ? Icons.arrow_right : null,
                          size: 16.0,
                          color: foregroundColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<ShortcutActivator, VoidCallback> _keybindings(
    BuildContext context,
    ContextMenuState menuState,
  ) {
    return {
      const SingleActivator(LogicalKeyboardKey.arrowRight): () {
        final bool isSubmenuOpen = menuState.isSubmenuOpen;
        final focusedItemIsNotTheOpenedItem =
            menuState.focusedEntry != menuState.openedEntry;
        if (isSubmenuItem && !isSubmenuOpen && focusedItemIsNotTheOpenedItem) {
          handleItemSelection(context);
        }
      },
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
        if (menuState.isSubmenu) {
          menuState.selfClose?.call();
        }
      },
      const SingleActivator(LogicalKeyboardKey.space): () =>
          handleItemSelection(context),
      const SingleActivator(LogicalKeyboardKey.enter): () =>
          handleItemSelection(context),
      const SingleActivator(LogicalKeyboardKey.numpadEnter): () =>
          handleItemSelection(context),
    };
  }

  void _setAsFocusedItem(ContextMenuState menuState) {
    menuState.focusedEntry = this;
    menuState.focusScopeNode.requestFocus(focusNode);
  }
}
