import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// Sentinel value for distinguishing between "not provided" and "null" in copyWith.
const _absent = Object();

/// State for [MenuHeaderStyle] properties.
///
/// All fields are nullable. When non-null, they are used to build
/// a [MenuHeaderStyle] instance for theming.
class MenuHeaderStyleState {
  /// Header text color.
  final Color? textColor;

  /// Header padding (converted to EdgeInsets.all).
  final double? padding;

  /// Creates menu header style state.
  const MenuHeaderStyleState({
    this.textColor,
    this.padding,
  });

  /// Creates empty state (all null).
  const MenuHeaderStyleState.empty()
      : textColor = null,
        padding = null;

  /// Whether all fields are null.
  bool get isEmpty => textColor == null && padding == null;

  /// Builds a [MenuHeaderStyle] from this state.
  MenuHeaderStyle toMenuHeaderStyle() {
    return MenuHeaderStyle(
      textColor: textColor,
      padding: padding != null ? EdgeInsets.all(padding!) : null,
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Nullable fields use a sentinel pattern to allow explicitly setting null.
  MenuHeaderStyleState copyWith({
    Object? textColor = _absent,
    Object? padding = _absent,
  }) {
    return MenuHeaderStyleState(
      textColor: textColor == _absent ? this.textColor : textColor as Color?,
      padding: padding == _absent ? this.padding : padding as double?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuHeaderStyleState &&
        other.textColor == textColor &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(textColor, padding);

  @override
  String toString() {
    return 'MenuHeaderStyleState(textColor: $textColor, padding: $padding)';
  }
}
