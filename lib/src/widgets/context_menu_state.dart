import 'package:flutter/widgets.dart';

import '../core/enums/spawn_direction.dart';
import '../core/models/context_menu.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../core/utils/utils.dart';
import 'context_menu_widget.dart';

/// Manages the state of the context menu.
///
/// This class is used to manage the state of the context menu. It provides methods to
/// show and hide the context menu, and to update the position of the context menu.
class ContextMenuState extends ChangeNotifier {
  final focusScopeNode = FocusScopeNode();

  /// The overlay entry of the context menu.
  OverlayEntry? _overlay;

  /// The entry that is currently focused in the context menu.
  ContextMenuEntry? _focusedEntry;

  /// The submenu entry that is currently opened in the context menu.
  ContextMenuItem? _selectedItem;

  /// Whether the position of the context menu has been verified.
  bool _isPositionVerified = false;

  /// Whether the context menu is a submenu or not.
  bool _isSubmenuOpen = false;

  /// The direction in which the context menu should be spawned.
  /// Used internally by the [ContextMenuState]
  ///
  /// Defaults to [SpawnDirection.end].
  SpawnDirection _spawnDirection = SpawnDirection.end;

  /// The rectangle representing the parent item, used for submenu positioning.
  final Rect? _parentItemRect;

  /// Whether the context menu is a submenu or not.
  final bool _isSubmenu;

  final ContextMenu menu;
  final ContextMenuItem? parentItem;
  final VoidCallback? selfClose;

  ContextMenuState({
    required this.menu,
    this.parentItem,
  })  : _parentItemRect = null,
        _isSubmenu = false,
        selfClose = null;

  ContextMenuState.submenu({
    required this.menu,
    required this.selfClose,
    this.parentItem,
    SpawnDirection? spawnDirection,
    Rect? parentItemRect,
  })  : _spawnDirection = spawnDirection ?? SpawnDirection.end,
        _parentItemRect = parentItemRect,
        _isSubmenu = true;

  List<ContextMenuEntry> get entries => menu.entries;
  Offset get position => menu.position ?? Offset.zero;
  double get maxWidth => menu.maxWidth;
  BorderRadiusGeometry? get borderRadius => menu.borderRadius;
  EdgeInsets get padding => menu.padding;
  Clip get clipBehavior => menu.clipBehavior;
  BoxDecoration? get boxDecoration => menu.boxDecoration;
  Map<ShortcutActivator, VoidCallback> get shortcuts => menu.shortcuts;

  ContextMenuEntry? get focusedEntry => _focusedEntry;
  ContextMenuItem? get selectedItem => _selectedItem;
  bool get isPositionVerified => _isPositionVerified;
  bool get isSubmenuOpen => _isSubmenuOpen;
  SpawnDirection get spawnDirection => _spawnDirection;
  Rect? get parentItemRect => _parentItemRect;
  bool get isSubmenu => _isSubmenu;

  void setFocusedEntry(ContextMenuEntry? value) {
    if (value == _focusedEntry) return;
    _focusedEntry = value;
    notifyListeners();
  }

  void setSelectedItem(ContextMenuItem? value) {
    if (value == _selectedItem) return;
    _selectedItem = value;
    notifyListeners();
  }

  /// Determines whether the entry is focused.
  bool isFocused(ContextMenuEntry entry) => entry == focusedEntry;

  /// Determines whether the entry is opened as a submenu.
  bool isOpened(ContextMenuItem item) => item == selectedItem;

  Offset _calculateSubmenuPosition(
    Rect parentRect,
    SpawnDirection? spawnDirection,
  ) {
    double left = parentRect.left + parentRect.width;
    double top = parentRect.top;

    left += menu.padding.right;
    top -= menu.padding.top;

    return Offset(left, top);
  }

  OverlayEntry _createSubmenuOverlay(
    List<ContextMenuEntry> entries,
    Offset submenuPosition,
    Rect? submenuParentRect,
    ContextMenuItem subMenuParent,
  ) {
    return OverlayEntry(
      builder: (context) {
        final subMenuState = ContextMenuState.submenu(
          menu: menu.copyWith(
            entries: entries,
            position: submenuPosition,
          ),
          spawnDirection: spawnDirection,
          parentItemRect: submenuParentRect,
          selfClose: closeSubmenu,
          parentItem: subMenuParent,
        );
        return ContextMenuWidget(
          menuState: subMenuState,
        );
      },
    );
  }

  /// Shows the submenu at the specified position.
  void showSubmenu({
    required BuildContext context,
    required ContextMenuItem parent,
  }) {
    closeSubmenu();

    final items = parent.items;
    final submenuParentRect = context.getWidgetBounds();
    if (submenuParentRect == null) return;

    final submenuPosition =
        _calculateSubmenuPosition(submenuParentRect, spawnDirection);

    _overlay = _createSubmenuOverlay(
      items!,
      submenuPosition,
      submenuParentRect,
      parent,
    );
    Overlay.of(context).insert(_overlay!);
    _isSubmenuOpen = true;
    setSelectedItem(parent);
  }

  /// Verifies the position of the context menu and updates it if necessary.
  void verifyPosition(BuildContext context) {
    if (isPositionVerified) return;

    focusScopeNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Offset newPosition = calculateContextMenuPosition(context, this);

      _spawnDirection = newPosition.dx >= position.dx
          ? SpawnDirection.end
          : SpawnDirection.start;
      menu.position = newPosition;

      notifyListeners();
      _isPositionVerified = true;
      focusScopeNode.nextFocus();
    });
  }

  /// Closes the current submenu and removes the overlay.
  void closeSubmenu() {
    if (!_isSubmenuOpen) return;
    _selectedItem = null;
    _isSubmenuOpen = false;
    _overlay?.remove();
    _overlay = null;
    notifyListeners();
  }

  /// Closes the context menu and removes the overlay.
  void close() {
    closeSubmenu();
    focusScopeNode.dispose();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }
}
