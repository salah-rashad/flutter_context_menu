import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/helpers.dart';
import 'context_menu_state.dart';

const double _kMaxContextMenuWidth = 350.0;

/// A context menu widget.
///
/// Displays a list of items that can be performed on the current context.
///
/// The context menu is displayed when the user right-clicks or presses the
/// context menu key.
///
/// To use the context menu, create a list of `ContextMenuEntry` objects and
/// pass them to the `items` property. Each `ContextMenuEntry` object
/// represents a single item in the context menu.
///
/// You can also use the `ContextMenu.submenu()` constructor to create a
/// context menu that is a submenu of another context menu.
///
/// Example usage:
/// ```dart
/// final contextMenu = ContextMenu(
///   items: [
///     DefaultContextMenuItem(
///       title: 'Copy',
///       onSelected: () {
///         // implement copy
///       },
///     ),
///     DefaultContextMenuItem(
///       title: 'Cut',
///       onSelected: () {
///         // implement cut
///       },
///     ),
///     DefaultContextMenuItem(
///       title: 'Paste',
///       onSelected: () {
///         // implement paste
///       },
///     ),
///   ],
/// );
/// ```
///
/// See also:
/// - [ContextMenuState]
/// - [ContextMenuEntry]
/// - [ContextMenuItem]

class ContextMenu extends StatefulWidget {
  /// The position where the context menu will be displayed.
  final Offset? position;

  /// The list of entries displayed in the context menu.
  final List<ContextMenuEntry> items;

  /// Whether the context menu is a submenu or not.
  final bool isSubmenu;

  /// Whether the submenu should be displayed from left to right (LTR) or right to left (RTL) direction.
  ///
  /// Defaults to `true`.
  final bool isLTR;

  /// The padding around the context menu.
  final EdgeInsets padding;

  /// The border radius of the context menu.
  final BorderRadiusGeometry? borderRadius;

  /// The maximum width of the context menu.
  final double maxWidth;

  /// The rectangle representing the parent item, used for submenu positioning.
  final Rect? parentItemRect;

  /// Callback function to close the context menu.
  final VoidCallback? selfClose;

  /// Creates a context menu.
  ///
  /// - [items] - The list of entries displayed in the context menu.
  /// - [position] - The position where the context menu will be displayed.
  /// - [padding] - The padding around the context menu.
  /// - [borderRadius] - The border radius of the context menu.
  /// - [maxWidth] - The maximum width of the context menu.
  ///
  /// See also:
  /// - [ContextMenu.submenu]
  const ContextMenu({
    super.key,
    required this.items,
    this.position,
    this.padding = const EdgeInsets.all(4.0),
    this.borderRadius,
    this.maxWidth = _kMaxContextMenuWidth,
  })  : isSubmenu = false,
        isLTR = true,
        parentItemRect = null,
        selfClose = null;

  /// Creates a context menu that is a submenu of another context menu.
  ///
  /// - [items] - The list of entries displayed in the context menu.
  /// - [selfClose] - Callback function to close the context menu.
  /// - [parentItemRect] - The rectangle representing the parent item, used for submenu positioning.
  /// - [position] - The position where the context menu will be displayed.
  /// - [padding] - The padding around the context menu.
  /// - [borderRadius] - The border radius of the context menu.
  /// - [maxWidth] - The maximum width of the context menu.
  /// - [isLTR] - Whether the submenu should be displayed from left to right (LTR) or right to left (RTL) direction.
  ///
  /// See also:
  /// - [ContextMenu]
  const ContextMenu.submenu({
    super.key,
    required this.items,
    required this.selfClose,
    required this.parentItemRect,
    this.position,
    this.padding = const EdgeInsets.all(4.0),
    this.borderRadius,
    this.maxWidth = _kMaxContextMenuWidth,
    this.isLTR = true,
  }) : isSubmenu = true;

  @override
  State<ContextMenu> createState() => _ContextMenuState();

  /// Creates a copy of the `ContextMenu` with optional new values.
  ContextMenu copyWith({
    Key? key,
    Offset? position,
    List<ContextMenuEntry>? items,
    EdgeInsets? padding,
    double? maxWidth,
  }) {
    return ContextMenu(
      key: key ?? this.key,
      position: position ?? this.position,
      items: items ?? this.items,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
    );
  }

