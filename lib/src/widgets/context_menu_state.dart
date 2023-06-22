import 'package:flutter/widgets.dart';

import '../entries/context_menu_entry.dart';
import '../entries/context_menu_item.dart';
import '../utils/extensions.dart';
import '../utils/utils.dart';
import 'context_menu.dart';

class ContextMenuState extends ChangeNotifier {
  final focusScopeNode = FocusScopeNode();

  final ContextMenu _contextMenu;
  bool isLTR;
  Offset position;

  OverlayEntry? overlay;
  ContextMenuEntry? _focusedEntry;
  ContextMenuEntry? _openedEntry;
  bool isPositionVerified = false;
  bool isSubmenuOpen = false;

  ContextMenuState({
    required ContextMenu contextMenu,
    this.isLTR = true,
    Offset? position,
  })  : _contextMenu = contextMenu,
        position = position ?? const Offset(0, 0);

  bool get isSubmenu => _contextMenu.isSubmenu;
  VoidCallback? get closeMenu => _contextMenu.selfClose;

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

  void verifyPosition(BuildContext context, bool isSubmenu, Rect? parentRect) {
    if (isPositionVerified) return;

    focusScopeNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Offset newPosition = calculateContextMenuPosition(
        context,
        padding: _contextMenu.padding,
        isSubmenu: isSubmenu,
        parentRect: parentRect,
        isLTR: _contextMenu.isLTR,
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

    left += _contextMenu.padding.right;
    top -= _contextMenu.padding.top;

    return Offset(left, top);
  }

  @override
  void dispose() {
    closeCurrentSubmenu();
    super.dispose();
  }
}
