import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../widgets/theme/context_menu_theme.dart';
import '../constants.dart';
import '../models/context_menu.dart';
import 'extensions/build_context_ext.dart';

/// Calculates the position of the context menu while ensuring it doesn't
/// exceed screen boundaries, using a scoring-based placement for submenus.
({Offset pos, AlignmentGeometry alignment}) calculateContextMenuBoundaries(
  BuildContext context,
  ContextMenu menu,
  Rect? parentRect,
  AlignmentGeometry spawnAlignment,
  bool isSubmenu,
) {
  final screenSize = context.mediaQuery.size;
  final safeArea = (Offset.zero & screenSize).deflate(kContextMenuSafePadding);
  final menuRect = context.getWidgetBounds();

  if (menuRect == null) {
    return (pos: safeArea.topLeft, alignment: spawnAlignment);
  }

  final textDir = Directionality.maybeOf(context) ?? TextDirection.ltr;

  final menuStyle = ContextMenuTheme.resolve(context);
  EdgeInsets padding = menuStyle.padding ?? EdgeInsets.zero;

  if (!menu.respectPadding) {
    padding = padding.copyWith(left: 0, right: 0);
  }

  // Helpers
  double clampX(double x) => x.clamp(
      safeArea.left, max(safeArea.left, safeArea.right - menuRect.width));
  double clampY(double y) => y.clamp(
      safeArea.top, max(safeArea.top, safeArea.bottom - menuRect.height));

  double overflowAmount(Rect r) {
    final double dx =
        max(0, safeArea.left - r.left) + max(0, r.right - safeArea.right);
    final double dy =
        max(0, safeArea.top - r.top) + max(0, r.bottom - safeArea.bottom);
    return dx + dy;
  }

  bool isTopAligned(AlignmentGeometry a) => a.resolve(textDir).y <= 0.0;
  bool isRightAligned(AlignmentGeometry a) => a.resolve(textDir).x >= 0.0;

  AlignmentGeometry alignFromSides({required bool right, required bool top}) {
    if (top) {
      return right
          ? AlignmentDirectional.topStart
          : AlignmentDirectional.topEnd;
    } else {
      return right
          ? AlignmentDirectional.bottomStart
          : AlignmentDirectional.bottomEnd;
    }
  }

  // Root menu: just clamp the current rect neatly. Keep the alignment as-is.
  if (!isSubmenu || parentRect == null) {
    final x = clampX(menuRect.left);
    final y = clampY(menuRect.top);
    return (pos: Offset(x, y), alignment: spawnAlignment);
  }

  // --- Submenu smart placement ---
  // Preferred side inferred from the *current* spawnAlignment.
  final preferRight = isRightAligned(spawnAlignment);
  final preferTop = isTopAligned(spawnAlignment);

  // Candidate anchors around the parent.
  final xRight = parentRect.right + padding.left;
  final xLeft = parentRect.left - menuRect.width - padding.right;
  final yTop = parentRect.top - padding.top;
  final yBottom = parentRect.bottom - menuRect.height + padding.bottom;

  final preferredPos =
      Offset(preferRight ? xRight : xLeft, preferTop ? yTop : yBottom);

  // Weights: overflow dominates, then horizontal-side consistency, then vertical,
  // then distance (for tie-breaking).
  const wOverflow = 1e6; // keep on-screen above all
  const wFlipH = 2e3; // prefer keeping the same horizontal side
  const wFlipV = 4e2; // prefer keeping the same vertical side
  const wDistance = 1.0; // minor tie-breaker

  ({Offset pos, AlignmentGeometry align, double cost}) score(
      bool right, bool top) {
    final pos = Offset(right ? xRight : xLeft, top ? yTop : yBottom);
    final rect = pos & menuRect.size;

    final overflow = overflowAmount(rect);
    final flipHPenalty = right == preferRight ? 0.0 : 1.0;
    final flipVPenalty = top == preferTop ? 0.0 : 1.0;
    final dist =
        (pos.dx - preferredPos.dx).abs() + (pos.dy - preferredPos.dy).abs();

    final cost = overflow * wOverflow +
        flipHPenalty * wFlipH +
        flipVPenalty * wFlipV +
        dist * wDistance;

    return (
      pos: pos,
      align: alignFromSides(right: right, top: top),
      cost: cost
    );
  }

  // Try four logical placements around the parent.
  final candidates = <({Offset pos, AlignmentGeometry align, double cost})>[
    score(true, true), // right, top
    score(true, false), // right, bottom
    score(false, true), // left, top
    score(false, false), // left, bottom
  ];

  // Choose the best candidate by cost.
  candidates.sort((a, b) => a.cost.compareTo(b.cost));
  final best = candidates.first;

  // Final clamp to ensure we're inside the safe area (even if menu > safe).
  final finalX = clampX(best.pos.dx);
  final finalY = clampY(best.pos.dy);

  return (pos: Offset(finalX, finalY), alignment: best.align);
}

Offset calculateSubmenuPosition(Rect parentRect, EdgeInsets? menuPadding) {
  menuPadding ??= EdgeInsets.zero;

  return Offset(
    parentRect.right + menuPadding.right,
    parentRect.top - menuPadding.top,
  );
}

// bool hasSameFocusNodeId(String line1, String line2) {
//   final regex = RegExp(r'FocusNode#(\d+)');
//   final id1 = regex.firstMatch(line1)?.group(1);
//   final id2 = regex.firstMatch(line2)?.group(1);
//   return id1 != null && id1 == id2;
// }
