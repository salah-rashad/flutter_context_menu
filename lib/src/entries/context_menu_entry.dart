import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class ContextMenuEntry {
  const ContextMenuEntry();

  /// Builds the widget representation of the context menu entry.
  Widget builder(BuildContext context);

  /// Called when the mouse pointer enters the area of the context menu entry.
  void onMouseEnter(PointerEnterEvent event) {}

  /// Called when the mouse pointer exits the area of the context menu entry.
  void onMouseExit(PointerExitEvent event) {}

  /// Called when the mouse pointer hovers over the context menu entry.
  void onMouseHover(PointerHoverEvent event) {}
}
