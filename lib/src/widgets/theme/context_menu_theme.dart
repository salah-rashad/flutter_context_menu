import 'package:flutter/material.dart';

import '../../core/models/context_menu_style.dart';

/// An inherited widget that defines the theme for context menus in its subtree.
///
/// This widget provides a way to override the context menu theme locally
/// for a specific subtree of the widget tree. The style from this widget
/// takes precedence over any [ThemeExtension<ContextMenuStyle>] registered
/// on [ThemeData.extensions].
///
/// See also:
/// * [ContextMenuStyle], the data class that describes the style.
/// * [Theme.of], to access the [ThemeData.extensions] for app-wide theming.
class ContextMenuTheme extends InheritedTheme {
  /// The style for context menus in this widget's subtree.
  final ContextMenuStyle style;

  /// Creates a [ContextMenuTheme] widget.
  ///
  /// The [style] and [child] arguments must not be null.
  const ContextMenuTheme({
    super.key,
    required this.style,
    required super.child,
  });

  ContextMenuTheme.fallback(BuildContext context, {super.key})
      : style = ContextMenuStyle.fallback(context),
        super(child: const _NullWidget());

  /// Returns the [ContextMenuStyle] from the closest [ContextMenuTheme]
  /// ancestor.
  ///
  /// Returns null if no [ContextMenuTheme] ancestor exists.
  static ContextMenuStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ContextMenuTheme>()
        ?.style;
  }

  /// Returns the [ContextMenuStyle] from the closest [ContextMenuTheme]
  /// ancestor.
  ///
  /// Returns defaults derived from the Material [ColorScheme] if no
  /// [ContextMenuTheme] ancestor exists.
  ///
  /// Typical usage is as follows:
  /// ```dart
  /// final style = ContextMenuTheme.of(context);
  /// ```
  static ContextMenuStyle of(BuildContext context) {
    return maybeOf(context) ?? ContextMenuTheme.fallback(context).style;
  }

  /// Resolves the effective context menu style for the given [context].
  ///
  /// This method implements the standard style resolution chain:
  /// 1. Start with [ContextMenuStyle.fallback] as the base (ensures all
  ///    properties have non-null default values)
  /// 2. Merge [ThemeExtension<ContextMenuStyle>] from [ThemeData.extensions]
  /// 3. Merge [ContextMenuTheme] InheritedWidget from the widget tree
  ///
  /// Each level takes precedence over the previous, so InheritedWidget values
  /// override ThemeExtension values, which override fallback defaults.
  ///
  /// This is the canonical style resolution logic used by all context menu
  /// components. Use this method instead of duplicating the resolution chain.
  static ContextMenuStyle resolve(BuildContext context) {
    // Always start with fallback to ensure all properties have defaults
    final fallbackStyle = ContextMenuStyle.fallback(context);
    final inheritedStyle = maybeOf(context);
    final extensionStyle = Theme.of(context).extension<ContextMenuStyle>();

    // Build up the style in precedence order (lowest to highest):
    // fallback -> extensionStyle -> inheritedStyle
    var result = fallbackStyle;
    if (extensionStyle != null) {
      result = result.merge(extensionStyle);
    }
    if (inheritedStyle != null) {
      result = result.merge(inheritedStyle);
    }
    return result;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ContextMenuTheme(style: style, child: child);
  }

  @override
  bool updateShouldNotify(ContextMenuTheme oldWidget) {
    return style != oldWidget.style;
  }
}

class _NullWidget extends StatelessWidget {
  const _NullWidget();

  @override
  Widget build(BuildContext context) {
    throw FlutterError(
      'A ContextMenuTheme constructed with ContextMenuTheme.fallback cannot be incorporated into the widget tree, '
      'it is meant only to provide a fallback value returned by ContextMenuTheme.of() '
      'when no enclosing default text style is present in a BuildContext.',
    );
  }
}
