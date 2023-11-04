import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class ContextMenuRegion extends StatefulWidget {
  final Widget child;
  final Color color;
  final ContextMenu contextMenu;

  const ContextMenuRegion({
    super.key,
    required this.child,
    required this.color,
    required this.contextMenu,
  });

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> {
  Offset mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        mousePosition = event.position;
      },
      child: GestureDetector(
        onLongPress: () => _showMenu(context),
        onSecondaryTap: () => _showMenu(context),
        child: Container(
          color: widget.color,
          child: widget.child,
        ),
      ),
    );
  }

  _showMenu(BuildContext context) {
    final menu = widget.contextMenu.copyWith(
      position: widget.contextMenu.position ?? mousePosition,
    );
    showContextMenu(context, contextMenu: menu).then((value) {
      if (value != null) _showPressedSnackbar(context, value.toString());
    });
  }

  void _showPressedSnackbar(BuildContext context, String name) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('"$name" pressed')));
  }
}
