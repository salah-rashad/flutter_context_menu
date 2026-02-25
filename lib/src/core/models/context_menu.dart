import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/helpers.dart';
import 'context_menu_entry.dart';
import 'context_menu_style.dart';

/// Represents a context menu data model.
class ContextMenu<T> {
  /// The position of the context menu.
  final Offset? position;

  /// The entries of the context menu.
  final List<ContextMenuEntry<T>> entries;

  /// The clip behavior of the context menu.
  ///
  /// Defaults to [Clip.antiAlias]
  final Clip? clipBehavior;

  /// Whether to respect the padding of the context menu when opening submenus.
  ///
  /// If true, the context menu will not overlap the padding of the parent context menu.
  ///
  /// Defaults to true
  final bool respectPadding;

  /// A map of shortcuts to be bound to the context menu and the nested context menus.
  ///
  /// Note: This overides the default shortcuts in [defaultMenuShortcuts] if any of the keys match.
  final Map<ShortcutActivator, VoidCallback> shortcuts;

  /// The style of the context menu.
  ///
  /// When provided, this style is merged on top of the resolved style
  /// (from ContextMenuTheme widget or ThemeExtension), allowing per-instance
  /// customization of menu appearance.
  final ContextMenuStyle? style;

  const ContextMenu(
      {required this.entries,
      this.position,
      this.clipBehavior,
      this.shortcuts = const {},
      this.style,
      this.respectPadding = true});

  /// A shortcut method to show the context menu.
  ///
  /// For a more customized context menu, use [showContextMenu]
  Future<T?> show(BuildContext context) {
    return showContextMenu<T>(context, contextMenu: this);
  }

  ContextMenu<T> copyWith({
    Offset? position,
    List<ContextMenuEntry<T>>? entries,
    Clip? clipBehavior,
    Map<ShortcutActivator, VoidCallback>? shortcuts,
    ContextMenuStyle? style,
  }) {
    return ContextMenu<T>(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      shortcuts: shortcuts ?? this.shortcuts,
      style: style ?? this.style,
    );
  }
}
