import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../constants.dart';
import 'menu_divider_style.dart';
import 'menu_header_style.dart';
import 'menu_item_style.dart';

/// Top-level style for context menus.
///
/// Extends [ThemeExtension] for registration on [ThemeData.extensions].
/// Also used as the data payload for the [ContextMenuTheme] InheritedWidget.
///
/// All fields are nullable. Null values fall through to the next precedence level
/// in the theme resolution chain (inline > ContextMenuTheme widget > ThemeExtension > ColorScheme defaults).
@immutable
class ContextMenuStyle extends ThemeExtension<ContextMenuStyle> {
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

  /// Style for menu items.
  ///
  /// When null, all item properties resolve to their defaults.
  final MenuItemStyle? menuItemStyle;

  /// Style for menu headers.
  ///
  /// When null, all header properties resolve to their defaults.
  final MenuHeaderStyle? menuHeaderStyle;

  /// Style for menu dividers.
  ///
  /// When null, all divider properties resolve to their defaults.
  final MenuDividerStyle? menuDividerStyle;

  /// Creates a [ContextMenuStyle].
  const ContextMenuStyle({
    this.surfaceColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.borderRadius,
    this.padding,
    this.maxWidth,
    this.maxHeight,
    this.menuItemStyle,
    this.menuHeaderStyle,
    this.menuDividerStyle,
  });

  /// Creates a [ContextMenuStyle] with default values from the given [context].
  ///
  /// Uses [ColorScheme.surface] for surface color, [ThemeData.shadowColor] for shadow,
  /// and respects the screen size for max height constraints.
  factory ContextMenuStyle.fallback(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return ContextMenuStyle(
      surfaceColor: theme.colorScheme.surface,
      shadowColor: theme.shadowColor.withValues(alpha: 0.5),
      shadowOffset: const Offset(0.0, 2.0),
      shadowBlurRadius: 10.0,
      shadowSpreadRadius: -1.0,
      borderRadius: BorderRadius.circular(4.0),
      maxWidth: 350.0,
      maxHeight: mediaQuery.size.height - (kContextMenuSafePadding * 2),
      padding: const EdgeInsets.all(4.0),
    );
  }

  /// Creates a copy of this style with the given fields replaced with
  /// the new values.
  @override
  ContextMenuStyle copyWith({
    Color? surfaceColor,
    Color? shadowColor,
    Offset? shadowOffset,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    BorderRadiusGeometry? borderRadius,
    EdgeInsets? padding,
    double? maxWidth,
    double? maxHeight,
    MenuItemStyle? menuItemStyle,
    MenuHeaderStyle? menuHeaderStyle,
    MenuDividerStyle? menuDividerStyle,
  }) {
    return ContextMenuStyle(
      surfaceColor: surfaceColor ?? this.surfaceColor,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      menuItemStyle: menuItemStyle ?? this.menuItemStyle,
      menuHeaderStyle: menuHeaderStyle ?? this.menuHeaderStyle,
      menuDividerStyle: menuDividerStyle ?? this.menuDividerStyle,
    );
  }

  /// Linearly interpolate between two [ContextMenuStyle] objects.
  @override
  ContextMenuStyle lerp(ThemeExtension<ContextMenuStyle>? other, double t) {
    if (other is! ContextMenuStyle) {
      return this;
    }
    return ContextMenuStyle(
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
      menuItemStyle: MenuItemStyle.lerp(menuItemStyle, other.menuItemStyle, t),
      menuHeaderStyle:
          MenuHeaderStyle.lerp(menuHeaderStyle, other.menuHeaderStyle, t),
      menuDividerStyle:
          MenuDividerStyle.lerp(menuDividerStyle, other.menuDividerStyle, t),
    );
  }

  /// Merges this style with [other], with non-null values from [other]
  /// taking precedence over values from this style.
  ContextMenuStyle merge(ContextMenuStyle? other) {
    if (other == null) return this;
    return ContextMenuStyle(
      surfaceColor: other.surfaceColor ?? surfaceColor,
      shadowColor: other.shadowColor ?? shadowColor,
      shadowOffset: other.shadowOffset ?? shadowOffset,
      shadowBlurRadius: other.shadowBlurRadius ?? shadowBlurRadius,
      shadowSpreadRadius: other.shadowSpreadRadius ?? shadowSpreadRadius,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      maxWidth: other.maxWidth ?? maxWidth,
      maxHeight: other.maxHeight ?? maxHeight,
      menuItemStyle:
          menuItemStyle?.merge(other.menuItemStyle) ?? other.menuItemStyle,
      menuHeaderStyle: menuHeaderStyle?.merge(other.menuHeaderStyle) ??
          other.menuHeaderStyle,
      menuDividerStyle: menuDividerStyle?.merge(other.menuDividerStyle) ??
          other.menuDividerStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContextMenuStyle &&
        other.surfaceColor == surfaceColor &&
        other.shadowColor == shadowColor &&
        other.shadowOffset == shadowOffset &&
        other.shadowBlurRadius == shadowBlurRadius &&
        other.shadowSpreadRadius == shadowSpreadRadius &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.maxWidth == maxWidth &&
        other.maxHeight == maxHeight &&
        other.menuItemStyle == menuItemStyle &&
        other.menuHeaderStyle == menuHeaderStyle &&
        other.menuDividerStyle == menuDividerStyle;
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
      menuItemStyle.hashCode ^
      menuHeaderStyle.hashCode ^
      menuDividerStyle.hashCode;
}
