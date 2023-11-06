import 'dart:math';

import 'package:flutter/widgets.dart';

import '../enums/spawn_direction.dart';
import '../utils/extensions.dart';

/// Calculates the position of the context menu based on the position of the
/// menu and the position of the parent menu. To prevent the menu from
/// extending beyond the screen boundaries.
Offset calculateContextMenuPosition(
  BuildContext context, {
  EdgeInsets padding = const EdgeInsets.all(0.0),
  bool isSubmenu = false,
  Rect? parentRect,
  SpawnDirection spawnDirection = SpawnDirection.end,
}) {
  final screenSize = MediaQuery.of(context).size;
  final menuRect = context.getWidgetBounds()!;

  bool isWidthExcceed = menuRect.left + menuRect.width > screenSize.width;
  bool isHeightExcceed = menuRect.top + menuRect.height > screenSize.height;

  if (spawnDirection == SpawnDirection.start && parentRect != null) {
    isWidthExcceed = parentRect.left - menuRect.width > 0.0;
  }

  double left = menuRect.left;
  double top = menuRect.top;

  if ((isWidthExcceed || isHeightExcceed)) {
    if (isWidthExcceed) {
      if (isSubmenu && parentRect != null) {
        left = max(
          0.0,
          parentRect.left - menuRect.width - padding.right,
        );
      } else if (!isSubmenu) {
        left = max(0, menuRect.left - menuRect.width);
      }
    }

    if (isHeightExcceed) {
      if (isSubmenu && parentRect != null) {
        top = max(0.0, screenSize.height - menuRect.height);
      } else if (!isSubmenu) {
        top = max(0.0, menuRect.top - menuRect.height);
      }
    }
  }

  return Offset(left, top);
}
