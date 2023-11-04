import 'package:flutter/widgets.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../core/utils/utils.dart';
import 'context_menu.dart';

class ContextMenuState extends ChangeNotifier {
  final focusScopeNode = FocusScopeNode();

  OverlayEntry? overlay;
  ContextMenuEntry? _focusedEntry;
  ContextMenuEntry? _openedEntry;
  bool isPositionVerified = false;
  bool isSubmenuOpen = false;

  Offset position;
  bool isLTR;
  final bool isSubmenu;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final double maxWidth;
  final Rect? parentItemRect;
  final VoidCallback? selfClose;

  ContextMenuState({
    required this.position,
    required this.isSubmenu,
    required this.isLTR,
    required this.padding,
    required this.borderRadius,
    required this.maxWidth,
    required this.parentItemRect,
    required this.selfClose,
  });

  ContextMenuEntry? get focusedEntry => _focusedEntry;
  set focusedEntry(ContextMenuEntry? value) {
    if (_focusedEntry == value) return;
    _focusedEntry = value;
    notifyListeners();
  }

  ContextMenuEntry? get openedEntry => _openedEntry;
  set openedEntry(ContextMenuEntry? value) {
    if (_openedEntry == value) return;
    _openedEntry = value;
    notifyListeners();
  }

  void showSubmenu({
    required ContextMenuItem item,
    required BuildContext context,
    required List<ContextMenuEntry> items,
    Offset? position,
    bool? isLTR,
  }) {
    closeCurrentSubmenu();

    final parentRect = context.getWidgetBounds();
    if (parentRect == null) return;

    position ??= _calculateSubmenuPosition(parentRect, isLTR);

    overlay = _createSubmenuOverlay(items, position, isLTR, parentRect);
    Overlay.of(context).insert(overlay!);
    isSubmenuOpen = true;
    _openedEntry = item;
  }

  OverlayEntry _createSubmenuOverlay(
    List<ContextMenuEntry> items,
    Offset position, [
    bool? isLTR,
    Rect? parentRect,
  ]) {
    return OverlayEntry(
      builder: (context) {
        return ContextMenu.submenu(
          position: position,
          items: items,
          isLTR: isLTR ?? this.isLTR,
          parentItemRect: parentRect,
          selfClose: closeCurrentSubmenu,
          padding: padding,
          borderRadius: borderRadius,
          maxWidth: maxWidth,
        );
      },
    );
  }

  void closeCurrentSubmenu() {
    overlay?.remove();
    overlay = null;
    openedEntry = null;
    isSubmenuOpen = false;
  }

  void verifyPosition(BuildContext context) {
    if (isPositionVerified) return;

    focusScopeNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Offset newPosition = calculateContextMenuPosition(
        context,
        padding: padding,
        isSubmenu: isSubmenu,
        parentRect: parentItemRect,
        isLTR: isLTR,
      );

      isLTR = newPosition.dx >= position.dx;
      position = newPosition;
      
      notifyListeners();
      isPositionVerified = true;
      focusScopeNode.nextFocus();
    });
  }

  Offset _calculateSubmenuPosition(
    Rect parentRect,
    bool? isLTR,
  ) {
    double left = parentRect.left + parentRect.width;
    double top = parentRect.top;

    left += padding.right;
    top -= padding.top;

    return Offset(left, top);
  }

  @override
  void dispose() {
    closeCurrentSubmenu();
    super.dispose();
  }
}
