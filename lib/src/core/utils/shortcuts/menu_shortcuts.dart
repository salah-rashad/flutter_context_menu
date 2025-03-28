import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../flutter_context_menu.dart';

Map<ShortcutActivator, VoidCallback> defaultMenuShortcuts(
  BuildContext context,
  ContextMenuState menuState,
) {
  return {
    // closes current submenu
    const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
      if (menuState.isSubmenu) {
        menuState.selfClose?.call();
      }
    },
  };
}
