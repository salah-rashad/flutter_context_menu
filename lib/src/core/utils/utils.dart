import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../widgets/context_menu_state.dart';
import '../enums/spawn_direction.dart';
import '../utils/extensions.dart';

/// Calculates the position of the context menu based on the position of the
/// menu and the position of the parent menu. To prevent the menu from
/// extending beyond the screen boundaries.
Offset calculateContextMenuPosition(
  BuildContext context,
  ContextMenuState menu,
) {
  final screenSize = MediaQuery.of(context).size;
  final menuRect = context.getWidgetBounds()!;

  bool isWidthExcceed = menuRect.left + menuRect.width > screenSize.width;
  bool isHeightExcceed = menuRect.top + menuRect.height > screenSize.height;

  final parentRect = menu.parentItemRect;
  // final relativeTo = menu.relativeTo;

  if (menu.spawnDirection == SpawnDirection.start && parentRect != null) {
    isWidthExcceed = parentRect.left - menuRect.width > 0.0;
  }

  double left = menuRect.left;
  double top = menuRect.top;

  if ((isWidthExcceed || isHeightExcceed)) {
    if (isWidthExcceed) {
      if (menu.isSubmenu && parentRect != null) {
        left = max(
          0.0,
          parentRect.left - menuRect.width - menu.padding.right,
        );
      } else if (!menu.isSubmenu) {
        left = max(0, menuRect.left - menuRect.width);
      }
    }

    if (isHeightExcceed) {
      if (menu.isSubmenu && parentRect != null) {
        top = max(0.0, screenSize.height - menuRect.height);
      } else if (!menu.isSubmenu) {
        top = max(0.0, menuRect.top - menuRect.height);
      }
    }
  }

  return Offset(left, top);
}
