import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import 'menu_divider_style_state.dart';
import 'menu_header_style_state.dart';
import 'menu_item_style_state.dart';

/// Sentinel value for distinguishing between "not provided" and "null" in copyWith.
const _absent = Object();

/// State for [ContextMenuStyle] properties.
///
/// All fields are nullable. When non-null, they are passed to
/// [ContextMenuStyle] on the [ContextMenu] instance.
///
/// Contains nested sub-style states for items, headers, and dividers.
class InlineStyleState {
  /// Menu background color.
  final Color? surfaceColor;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final Offset? shadowOffset;

  /// Shadow blur radius.
  final double? shadowBlurRadius;

  /// Shadow spread radius.
  final double? shadowSpreadRadius;

  /// Corner radius (converted to BorderRadius.circular).
  final double? borderRadius;

  /// Inner padding (converted to EdgeInsets.all).
  final double? padding;

  /// Maximum menu width.
  final double? maxWidth;

  /// Maximum menu height.
  final double? maxHeight;

  /// Nested item style overrides.
  final MenuItemStyleState? menuItemStyle;

  /// Nested header style overrides.
  final MenuHeaderStyleState? menuHeaderStyle;

  /// Nested divider style overrides.
  final MenuDividerStyleState? menuDividerStyle;

  /// Creates inline style state.
  const InlineStyleState({
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

  /// Creates empty state (all null).
  const InlineStyleState.empty()
      : surfaceColor = null,
        shadowColor = null,
        shadowOffset = null,
        shadowBlurRadius = null,
        shadowSpreadRadius = null,
        borderRadius = null,
        padding = null,
        maxWidth = null,
        maxHeight = null,
        menuItemStyle = null,
        menuHeaderStyle = null,
        menuDividerStyle = null;

  /// Whether all fields are null (including nested states).
  bool get isEmpty =>
      surfaceColor == null &&
      shadowColor == null &&
      shadowOffset == null &&
      shadowBlurRadius == null &&
      shadowSpreadRadius == null &&
      borderRadius == null &&
      padding == null &&
      maxWidth == null &&
      maxHeight == null &&
      (menuItemStyle == null || menuItemStyle!.isEmpty) &&
      (menuHeaderStyle == null || menuHeaderStyle!.isEmpty) &&
      (menuDividerStyle == null || menuDividerStyle!.isEmpty);

  /// Builds a [ContextMenuStyle] from this state.
  ///
  /// Returns null if all fields are empty.
  ContextMenuStyle? toContextMenuStyle() {
    if (isEmpty) return null;

    return ContextMenuStyle(
      surfaceColor: surfaceColor,
      shadowColor: shadowColor,
      shadowOffset: shadowOffset,
      shadowBlurRadius: shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius,
      borderRadius:
          borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
      padding: padding != null ? EdgeInsets.all(padding!) : null,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      menuItemStyle: menuItemStyle?.toMenuItemStyle(),
      menuHeaderStyle: menuHeaderStyle?.toMenuHeaderStyle(),
      menuDividerStyle: menuDividerStyle?.toMenuDividerStyle(),
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Nullable fields use a sentinel pattern to allow explicitly setting null.
  InlineStyleState copyWith({
    Object? surfaceColor = _absent,
    Object? shadowColor = _absent,
    Object? shadowOffset = _absent,
    Object? shadowBlurRadius = _absent,
    Object? shadowSpreadRadius = _absent,
    Object? borderRadius = _absent,
    Object? padding = _absent,
    Object? maxWidth = _absent,
    Object? maxHeight = _absent,
    Object? menuItemStyle = _absent,
    Object? menuHeaderStyle = _absent,
    Object? menuDividerStyle = _absent,
  }) {
    return InlineStyleState(
      surfaceColor:
          surfaceColor == _absent ? this.surfaceColor : surfaceColor as Color?,
      shadowColor:
          shadowColor == _absent ? this.shadowColor : shadowColor as Color?,
      shadowOffset:
          shadowOffset == _absent ? this.shadowOffset : shadowOffset as Offset?,
      shadowBlurRadius: shadowBlurRadius == _absent
          ? this.shadowBlurRadius
          : shadowBlurRadius as double?,
      shadowSpreadRadius: shadowSpreadRadius == _absent
          ? this.shadowSpreadRadius
          : shadowSpreadRadius as double?,
      borderRadius:
          borderRadius == _absent ? this.borderRadius : borderRadius as double?,
      padding: padding == _absent ? this.padding : padding as double?,
      maxWidth: maxWidth == _absent ? this.maxWidth : maxWidth as double?,
      maxHeight: maxHeight == _absent ? this.maxHeight : maxHeight as double?,
      menuItemStyle: menuItemStyle == _absent
          ? this.menuItemStyle
          : menuItemStyle as MenuItemStyleState?,
      menuHeaderStyle: menuHeaderStyle == _absent
          ? this.menuHeaderStyle
          : menuHeaderStyle as MenuHeaderStyleState?,
      menuDividerStyle: menuDividerStyle == _absent
          ? this.menuDividerStyle
          : menuDividerStyle as MenuDividerStyleState?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InlineStyleState &&
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
  int get hashCode => Object.hashAll([
        surfaceColor,
        shadowColor,
        shadowOffset,
        shadowBlurRadius,
        shadowSpreadRadius,
        borderRadius,
        padding,
        maxWidth,
        maxHeight,
        menuItemStyle,
        menuHeaderStyle,
        menuDividerStyle,
      ]);

  @override
  String toString() {
    return 'InlineStyleState(surfaceColor: $surfaceColor, shadowColor: $shadowColor, '
        'shadowOffset: $shadowOffset, shadowBlurRadius: $shadowBlurRadius, '
        'shadowSpreadRadius: $shadowSpreadRadius, borderRadius: $borderRadius, '
        'padding: $padding, maxWidth: $maxWidth, maxHeight: $maxHeight, '
        'menuItemStyle: $menuItemStyle, menuHeaderStyle: $menuHeaderStyle, '
        'menuDividerStyle: $menuDividerStyle)';
  }
}
