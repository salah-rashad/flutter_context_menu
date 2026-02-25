import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Style for selectable menu items.
///
/// All fields are nullable. Null values fall through to the next precedence level
/// in the theme resolution chain (ContextMenuTheme widget > ThemeExtension > ColorScheme defaults).
@immutable
class MenuItemStyle {
  /// Background color for normal (unfocused) menu items.
  ///
  /// When null, resolves to [ColorScheme.surface].
  final Color? backgroundColor;

  /// Background color for focused/hovered menu items.
  ///
  /// When null, resolves to [ColorScheme.surfaceContainer].
  final Color? focusedBackgroundColor;

  /// Text color for normal (unfocused) menu items.
  ///
  /// When null, resolves to [ColorScheme.onSurface] with 70% opacity blended with background.
  final Color? textColor;

  /// Text color for focused/hovered menu items.
  ///
  /// When null, resolves to [ColorScheme.onSurface].
  final Color? focusedTextColor;

  /// Text color for disabled menu items.
  ///
  /// When null, resolves to [ColorScheme.onSurface] with 20% opacity.
  final Color? disabledTextColor;

  /// Icon color for menu items.
  ///
  /// When null, resolves to the same value as [textColor].
  final Color? iconColor;

  /// Icon size for menu items.
  ///
  /// When null, resolves to 16.0.
  final double? iconSize;

  /// Color for shortcut hint text.
  ///
  /// When null, resolves to [textColor] with [shortcutTextOpacity] applied.
  final Color? shortcutTextColor;

  /// Opacity for shortcut text.
  ///
  /// When null, resolves to 0.6.
  final double? shortcutTextOpacity;

  /// Height of menu items.
  ///
  /// When null, resolves to 32.0.
  final double? height;

  /// Border radius for menu items.
  ///
  /// When null, resolves to [BorderRadius.circular(4.0)].
  final BorderRadiusGeometry? borderRadius;

  /// Creates a [MenuItemStyle].
  const MenuItemStyle({
    this.backgroundColor,
    this.focusedBackgroundColor,
    this.textColor,
    this.focusedTextColor,
    this.disabledTextColor,
    this.iconColor,
    this.iconSize,
    this.shortcutTextColor,
    this.shortcutTextOpacity,
    this.height,
    this.borderRadius,
  });

  /// Creates a copy of this style with the given fields replaced with
  /// the new values.
  MenuItemStyle copyWith({
    Color? backgroundColor,
    Color? focusedBackgroundColor,
    Color? textColor,
    Color? focusedTextColor,
    Color? disabledTextColor,
    Color? iconColor,
    double? iconSize,
    Color? shortcutTextColor,
    double? shortcutTextOpacity,
    double? height,
    BorderRadiusGeometry? borderRadius,
  }) {
    return MenuItemStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      focusedBackgroundColor:
          focusedBackgroundColor ?? this.focusedBackgroundColor,
      textColor: textColor ?? this.textColor,
      focusedTextColor: focusedTextColor ?? this.focusedTextColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      shortcutTextColor: shortcutTextColor ?? this.shortcutTextColor,
      shortcutTextOpacity: shortcutTextOpacity ?? this.shortcutTextOpacity,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  /// Linearly interpolate between two [MenuItemStyle] objects.
  static MenuItemStyle lerp(
    MenuItemStyle? a,
    MenuItemStyle? b,
    double t,
  ) {
    return MenuItemStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      focusedBackgroundColor:
          Color.lerp(a?.focusedBackgroundColor, b?.focusedBackgroundColor, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      focusedTextColor: Color.lerp(a?.focusedTextColor, b?.focusedTextColor, t),
      disabledTextColor:
          Color.lerp(a?.disabledTextColor, b?.disabledTextColor, t),
      iconColor: Color.lerp(a?.iconColor, b?.iconColor, t),
      iconSize: lerpDouble(a?.iconSize, b?.iconSize, t),
      shortcutTextColor:
          Color.lerp(a?.shortcutTextColor, b?.shortcutTextColor, t),
      shortcutTextOpacity:
          lerpDouble(a?.shortcutTextOpacity, b?.shortcutTextOpacity, t),
      height: lerpDouble(a?.height, b?.height, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a?.borderRadius, b?.borderRadius, t),
    );
  }

  /// Merges this style with [other], with non-null values from [other]
  /// taking precedence over values from this style.
  MenuItemStyle merge(MenuItemStyle? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      focusedBackgroundColor: other.focusedBackgroundColor,
      textColor: other.textColor,
      focusedTextColor: other.focusedTextColor,
      disabledTextColor: other.disabledTextColor,
      iconColor: other.iconColor,
      iconSize: other.iconSize,
      shortcutTextColor: other.shortcutTextColor,
      shortcutTextOpacity: other.shortcutTextOpacity,
      height: other.height,
      borderRadius: other.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItemStyle &&
        other.backgroundColor == backgroundColor &&
        other.focusedBackgroundColor == focusedBackgroundColor &&
        other.textColor == textColor &&
        other.focusedTextColor == focusedTextColor &&
        other.disabledTextColor == disabledTextColor &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.shortcutTextColor == shortcutTextColor &&
        other.shortcutTextOpacity == shortcutTextOpacity &&
        other.height == height &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      focusedBackgroundColor.hashCode ^
      textColor.hashCode ^
      focusedTextColor.hashCode ^
      disabledTextColor.hashCode ^
      iconColor.hashCode ^
      iconSize.hashCode ^
      shortcutTextColor.hashCode ^
      shortcutTextOpacity.hashCode ^
      height.hashCode ^
      borderRadius.hashCode;
}
