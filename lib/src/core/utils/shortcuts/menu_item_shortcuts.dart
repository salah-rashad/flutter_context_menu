import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/context_menu_state.dart';
import '../../models/context_menu_item.dart';

Map<ShortcutActivator, VoidCallback> defaultMenuItemShortcuts(
    ContextMenuState menuState) {
  return {
    const SingleActivator(LogicalKeyboardKey.arrowRight): () {
      final focusedEntry = menuState.focusedEntry;
      if (focusedEntry is ContextMenuItem) {
        final bool isSubmenuOpen = menuState.isSubmenuOpen;
        final focusedItemIsNotTheSelectedItem =
            menuState.focusedEntry != menuState.selectedItem;
        if (focusedEntry.isSubmenuItem &&
            !isSubmenuOpen &&
            focusedItemIsNotTheSelectedItem) {
          menuState.activateEntry(focusedEntry);
        }
      }
    },
    const SingleActivator(LogicalKeyboardKey.space): () =>
        menuState.activateFocusedEntry(),
    const SingleActivator(LogicalKeyboardKey.enter): () =>
        menuState.activateFocusedEntry(),
    const SingleActivator(LogicalKeyboardKey.numpadEnter): () =>
        menuState.activateFocusedEntry(),
  };
}
