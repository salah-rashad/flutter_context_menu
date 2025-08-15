import 'dart:math';

import 'package:flutter/widgets.dart';

import '../models/context_menu.dart';
import '../utils/extensions.dart';

const double kContextMenuSafeArea = 8.0;

/// Calculates the position of the context menu while ensuring it doesn't
/// exceed screen boundaries, using a scoring-based placement for submenus.
({Offset pos, AlignmentGeometry alignment}) calculateContextMenuBoundaries(
  BuildContext context,
  ContextMenu menu,
  Rect? parentRect,
  AlignmentGeometry spawnAlignment,
  bool isSubmenu,
) {
  final screenSize = MediaQuery.of(context).size;
  final safe = (Offset.zero & screenSize).deflate(kContextMenuSafeArea);
  final menuRect = context.getWidgetBounds()!;
  final textDir = Directionality.maybeOf(context) ?? TextDirection.ltr;

  // Helpers
  double clampX(double x) =>
      x.clamp(safe.left, max(safe.left, safe.right - menuRect.width));
  double clampY(double y) =>
      y.clamp(safe.top, max(safe.top, safe.bottom - menuRect.height));

  double overflowAmount(Rect r) {
    final double dx = max(0, safe.left - r.left) + max(0, r.right - safe.right);
    final double dy = max(0, safe.top - r.top) + max(0, r.bottom - safe.bottom);
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
  final xRight = parentRect.right + menu.padding.left;
  final xLeft = parentRect.left - menuRect.width - menu.padding.right;
  final yTop = parentRect.top - menu.padding.top;
  final yBottom = parentRect.bottom - menuRect.height + menu.padding.bottom;

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

Offset calculateSubmenuPosition(Rect parentRect, EdgeInsets menuPadding) {
  return Offset(
    parentRect.right + menuPadding.right,
    parentRect.top - menuPadding.top,
  );
}

bool hasSameFocusNodeId(String line1, String line2) {
  final regex = RegExp(r'FocusNode#(\d+)');
  final id1 = regex.firstMatch(line1)?.group(1);
  final id2 = regex.firstMatch(line2)?.group(1);
  return id1 != null && id1 == id2;
}

Rect getScreenRect(BuildContext context) {
  final size = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  ).size;
  return Offset.zero & size;
}
