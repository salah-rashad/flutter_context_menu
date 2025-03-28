import 'package:flutter/material.dart';

import '../core/models/context_menu.dart';
import '../core/utils/helpers.dart';

/// A function that builds the context menu widget.
///
/// - [context] - The build context.
/// - [contextMenu] - The context menu to be built.
/// - [pointerPosition] - The position of the pointer (like mouse or touch) on the screen.
/// - [showMenu] - The function to show the context menu.
/// - [child] - The child widget.
typedef ContextMenuRegionBuilder<T> = Widget Function(
  BuildContext context,
  ContextMenu<T> contextMenu,
  Offset pointerPosition,
  void Function() showMenu,
  Widget? child,
);

/// A widget that shows a context menu when the user long presses or right clicks on the widget.
class ContextMenuRegion<T> extends StatelessWidget {
  const ContextMenuRegion({
    super.key,
    required this.contextMenu,
    this.enableGestures = true,
    this.onItemSelected,
    this.builder,
    this.child,
  });

  final ContextMenu<T> contextMenu;

  /// Whether to enable built-in gestures on the widget.
  ///
  /// This is helpful when you want to use a custom gesture recognizer for the widget.
  final bool enableGestures;

  final ValueChanged<T>? onItemSelected;
  final ContextMenuRegionBuilder<T>? builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Offset pointerPosition = Offset.zero;

    final childBuilder = builder?.call(
          context,
          contextMenu,
          pointerPosition,
          () => _showMenu(context, pointerPosition),
          child,
        ) ??
        child;

    if (enableGestures) {
      return GestureDetector(
        onLongPressStart: (details) {
          pointerPosition = details.globalPosition;
          _showMenu(context, pointerPosition);
        },
        onSecondaryTapUp: (details) {
          pointerPosition = details.globalPosition;
          _showMenu(context, pointerPosition);
        },
        child: childBuilder,
      );
    } else {
      return childBuilder ?? const SizedBox.expand();
    }
  }

  void _showMenu(BuildContext context, Offset position) async {
    final menu =
        contextMenu.copyWith(position: contextMenu.position ?? position);
    final value = await showContextMenu(context, contextMenu: menu);
    onItemSelected?.call(value);
  }
}
