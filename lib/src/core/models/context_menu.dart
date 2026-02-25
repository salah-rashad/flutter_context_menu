import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/helpers.dart';
import 'context_menu_entry.dart';

/// Represents a context menu data model.
class ContextMenu<T> {
  /// The position of the context menu.
  Offset? position;

  /// The entries of the context menu.
  List<ContextMenuEntry<T>> entries;

  /// The padding around the entries   of the context menu.
  ///
  /// Defaults to [EdgeInsets.all(4.0)]
  EdgeInsets padding;

  /// The border radius around the context menu.
  BorderRadiusGeometry? borderRadius;

  /// The maximum width of the context menu.
  ///
  /// Defaults to 350.0
  double maxWidth;

  /// The maximum height of the context menu.
  double? maxHeight;

  /// The clip behavior of the context menu.
  ///
  /// Defaults to [Clip.antiAlias]
  Clip clipBehavior;

  /// The decoration of the context menu.
  BoxDecoration? boxDecoration;

  /// The text direction used when laying out the context menu and its submenus.
  ///
  /// If this is `null`, the text direction is automatically inherited from the
  /// nearest [Directionality] widget in the widget tree (for example, from
  /// [MaterialApp] or [WidgetsApp]).
  ///
  /// This property controls the overall layout direction (LTR or RTL) of the
  /// menu and its submenus, which is important for right-to-left language
  /// support.
  TextDirection? textDirection;

  /// A map of shortcuts to be bound to the context menu and the nested context menus.
  ///
  /// Note: This overides the default shortcuts in [defaultMenuShortcuts] if any of the keys match.
  Map<ShortcutActivator, VoidCallback> shortcuts;

  ContextMenu({
    required this.entries,
    this.position,
    EdgeInsets? padding,
    this.borderRadius,
    double? maxWidth,
    this.maxHeight,
    Clip? clipBehavior,
    this.boxDecoration,
    this.textDirection,
    Map<ShortcutActivator, VoidCallback>? shortcuts,
  })  : padding = padding ?? const EdgeInsets.all(4.0),
        maxWidth = maxWidth ?? 350.0,
        clipBehavior = clipBehavior ?? Clip.antiAlias,
        shortcuts = shortcuts ?? const {};

  /// A shortcut method to show the context menu.
  ///
  /// For a more customized context menu, use [showContextMenu]
  Future<T?> show(BuildContext context) {
    return showContextMenu<T>(context, contextMenu: this);
  }

  ContextMenu<T> copyWith({
    Offset? position,
    List<ContextMenuEntry<T>>? entries,
    EdgeInsets? padding,
    BorderRadiusGeometry? borderRadius,
    double? maxWidth,
    double? maxHeight,
    Clip? clipBehavior,
    BoxDecoration? boxDecoration,
    TextDirection? textDirection,
  }) {
    return ContextMenu<T>(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      boxDecoration: boxDecoration ?? this.boxDecoration,
      textDirection: textDirection ?? this.textDirection,
    );
  }
}
