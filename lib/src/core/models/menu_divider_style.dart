import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Style for separator entries.
///
/// All fields are nullable. Null values fall through to the next precedence level
/// in the theme resolution chain (ContextMenuTheme widget > ThemeExtension > defaults).
@immutable
class MenuDividerStyle {
  /// Color of the divider.
  ///
  /// When null, resolves to Flutter's default [Divider] color.
  final Color? color;

  /// Height of the divider.
  ///
  /// When null, resolves to 8.0.
  final double? height;

  /// Thickness of the divider line.
  ///
  /// When null, resolves to 0.0.
  final double? thickness;

  /// Amount of empty space before the divider.
  ///
  /// When null, resolves to null (no indent).
  final double? indent;

  /// Amount of empty space after the divider.
  ///
  /// When null, resolves to null (no end indent).
  final double? endIndent;

  /// Creates a [MenuDividerStyle].
  const MenuDividerStyle({
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  /// Creates a copy of this style with the given fields replaced with
  /// the new values.
  MenuDividerStyle copyWith({
    Color? color,
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
  }) {
    return MenuDividerStyle(
      color: color ?? this.color,
      height: height ?? this.height,
      thickness: thickness ?? this.thickness,
      indent: indent ?? this.indent,
      endIndent: endIndent ?? this.endIndent,
    );
  }

  /// Linearly interpolate between two [MenuDividerStyle] objects.
  static MenuDividerStyle lerp(
    MenuDividerStyle? a,
    MenuDividerStyle? b,
    double t,
  ) {
    return MenuDividerStyle(
      color: Color.lerp(a?.color, b?.color, t),
      height: lerpDouble(a?.height, b?.height, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      indent: lerpDouble(a?.indent, b?.indent, t),
      endIndent: lerpDouble(a?.endIndent, b?.endIndent, t),
    );
  }

  /// Merges this style with [other], with non-null values from [other]
  /// taking precedence over values from this style.
  MenuDividerStyle merge(MenuDividerStyle? other) {
    if (other == null) return this;
    return copyWith(
      color: other.color,
      height: other.height,
      thickness: other.thickness,
      indent: other.indent,
      endIndent: other.endIndent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuDividerStyle &&
        other.color == color &&
        other.height == height &&
        other.thickness == thickness &&
        other.indent == indent &&
        other.endIndent == endIndent;
  }

  @override
  int get hashCode =>
      color.hashCode ^
      height.hashCode ^
      thickness.hashCode ^
      indent.hashCode ^
      endIndent.hashCode;
}
