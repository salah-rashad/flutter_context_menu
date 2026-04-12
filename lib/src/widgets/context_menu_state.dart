import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../core/models/context_menu.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions/build_context_ext.dart';
import '../core/utils/utils.dart';
import 'context_menu_provider.dart';
import 'context_menu_widget.dart';

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
  })  : _parentItemRect = null,
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
  })  : _spawnAnchor = spawnAnchor ?? AlignmentDirectional.topStart,
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

    final submenuPosition =
        calculateSubmenuPosition(submenuParentRect, menu.padding);

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

      menu.position = boundaries.pos;
      _spawnAnchor = boundaries.alignment;

      notifyListeners();
      _isPositionVerified = true;
      focusScopeNode.requestFocus();
    });
  }

  // --- Activator registry ---

  final Map<ContextMenuEntry, VoidCallback> _activators = {};

  /// Registers an activation callback for [entry].
  ///
  /// Called by the widget layer so that keyboard shortcuts and tap both
  /// converge to the same code path. Stateful entry widgets (e.g., a custom
  /// checkable item) call this in `initState` to override the default activator
  /// provided by [ContextMenuInteractiveEntry.createActivator].
  @internal
  void registerActivator(ContextMenuEntry entry, VoidCallback callback) {
    _activators[entry] = callback;
  }

  /// Unregisters the activation callback for [entry].
  ///
  /// Call in `dispose` of any widget that registered a custom activator.
  @internal
  void unregisterActivator(ContextMenuEntry entry) {
    _activators.remove(entry);
  }

  /// Returns `true` if an activator is registered for [entry].
  @internal
  bool hasActivator(ContextMenuEntry entry) => _activators.containsKey(entry);

  /// Activates the currently focused entry.
  ///
  /// Called by keyboard shortcuts (Space, Enter).
  @internal
  bool activateFocusedEntry() {
    final entry = _focusedEntry;
    if (entry == null) return false;
    final activator = _activators[entry];
    if (activator == null) return false;
    activator();
    return true;
  }

  /// Activates [entry] by invoking its registered activator.
  ///
  /// Used internally by [MenuEntryWidget] keyboard shortcuts and tap handlers.
  @internal
  bool activateEntry(ContextMenuEntry entry) {
    final activator = _activators[entry];
    if (activator == null) return false;
    activator();
    return true;
  }

  /// Toggles the submenu for [parent] — opens it if closed, closes it if open.
  ///
  /// Available for custom entry implementations that need submenu toggle behaviour.
  void toggleSubmenu({
    required BuildContext context,
    required ContextMenuItem<T> parent,
  }) {
    if (isSubmenuOpen && focusedEntry == selectedItem) {
      closeSubmenu();
    } else {
      showSubmenu(context: context, parent: parent);
    }
  }

  /// Selects [item] and closes the menu, returning [item]'s value.
  ///
  /// Available for custom entry implementations that need close-and-return behaviour.
  void selectAndClose(BuildContext context, ContextMenuItem<T> item) {
    setSelectedItem(item);
    if (Navigator.canPop(context)) {
      Navigator.pop(context, item.value);
    }
    item.onSelected?.call(item.value);
    onItemSelected?.call(item.value);
  }

  /// Activates [item]: opens its submenu if it has one, otherwise selects it
  /// and closes the menu.
  ///
  /// This is the default activation behaviour for all [ContextMenuItem]
  /// subclasses. Custom entries extending [ContextMenuItem] get this for free
  /// via [ContextMenuInteractiveEntry.createActivator] and do not need to call
  /// this directly.
  void activateMenuItem(BuildContext context, ContextMenuItem<T> item) {
    if (!item.enabled) return;
    if (item.isSubmenuItem) {
      toggleSubmenu(context: context, parent: item);
    } else {
      selectAndClose(context, item);
    }
  }

  /// Closes the context menu and removes the overlay.
  void close() {
    _activators.clear();
    closeSubmenu();
    focusScopeNode.dispose();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }
}
