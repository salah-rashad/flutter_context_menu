import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import 'context_menu_state.dart';

/// A widget that represents a single item in a context menu.
///
/// This widget is used internally by the `ContextMenu` contextMenu.
class MenuEntry<T> extends StatefulWidget {
  final ContextMenuEntry entry;
  const MenuEntry({super.key, required this.entry});

  @override
  State<MenuEntry<T>> createState() => _MenuEntryState<T>();
}

class _MenuEntryState<T> extends State<MenuEntry<T>> {
  late final FocusNode focusNode;

  ContextMenuEntry get entry => widget.entry;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = context.read<ContextMenuState>();
    return MouseRegion(
        onEnter: (event) => _onMouseEnter(context, event, menuState),
        onExit: (event) => widget.entry.onMouseExit(event, menuState),
        onHover: (event) => widget.entry.onMouseHover(event, menuState),
        child: () {
          if (entry is ContextMenuItem) {
            return (entry as ContextMenuItem).builder(context, menuState, focusNode);
          } else {
            return entry.builder(context, menuState);
          }
        }());
  }

  /// Handles the mouse enter event for the context menu entry.
  ///
  /// This method is called when the mouse pointer enters the area of the context menu entry.
  /// - If the entry is a submenu, it shows the submenu if it is not already opened.
  /// - If the entry is not a submenu, it closes the current context menu.
  void _onMouseEnter(
    BuildContext context,
    PointerEnterEvent event,
    ContextMenuState menuState,
  ) {
    if (widget.entry is ContextMenuItem) {
      final item = widget.entry as ContextMenuItem;
      final isSubmenuItem = item.isSubmenuItem;
      final isOpenedSubmenu = menuState.isOpened(item);
      final isFocused = menuState.isFocused(item);

      if (!isSubmenuItem && !isFocused) {
        menuState.closeSubmenu();
      } else if (isSubmenuItem && !isOpenedSubmenu) {
        menuState.showSubmenu(context: context, parent: item);
      }

      menuState.setFocusedEntry(item);
    }
    widget.entry.onMouseEnter(event, menuState);
  }
}
