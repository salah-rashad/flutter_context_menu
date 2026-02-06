import 'package:flutter/material.dart';

import '../core/models/context_menu_theme_data.dart';

/// An inherited widget that defines the theme for context menus in its subtree.
///
/// This widget provides a way to override the context menu theme locally
/// for a specific subtree of the widget tree. The theme data from this widget
/// takes precedence over any [ThemeExtension<ContextMenuThemeData>] registered
/// on [ThemeData.extensions].
///
/// See also:
/// * [ContextMenuThemeData], the data class that describes the theme.
/// * [Theme.of], to access the [ThemeData.extensions] for app-wide theming.
class ContextMenuTheme extends InheritedWidget {
  /// The theme data for context menus in this widget's subtree.
  final ContextMenuThemeData data;

  /// Creates a [ContextMenuTheme] widget.
  ///
  /// The [data] and [child] arguments must not be null.
  const ContextMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns the [ContextMenuThemeData] from the closest [ContextMenuTheme]
  /// ancestor.
  ///
  /// Returns null if no [ContextMenuTheme] ancestor exists.
  ///
  /// Typical usage is as follows:
  /// ```dart
  /// final theme = ContextMenuTheme.of(context);
  /// ```
  static ContextMenuThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContextMenuTheme>()?.data;
  }

  /// Returns the [ContextMenuThemeData] from the closest [ContextMenuTheme]
  /// ancestor.
  ///
  /// Returns null if no [ContextMenuTheme] ancestor exists.
  ///
  /// This method is an alias for [of], provided for consistency with Flutter's
  /// naming conventions (e.g., [Theme.maybeOf], [IconTheme.maybeOf]).
  static ContextMenuThemeData? maybeOf(BuildContext context) {
    return of(context);
  }

  @override
  bool updateShouldNotify(ContextMenuTheme oldWidget) {
    return data != oldWidget.data;
  }
}
