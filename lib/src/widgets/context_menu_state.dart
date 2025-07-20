import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../core/models/context_menu.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../core/utils/utils.dart';
import 'context_menu_provider.dart';
import 'context_menu_widget.dart';

/// Manages the state of the context menu.
///
/// This class is used to manage the state of the context menu. It provides methods to
/// show and hide the context menu, and to update the position of the context menu.
class ContextMenuState extends ChangeNotifier {
  final GlobalKey key = GlobalKey();
  final focusScopeNode = FocusScopeNode();

  final overlayController = OverlayPortalController(debugLabel: 'ContextMenu');

  /// The entry that is currently focused in the context menu.
  ContextMenuEntry? _focusedEntry;

  /// The submenu entry that is currently opened in the context menu.
  ContextMenuItem? _selectedItem;

  /// Whether the position of the context menu has been verified.
  bool _isPositionVerified = false;

  // /// Whether the context menu is a submenu or not.
  // bool _isSubmenuOpen = false;

  /// The direction in which the context menu should be spawned.
  /// Used internally by the [ContextMenuState]
  ///
  /// Defaults to [SpawnAlignment.topEnd].
  AlignmentGeometry _spawnAnchor = AlignmentDirectional.topEnd;

  /// The rectangle representing the parent item, used for submenu positioning.
  final Rect? _parentItemRect;

  /// Whether the context menu is a submenu or not.
  final bool _isSubmenu;

  final ContextMenu menu;
  final ContextMenuItem? parentItem;
  final VoidCallback? selfClose;
  WidgetBuilder submenuBuilder = (context) => const SizedBox.shrink();

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
    AlignmentGeometry? spawnAnchor,
    Rect? parentItemRect,
    GlobalKey? parentMenuKey,
  })  : _spawnAnchor = spawnAnchor ?? AlignmentDirectional.topEnd,
        _parentItemRect = parentItemRect,
        _isSubmenu = true;

  List<ContextMenuEntry> get entries => menu.entries;

  Offset get position => menu.position ?? Offset.zero;

  double get maxWidth => menu.maxWidth;

  double? get maxHeight => menu.maxHeight;

  BorderRadiusGeometry? get borderRadius => menu.borderRadius;

  EdgeInsets get padding => menu.padding;

  Clip get clipBehavior => menu.clipBehavior;

  BoxDecoration? get boxDecoration => menu.boxDecoration;

  Map<ShortcutActivator, VoidCallback> get shortcuts => menu.shortcuts;

  ContextMenuEntry? get focusedEntry => _focusedEntry;

  ContextMenuItem? get selectedItem => _selectedItem;

  bool get isPositionVerified => _isPositionVerified;

  bool get isSubmenuOpen => overlayController.isShowing;

  AlignmentGeometry get spawnAnchor => _spawnAnchor;

  Rect? get parentItemRect => _parentItemRect;

  bool get isSubmenu => _isSubmenu;

  static ContextMenuState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ContextMenuProvider>();

    if (provider == null) {
      throw 'No ContextMenuProvider found in context';
    }
    return provider.notifier!;
  }

  static ContextMenuState? maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ContextMenuProvider>();

    return provider?.notifier;
  }

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

  void setSpawnAnchor(AlignmentGeometry value) {
    _spawnAnchor = value;
    notifyListeners();
  }

  /// Determines whether the entry is focused.
  bool isFocused(ContextMenuEntry entry) => entry == focusedEntry;

  /// Determines whether the entry is opened as a submenu.
  bool isOpened(ContextMenuItem item) => item == selectedItem;

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
        calculateSubmenuPosition(submenuParentRect, menu.padding);

    submenuBuilder = (BuildContext context) {
      final subMenuState = ContextMenuState.submenu(
        menu: menu.copyWith(
          entries: items,
          position: submenuPosition,
        ),
        spawnAnchor: spawnAnchor,
        parentItemRect: submenuParentRect,
        selfClose: closeSubmenu,
        parentItem: parent,
      );

      return ContextMenuWidget(menuState: subMenuState);
    };

    overlayController.show();
    setSelectedItem(parent);
  }

  /// Closes the current submenu and removes the overlay.
  void closeSubmenu() {
    if (!isSubmenuOpen) return;
    _selectedItem = null;
    overlayController.hide();
    notifyListeners();
  }

  /// Verifies the position of the context menu and updates it if necessary.
  void verifyPosition(BuildContext context) {
    if (isPositionVerified) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boundaries = calculateContextMenuBoundaries(
        context,
        menu,
        parentItemRect,
        _spawnAnchor,
        _isSubmenu,
      );

      menu.position = boundaries.pos;
      _spawnAnchor = boundaries.alignment;

      notifyListeners();
      _isPositionVerified = true;
      focusScopeNode.requestFocus();
    });
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
