import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Theme data for separator entries.
///
/// All fields are nullable. Null values fall through to the next precedence level
/// in the theme resolution chain (ContextMenuTheme widget > ThemeExtension > defaults).
@immutable
class MenuDividerThemeData {
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

  /// Creates a [MenuDividerThemeData].
  const MenuDividerThemeData({
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  /// Creates a copy of this theme data with the given fields replaced with
  /// the new values.
  MenuDividerThemeData copyWith({
    Color? color,
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
  }) {
    return MenuDividerThemeData(
      color: color ?? this.color,
      height: height ?? this.height,
      thickness: thickness ?? this.thickness,
      indent: indent ?? this.indent,
      endIndent: endIndent ?? this.endIndent,
    );
  }

  /// Linearly interpolate between two [MenuDividerThemeData] objects.
  static MenuDividerThemeData lerp(
    MenuDividerThemeData? a,
    MenuDividerThemeData? b,
    double t,
  ) {
    return MenuDividerThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      height: lerpDouble(a?.height, b?.height, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      indent: lerpDouble(a?.indent, b?.indent, t),
      endIndent: lerpDouble(a?.endIndent, b?.endIndent, t),
    );
  }

  /// Merges this theme data with [other], with non-null values from [other]
  /// taking precedence over values from this theme data.
  MenuDividerThemeData merge(MenuDividerThemeData? other) {
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
    return other is MenuDividerThemeData &&
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
