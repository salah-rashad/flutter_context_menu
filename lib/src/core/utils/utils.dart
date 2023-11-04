import 'dart:math';

import 'package:flutter/widgets.dart';

import '../utils/extensions.dart';

Offset calculateContextMenuPosition(
  BuildContext context, {
  EdgeInsets padding = const EdgeInsets.all(0.0),
  bool isSubmenu = false,
  Rect? parentRect,
  bool isLTR = true,
}) {
  final screenSize = MediaQuery.of(context).size;
  final menuRect = context.getWidgetBounds()!;

  bool isWidthExcceed = menuRect.left + menuRect.width > screenSize.width;
  bool isHeightExcceed = menuRect.top + menuRect.height > screenSize.height;

  if (!isLTR && parentRect != null) {
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