  /// Creates a copy of the `ContextMenu` as a submenu with optional new values.
  ContextMenu copyWithAsSubmenu({
    Key? key,
    Offset? position,
    List<ContextMenuEntry>? items,
    EdgeInsets? padding,
    double? maxWidth,
    bool? isSubmenu,
    bool? isLTR,
    Rect? parentItemRect,
    VoidCallback? selfClose,
  }) {
    return ContextMenu.submenu(
      key: key ?? this.key,
      position: position ?? this.position,
      items: items ?? this.items,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
      isLTR: isLTR ?? this.isLTR,
      parentItemRect: parentItemRect ?? this.parentItemRect,
      selfClose: selfClose ?? this.selfClose,
    );
  }

  Future<T?> show<T>(BuildContext context) {
    return showContextMenu(context, contextMenu: this);
  }
}

class _ContextMenuState extends State<ContextMenu> {
  late final ContextMenuState _menuState;

  @override
  void initState() {
    super.initState();
    _menuState = ContextMenuState(
      position: widget.position ?? const Offset(0, 0),
      isSubmenu: widget.isSubmenu,
      isLTR: widget.isLTR,
      padding: widget.padding,
      borderRadius: widget.borderRadius,
      maxWidth: widget.maxWidth,
      parentItemRect: widget.parentItemRect,
      selfClose: widget.selfClose,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _menuState,
      child: Consumer<ContextMenuState>(
        builder: (context, state, _) {
          state.verifyPosition(context);
          return Positioned(
            left: state.position.dx,
            top: state.position.dy,
            child: FocusScope(
              autofocus: true,
              node: state.focusScopeNode,
              child: Opacity(
                opacity: state.isPositionVerified ? 1.0 : 0.0,
                child: _buildMenuView(context),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the context menu view.
  Widget _buildMenuView(BuildContext context) {
    return Container(
      padding: widget.padding,
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.5),
            offset: const Offset(0.0, 2.0),
            blurRadius: 10,
            spreadRadius: -1,
          )
        ],
        borderRadius: widget.borderRadius ?? BorderRadius.circular(4.0),
      ),
      child: Material(
        elevation: 0.0,
        type: MaterialType.transparency,
        child: IntrinsicWidth(
          child: Column(
            children: [
              for (final item in widget.items) _MenuEntry(entry: item)
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that represents a single item in a context menu.
///
/// This widget is used internally by the `ContextMenu` widget.
class _MenuEntry<T> extends StatelessWidget {
  final ContextMenuEntry entry;
  const _MenuEntry({required this.entry});

  @override
  Widget build(BuildContext context) {
    final menuState = context.read<ContextMenuState>();
    return MouseRegion(
      onEnter: (event) => _onMouseEnter(menuState, context, event),
      onExit: entry.onMouseExit,
      onHover: entry.onMouseHover,
      child: entry.builder(context, menuState),
    );
  }

  /// Handles the mouse enter event for the context menu entry.
  ///
  /// This method is called when the mouse pointer enters the area of the context menu entry.
  /// - If the entry is a submenu, it shows the submenu if it is not already opened.
  /// - If the entry is not a submenu, it closes the current context menu.
  void _onMouseEnter(
    ContextMenuState menuState,
    BuildContext context,
    PointerEnterEvent event,
  ) {
    if (entry is ContextMenuItem) {
      final item = entry as ContextMenuItem;
      final isSubmenuItem = item.isSubmenuItem;
      final itemIsNotOpened = item != menuState.openedEntry;

      final canShowSubmenu = isSubmenuItem && itemIsNotOpened;
      final canCloseSubmenu = !isSubmenuItem && menuState.focusedEntry != item;

      if (canCloseSubmenu) {
        menuState.closeCurrentSubmenu();
      } else if (canShowSubmenu) {
        menuState.showSubmenu(
          item: item,
          context: context,
          items: item.items!,
        );
      }

      menuState.focusedEntry = item;
    }
    entry.onMouseEnter(event);
  }
}
