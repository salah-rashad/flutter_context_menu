import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// Sentinel value for distinguishing between "not provided" and "null" in copyWith.
const _absent = Object();

/// State for [MenuDividerStyle] properties.
///
/// All fields are nullable. When non-null, they are used to build
/// a [MenuDividerStyle] instance for theming.
class MenuDividerStyleState {
  /// Divider color.
  final Color? color;

  /// Divider height.
  final double? height;

  /// Line thickness.
  final double? thickness;

  /// Left indent.
  final double? indent;

  /// Right indent.
  final double? endIndent;

  /// Creates menu divider style state.
  const MenuDividerStyleState({
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  /// Creates empty state (all null).
  const MenuDividerStyleState.empty()
      : color = null,
        height = null,
        thickness = null,
        indent = null,
        endIndent = null;

  /// Whether all fields are null.
  bool get isEmpty =>
      color == null &&
      height == null &&
      thickness == null &&
      indent == null &&
      endIndent == null;

  /// Builds a [MenuDividerStyle] from this state.
  MenuDividerStyle toMenuDividerStyle() {
    return MenuDividerStyle(
      color: color,
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Nullable fields use a sentinel pattern to allow explicitly setting null.
  MenuDividerStyleState copyWith({
    Object? color = _absent,
    Object? height = _absent,
    Object? thickness = _absent,
    Object? indent = _absent,
    Object? endIndent = _absent,
  }) {
    return MenuDividerStyleState(
      color: color == _absent ? this.color : color as Color?,
      height: height == _absent ? this.height : height as double?,
      thickness: thickness == _absent ? this.thickness : thickness as double?,
      indent: indent == _absent ? this.indent : indent as double?,
      endIndent: endIndent == _absent ? this.endIndent : endIndent as double?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuDividerStyleState &&
        other.color == color &&
        other.height == height &&
        other.thickness == thickness &&
        other.indent == indent &&
        other.endIndent == endIndent;
  }

  @override
  int get hashCode => Object.hashAll([
        color,
        height,
        thickness,
        indent,
        endIndent,
      ]);

  @override
  String toString() {
    return 'MenuDividerStyleState(color: $color, height: $height, '
        'thickness: $thickness, indent: $indent, endIndent: $endIndent)';
  }
}
