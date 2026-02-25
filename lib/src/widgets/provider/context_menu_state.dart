import 'package:flutter/widgets.dart';

import '../../../flutter_context_menu.dart';
import '../../core/utils/extensions/build_context_ext.dart';
import '../../core/utils/utils.dart';
import '../base/context_menu_widget.dart';
import 'context_menu_provider.dart';

/// Manages the state of the context menu.
///
/// This class is used to manage the state of the context menu. It provides methods to
/// show and hide the context menu, and to update the position of the context menu.
class ContextMenuState<T> extends ChangeNotifier {
  final GlobalKey key = GlobalKey();
  final focusScopeNode = FocusScopeNode();

  final overlayController = OverlayPortalController(debugLabel: 'ContextMenu');

  /// The entry that is currently focused in the context menu.
  ContextMenuEntry<T>? _focusedEntry;

  /// The submenu entry that is currently opened in the context menu.
  ContextMenuItem<T>? _selectedItem;

  /// Whether the position of the context menu has been verified.
  bool _isPositionVerified = false;

  /// The position of the context menu.
  Offset _position;

  /// The spawn anchor where the context menu should be spawned from.
  ///
  /// Used internally by the [ContextMenuState]
  ///
  /// Defaults to:
  /// - [AlignmentDirectional.center] for top level context menus and
  /// - [AlignmentDirectional.topStart] for submenus.
  AlignmentGeometry _spawnAnchor;

  /// The rectangle representing the parent item, used for submenu positioning.
  final Rect? _parentItemRect;

  /// Whether the context menu is a submenu or not.
  final bool _isSubmenu;

  final ContextMenu<T> menu;
  final ContextMenuItem<T>? parentItem;
  final VoidCallback? selfClose;
  WidgetBuilder submenuBuilder = (context) => const SizedBox.shrink();

  final ValueChanged<T?>? onItemSelected;

  ContextMenuState({
    required this.menu,
    this.parentItem,
    this.onItemSelected,
  })  : _position = menu.position ?? Offset.zero,
        _parentItemRect = null,
        _isSubmenu = false,
        selfClose = null,
        _spawnAnchor = AlignmentDirectional.center;

  ContextMenuState.submenu({
    required this.menu,
    required this.selfClose,
    this.parentItem,
    AlignmentGeometry? spawnAnchor,
    Rect? parentItemRect,
    this.onItemSelected,
  })  : _position = menu.position ?? Offset.zero,
        _spawnAnchor = spawnAnchor ?? AlignmentDirectional.topStart,
        _parentItemRect = parentItemRect,
        _isSubmenu = true;

  List<ContextMenuEntry> get entries => menu.entries;

  Offset get position => _position;

  Map<ShortcutActivator, VoidCallback> get shortcuts => menu.shortcuts;

  ContextMenuEntry? get focusedEntry => _focusedEntry;

  ContextMenuItem? get selectedItem => _selectedItem;

  bool get isPositionVerified => _isPositionVerified;

  bool get isSubmenuOpen => overlayController.isShowing;

  AlignmentGeometry get spawnAnchor => _spawnAnchor;

  Rect? get parentItemRect => _parentItemRect;

  bool get isSubmenu => _isSubmenu;

  static ContextMenuState<T> of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ContextMenuProvider<T>>();

    if (provider == null) {
      throw 'No ContextMenuProvider found in context';
    }
    return provider.notifier!;
  }

  static ContextMenuState<T>? maybeOf<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ContextMenuProvider<T>>();

    return provider?.notifier;
  }

  void setFocusedEntry(ContextMenuEntry<T>? value) {
    if (value == _focusedEntry) return;
    _focusedEntry = value;
    notifyListeners();
  }

  void setSelectedItem(ContextMenuItem<T>? value) {
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
    required ContextMenuItem<T> parent,
  }) {
    closeSubmenu();

    final items = parent.items;
    final submenuParentRect = context.getWidgetBounds();
    if (submenuParentRect == null) return;

    final style = ContextMenuTheme.resolve(context).merge(menu.style);
    final padding = style.padding;

    final submenuPosition =
        calculateSubmenuPosition(submenuParentRect, padding);

    submenuBuilder = (BuildContext context) {
      final subMenuState = ContextMenuState<T>.submenu(
        menu: menu.copyWith(
          entries: items,
          position: submenuPosition,
        ),
        spawnAnchor: spawnAnchor,
        parentItemRect: submenuParentRect,
        selfClose: closeSubmenu,
        parentItem: parent,
        onItemSelected: onItemSelected,
      );

      return ContextMenuWidget<T>(menuState: subMenuState);
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

      _position = boundaries.pos;
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
