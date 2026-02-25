import 'package:flutter/material.dart';

/// Style for non-interactive header entries.
///
/// All fields are nullable. Null values fall through to the next precedence level
/// in the theme resolution chain (ContextMenuTheme widget > ThemeExtension > defaults).
@immutable
class MenuHeaderStyle {
  /// Text style for header text.
  ///
  /// When null, resolves to [Theme.textTheme.labelMedium].
  final TextStyle? textStyle;

  /// Text color for header text.
  ///
  /// When null, resolves to [Theme.disabledColor] with 30% opacity.
  final Color? textColor;

  /// Padding around the header content.
  ///
  /// When null, resolves to [EdgeInsets.all(8.0)].
  final EdgeInsets? padding;

  /// Creates a [MenuHeaderStyle].
  const MenuHeaderStyle({
    this.textStyle,
    this.textColor,
    this.padding,
  });

  /// Creates a copy of this style with the given fields replaced with
  /// the new values.
  MenuHeaderStyle copyWith({
    TextStyle? textStyle,
    Color? textColor,
    EdgeInsets? padding,
  }) {
    return MenuHeaderStyle(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      padding: padding ?? this.padding,
    );
  }

  /// Linearly interpolate between two [MenuHeaderStyle] objects.
  static MenuHeaderStyle lerp(
    MenuHeaderStyle? a,
    MenuHeaderStyle? b,
    double t,
  ) {
    return MenuHeaderStyle(
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      padding: EdgeInsets.lerp(a?.padding, b?.padding, t),
    );
  }

  /// Merges this style with [other], with non-null values from [other]
  /// taking precedence over values from this style.
  MenuHeaderStyle merge(MenuHeaderStyle? other) {
    if (other == null) return this;
    return copyWith(
      textStyle: other.textStyle,
      textColor: other.textColor,
      padding: other.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuHeaderStyle &&
        other.textStyle == textStyle &&
        other.textColor == textColor &&
        other.padding == padding;
  }

  @override
  int get hashCode =>
      textStyle.hashCode ^ textColor.hashCode ^ padding.hashCode;
}
