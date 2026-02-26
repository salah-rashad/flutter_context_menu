import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// State for [MenuItemStyle] properties.
///
/// All fields are nullable. When non-null, they are used to build
/// a [MenuItemStyle] instance for theming.
class MenuItemStyleState {
  /// Normal background color.
  final Color? backgroundColor;

  /// Hovered/focused background color.
  final Color? focusedBackgroundColor;

  /// Normal text color.
  final Color? textColor;

  /// Focused text color.
  final Color? focusedTextColor;

  /// Disabled text color.
  final Color? disabledTextColor;

  /// Icon color.
  final Color? iconColor;

  /// Icon size.
  final double? iconSize;

  /// Shortcut text color.
  final Color? shortcutTextColor;

  /// Shortcut text opacity.
  final double? shortcutTextOpacity;

  /// Item height.
  final double? height;

  /// Item corner radius.
  final double? borderRadius;

  /// Creates menu item style state.
  const MenuItemStyleState({
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

  /// Creates empty state (all null).
  const MenuItemStyleState.empty()
      : backgroundColor = null,
        focusedBackgroundColor = null,
        textColor = null,
        focusedTextColor = null,
        disabledTextColor = null,
        iconColor = null,
        iconSize = null,
        shortcutTextColor = null,
        shortcutTextOpacity = null,
        height = null,
        borderRadius = null;

  /// Whether all fields are null.
  bool get isEmpty =>
      backgroundColor == null &&
      focusedBackgroundColor == null &&
      textColor == null &&
      focusedTextColor == null &&
      disabledTextColor == null &&
      iconColor == null &&
      iconSize == null &&
      shortcutTextColor == null &&
      shortcutTextOpacity == null &&
      height == null &&
      borderRadius == null;

  /// Builds a [MenuItemStyle] from this state.
  MenuItemStyle toMenuItemStyle() {
    return MenuItemStyle(
      backgroundColor: backgroundColor,
      focusedBackgroundColor: focusedBackgroundColor,
      textColor: textColor,
      focusedTextColor: focusedTextColor,
      disabledTextColor: disabledTextColor,
      iconColor: iconColor,
      iconSize: iconSize,
      shortcutTextColor: shortcutTextColor,
      shortcutTextOpacity: shortcutTextOpacity,
      height: height,
      borderRadius:
          borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  MenuItemStyleState copyWith({
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
    double? borderRadius,
  }) {
    return MenuItemStyleState(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuItemStyleState &&
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
  int get hashCode => Object.hashAll([
        backgroundColor,
        focusedBackgroundColor,
        textColor,
        focusedTextColor,
        disabledTextColor,
        iconColor,
        iconSize,
        shortcutTextColor,
        shortcutTextOpacity,
        height,
        borderRadius,
      ]);

  @override
  String toString() {
    return 'MenuItemStyleState(backgroundColor: $backgroundColor, '
        'focusedBackgroundColor: $focusedBackgroundColor, '
        'textColor: $textColor, focusedTextColor: $focusedTextColor, '
        'disabledTextColor: $disabledTextColor, iconColor: $iconColor, '
        'iconSize: $iconSize, shortcutTextColor: $shortcutTextColor, '
        'shortcutTextOpacity: $shortcutTextOpacity, height: $height, '
        'borderRadius: $borderRadius)';
  }
}
