import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../entries/context_menu_entry.dart';
import '../entries/context_menu_item.dart';
import 'context_menu_state.dart';

const double _kMaxContextMenuWidth = 350.0;

class ContextMenu extends StatelessWidget {
  final Offset? position;
  final List<ContextMenuEntry> items;
  final bool isSubmenu;
  final bool isLTR;
  final EdgeInsets padding;
  final double maxWidth;
  final Rect? parentItemRect;
  final VoidCallback? selfClose;

  const ContextMenu({
    super.key,
    required BuildContext context,
    this.position,
    required this.items,
    this.padding = const EdgeInsets.all(4.0),
    this.maxWidth = _kMaxContextMenuWidth,
  })  : isSubmenu = false,
        isLTR = true,
        parentItemRect = null,
        selfClose = null;

  const ContextMenu.submenu({
    super.key,
    this.position,
    required this.items,
    required this.selfClose,
    required this.parentItemRect,
    this.padding = const EdgeInsets.all(4.0),
    this.maxWidth = _kMaxContextMenuWidth,
    this.isLTR = true,
  }) : isSubmenu = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContextMenuState(
        contextMenu: this,
        position: position,
        isLTR: isLTR,
      ),
      child: Consumer<ContextMenuState>(
        builder: (context, state, _) {
          state.verifyPosition(context, isSubmenu, parentItemRect);
          return Positioned(
            left: state.position.dx,
            top: state.position.dy,
            child: FocusScope(
              autofocus: true,
              node: state.focusScopeNode,
              child: Opacity(
                opacity: state.isPositionVerified ? 1.0 : 0.0,
                child: _view(context),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _generateItems(List<ContextMenuEntry> entries) {
    return entries.map((e) => _MenuEntry(entry: e)).toList();
  }

  Widget _view(BuildContext context) {
    return Container(
      padding: padding,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
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
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Material(
        elevation: 0.0,
        type: MaterialType.transparency,
        child: IntrinsicWidth(
          child: Column(
            children: _generateItems(items),
          ),
        ),
      ),
    );
  }
}

class _MenuEntry<T> extends StatelessWidget {
  final ContextMenuEntry entry;
  const _MenuEntry({required this.entry});

  bool get isContextMenuItem => entry is ContextMenuItem;

  @override
  Widget build(BuildContext context) {
    final menuState = context.read<ContextMenuState>();
    return MouseRegion(
      onEnter: (event) => _onMouseEnter(menuState, context, event),
      onExit: (event) {
        // menuState.focusedEntry = null;
        entry.onMouseExit(event);
      },
      onHover: entry.onMouseHover,
      child: entry.builder(context),
    );
  }

  void _onMouseEnter(
    ContextMenuState menuState,
    BuildContext context,
    PointerEnterEvent event,
  ) {
    if (isContextMenuItem) {
      final item = entry as ContextMenuItem;

      final isSubmenuItem = item.isSubmenuItem;
      // final isSubmenuOpen = menuState.isSubmenuOpen;
      final itemIsNotOpened = item != menuState.openedEntry;

      final canShowSubmenu = isSubmenuItem && itemIsNotOpened;

      if (!isSubmenuItem && menuState.focusedEntry != item) {
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
