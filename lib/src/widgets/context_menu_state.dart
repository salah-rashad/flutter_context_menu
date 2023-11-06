import 'package:flutter/widgets.dart';

import '../core/enums/spawn_direction.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../core/utils/utils.dart';
import 'context_menu.dart';

/// Manages the state of the context menu.
///
/// This class is used to manage the state of the context menu. It provides methods to
/// show and hide the context menu, and to update the position of the context menu.
class ContextMenuState extends ChangeNotifier {
  final focusScopeNode = FocusScopeNode();

  OverlayEntry? overlay;
  ContextMenuEntry? _focusedEntry;
  ContextMenuEntry? _openedEntry;
  bool isPositionVerified = false;
  bool isSubmenuOpen = false;

  Offset position;
  SpawnDirection spawnDirection;
  final bool isSubmenu;
  final EdgeInsets padding;
  final BorderRadiusGeometry? borderRadius;
  final double maxWidth;
  final Rect? parentItemRect;
  final VoidCallback? selfClose;

  ContextMenuState({
    required this.position,
    required this.isSubmenu,
    required this.spawnDirection,
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

  /// Shows the submenu at the specified position.
  void showSubmenu({
    required ContextMenuItem item,
    required BuildContext context,
    required List<ContextMenuEntry> items,
    Offset? position,
    SpawnDirection? spawnDirection,
  }) {
    closeCurrentSubmenu();

    final parentRect = context.getWidgetBounds();
    if (parentRect == null) return;

    position ??= _calculateSubmenuPosition(parentRect, spawnDirection);

    overlay =
        _createSubmenuOverlay(items, position, spawnDirection, parentRect);
    Overlay.of(context).insert(overlay!);
    isSubmenuOpen = true;
    _openedEntry = item;
  }

  OverlayEntry _createSubmenuOverlay(
    List<ContextMenuEntry> entries,
    Offset position, [
    SpawnDirection? spawnDirection,
    Rect? parentRect,
  ]) {
    return OverlayEntry(
      builder: (context) {
        return ContextMenu.submenu(
          position: position,
          entries: entries,
          spawnDirection: spawnDirection ?? this.spawnDirection,
          parentItemRect: parentRect,
          selfClose: closeCurrentSubmenu,
          padding: padding,
          borderRadius: borderRadius,
          maxWidth: maxWidth,
        );
      },
    );
  }

  /// Closes the current submenu and removes the overlay.
  void closeCurrentSubmenu() {
    overlay?.remove();
    overlay = null;
    openedEntry = null;
    isSubmenuOpen = false;
  }

  /// Verifies the position of the context menu and updates it if necessary.
  void verifyPosition(BuildContext context) {
    if (isPositionVerified) return;

    focusScopeNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Offset newPosition = calculateContextMenuPosition(
        context,
        padding: padding,
        isSubmenu: isSubmenu,
        parentRect: parentItemRect,
        spawnDirection: spawnDirection,
      );

      spawnDirection = newPosition.dx >= position.dx
          ? SpawnDirection.end
          : SpawnDirection.start;
      position = newPosition;

      notifyListeners();
      isPositionVerified = true;
      focusScopeNode.nextFocus();
    });
  }

  Offset _calculateSubmenuPosition(
    Rect parentRect,
    SpawnDirection? spawnDirection,
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
