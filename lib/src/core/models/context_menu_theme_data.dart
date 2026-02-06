import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'menu_divider_theme_data.dart';
import 'menu_header_theme_data.dart';
import 'menu_item_theme_data.dart';

/// Top-level theme data for context menus.
///
/// Extends [ThemeExtension] for registration on [ThemeData.extensions].
/// Also used as the data payload for the [ContextMenuTheme] InheritedWidget.
///
/// All fields are nullable. Null values fall through to the next precedence level
/// in the theme resolution chain (inline > ContextMenuTheme widget > ThemeExtension > ColorScheme defaults).
@immutable
class ContextMenuThemeData extends ThemeExtension<ContextMenuThemeData> {
  /// Surface color of the menu container.
  ///
  /// When null, resolves to [ColorScheme.surface].
  final Color? surfaceColor;

  /// Shadow color of the menu container.
  ///
  /// When null, resolves to [Theme.shadowColor] with 50% opacity.
  final Color? shadowColor;

  /// Shadow offset of the menu container.
  ///
  /// When null, resolves to [Offset(0.0, 2.0)].
  final Offset? shadowOffset;

  /// Shadow blur radius of the menu container.
  ///
  /// When null, resolves to 10.0.
  final double? shadowBlurRadius;

  /// Shadow spread radius of the menu container.
  ///
  /// When null, resolves to -1.0.
  final double? shadowSpreadRadius;

  /// Border radius of the menu container.
  ///
  /// When null, resolves to [BorderRadius.circular(4.0)].
  final BorderRadiusGeometry? borderRadius;

  /// Padding inside the menu container.
  ///
  /// When null, resolves to [EdgeInsets.all(4.0)].
  final EdgeInsets? padding;

  /// Maximum width of the menu container.
  ///
  /// When null, resolves to 350.0.
  final double? maxWidth;

  /// Maximum height of the menu container.
  ///
  /// When null, the menu height is unconstrained.
  final double? maxHeight;

  /// Theme data for menu items.
  ///
  /// When null, all item properties resolve to their defaults.
  final MenuItemThemeData? menuItemTheme;

  /// Theme data for menu headers.
  ///
  /// When null, all header properties resolve to their defaults.
  final MenuHeaderThemeData? menuHeaderTheme;

  /// Theme data for menu dividers.
  ///
  /// When null, all divider properties resolve to their defaults.
  final MenuDividerThemeData? menuDividerTheme;

  /// Creates a [ContextMenuThemeData].
  const ContextMenuThemeData({
    this.surfaceColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.borderRadius,
    this.padding,
    this.maxWidth,
    this.maxHeight,
    this.menuItemTheme,
    this.menuHeaderTheme,
    this.menuDividerTheme,
  });

  /// Creates a copy of this theme data with the given fields replaced with
  /// the new values.
  @override
  ContextMenuThemeData copyWith({
    Color? surfaceColor,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    BorderRadiusGeometry? borderRadius,
    EdgeInsets? padding,
    double? maxWidth,
    double? maxHeight,
    MenuItemThemeData? menuItemTheme,
    MenuHeaderThemeData? menuHeaderTheme,
    MenuDividerThemeData? menuDividerTheme,
  }) {
    return ContextMenuThemeData(
      surfaceColor: surfaceColor ?? this.surfaceColor,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      menuItemTheme: menuItemTheme ?? this.menuItemTheme,
      menuHeaderTheme: menuHeaderTheme ?? this.menuHeaderTheme,
      menuDividerTheme: menuDividerTheme ?? this.menuDividerTheme,
    );
  }

  /// Linearly interpolate between two [ContextMenuThemeData] objects.
  @override
  ContextMenuThemeData lerp(
      ThemeExtension<ContextMenuThemeData>? other, double t) {
    if (other is! ContextMenuThemeData) {
      return this;
    }
    return ContextMenuThemeData(
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      shadowOffset: Offset.lerp(shadowOffset, other.shadowOffset, t),
      shadowBlurRadius: lerpDouble(shadowBlurRadius, other.shadowBlurRadius, t),
      shadowSpreadRadius:
          lerpDouble(shadowSpreadRadius, other.shadowSpreadRadius, t),
      borderRadius:
          BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t),
      maxHeight: lerpDouble(maxHeight, other.maxHeight, t),
      menuItemTheme:
          MenuItemThemeData.lerp(menuItemTheme, other.menuItemTheme, t),
      menuHeaderTheme:
          MenuHeaderThemeData.lerp(menuHeaderTheme, other.menuHeaderTheme, t),
      menuDividerTheme: MenuDividerThemeData.lerp(
          menuDividerTheme, other.menuDividerTheme, t),
    );
  }

  /// Merges this theme data with [other], with non-null values from [other]
  /// taking precedence over values from this theme data.
  ContextMenuThemeData merge(ContextMenuThemeData? other) {
    if (other == null) return this;
    return ContextMenuThemeData(
      surfaceColor: other.surfaceColor ?? surfaceColor,
      shadowColor: other.shadowColor ?? shadowColor,
      shadowOffset: other.shadowOffset ?? shadowOffset,
      shadowBlurRadius: other.shadowBlurRadius ?? shadowBlurRadius,
      shadowSpreadRadius: other.shadowSpreadRadius ?? shadowSpreadRadius,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      maxWidth: other.maxWidth ?? maxWidth,
      maxHeight: other.maxHeight ?? maxHeight,
      menuItemTheme:
          menuItemTheme?.merge(other.menuItemTheme) ?? other.menuItemTheme,
      menuHeaderTheme: menuHeaderTheme?.merge(other.menuHeaderTheme) ??
          other.menuHeaderTheme,
      menuDividerTheme: menuDividerTheme?.merge(other.menuDividerTheme) ??
          other.menuDividerTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContextMenuThemeData &&
        other.surfaceColor == surfaceColor &&
        other.shadowColor == shadowColor &&
        other.shadowOffset == shadowOffset &&
        other.shadowBlurRadius == shadowBlurRadius &&
        other.shadowSpreadRadius == shadowSpreadRadius &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.maxWidth == maxWidth &&
        other.maxHeight == maxHeight &&
        other.menuItemTheme == menuItemTheme &&
        other.menuHeaderTheme == menuHeaderTheme &&
        other.menuDividerTheme == menuDividerTheme;
  }

  @override
  int get hashCode =>
      surfaceColor.hashCode ^
      shadowColor.hashCode ^
      shadowOffset.hashCode ^
      shadowBlurRadius.hashCode ^
      shadowSpreadRadius.hashCode ^
      borderRadius.hashCode ^
      padding.hashCode ^
      maxWidth.hashCode ^
      maxHeight.hashCode ^
      menuItemTheme.hashCode ^
      menuHeaderTheme.hashCode ^
      menuDividerTheme.hashCode;
}
