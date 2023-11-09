import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core/utils/helpers.dart';
import '../core/models/context_menu_entry.dart';

/// Represents a context menu data model.
class ContextMenu {
  /// The position of the context menu.
  Offset? position;

  /// The entries of the context menu.
  List<ContextMenuEntry> entries;

  /// The padding of the context menu.
  ///
  /// Defaults to [EdgeInsets.all(4.0)]
  EdgeInsets padding;

  /// The border radius around the context menu.
  BorderRadiusGeometry? borderRadius;

  /// The maximum width of the context menu.
  ///
  /// Defaults to 350.0
  double maxWidth;

  /// The clip behavior of the context menu.
  ///
  /// Defaults to [Clip.antiAlias]
  Clip clipBehavior;

  /// The decoration of the context menu.
  BoxDecoration? boxDecoration;

  ContextMenu({
    required this.entries,
    this.position,
    this.padding = const EdgeInsets.all(4.0),
    this.borderRadius,
    this.maxWidth = 350.0,
    this.clipBehavior = Clip.antiAlias,
    this.boxDecoration,
  });

  /// A shortcut method to show the context menu.
  ///
  /// For a more customized context menu, use [showContextMenu]
  Future<T?> show<T>(BuildContext context) {
    return showContextMenu(context, contextMenu: this);
  }

  ContextMenu copyWith({
    Offset? position,
    List<ContextMenuEntry>? entries,
    EdgeInsets? padding,
    BorderRadiusGeometry? borderRadius,
    double? maxWidth,
    Clip? clipBehavior,
    BoxDecoration? boxDecoration,
  }) {
    return ContextMenu(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      maxWidth: maxWidth ?? this.maxWidth,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      boxDecoration: boxDecoration ?? this.boxDecoration,
    );
  }
}
