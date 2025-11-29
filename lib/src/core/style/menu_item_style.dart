import 'dart:ui';

import '../enums/menu_item_state.dart';

class MenuItemStyle {
  final Color? fgNormalColor;
  final Color? fgFocusedColor;
  final Color? fgDisabledColor;
  final Color? bgColor;
  final Color? bgDisabledColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? focusColor;
  final Color? shortcutTextColor;

  const MenuItemStyle({
    Color? fgColor,
    this.fgFocusedColor,
    this.fgDisabledColor,
    this.bgColor,
    this.bgDisabledColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.focusColor,
    this.shortcutTextColor,
  }) : fgNormalColor = fgColor;

  Color? foreground(MenuItemState state) {
    return switch (state) {
      MenuItemState.normal => fgNormalColor,
      MenuItemState.focused => fgFocusedColor,
      MenuItemState.disabled => fgDisabledColor,
    };
  }

  Color? background(MenuItemState state) {
    return switch (state) {
      MenuItemState.normal => bgColor,
      MenuItemState.focused => bgColor,
      MenuItemState.disabled => bgDisabledColor,
    };
  }

  MenuItemStyle copyWith({
    Color? fgNormalColor,
    Color? fgFocusedColor,
    Color? fgDisabledColor,
    Color? bgColor,
    Color? bgDisabledColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? focusColor,
    Color? shortcutTextColor,
  }) {
    return MenuItemStyle(
      fgColor: fgNormalColor ?? this.fgNormalColor,
      fgFocusedColor: fgFocusedColor ?? this.fgFocusedColor,
      fgDisabledColor: fgDisabledColor ?? this.fgDisabledColor,
      bgColor: bgColor ?? this.bgColor,
      bgDisabledColor: bgDisabledColor ?? this.bgDisabledColor,
      hoverColor: hoverColor ?? this.hoverColor,
      highlightColor: highlightColor ?? this.highlightColor,
      splashColor: splashColor ?? this.splashColor,
      focusColor: focusColor ?? this.focusColor,
      shortcutTextColor: shortcutTextColor ?? this.shortcutTextColor,
    );
  }

  MenuItemStyle merge(MenuItemStyle? other) {
    if (other == null) return this;

    return copyWith(
      fgNormalColor: other.fgNormalColor ?? fgNormalColor,
      fgFocusedColor: other.fgFocusedColor ?? fgFocusedColor,
      fgDisabledColor: other.fgDisabledColor ?? fgDisabledColor,
      bgColor: other.bgColor ?? bgColor,
      bgDisabledColor: other.bgDisabledColor ?? bgDisabledColor,
      hoverColor: other.hoverColor ?? hoverColor,
      highlightColor: other.highlightColor ?? highlightColor,
      splashColor: other.splashColor ?? splashColor,
      focusColor: other.focusColor ?? focusColor,
      shortcutTextColor: other.shortcutTextColor ?? shortcutTextColor,
    );
  }

  static MenuItemStyle? lerp(MenuItemStyle? x, MenuItemStyle? y, double t) {
    if (x == null || y == null) return null;

    final fgNormal = Color.lerp(x.fgNormalColor, y.fgNormalColor, t);
    final fgFocused = Color.lerp(x.fgFocusedColor, y.fgFocusedColor, t);
    final fgDisabled = Color.lerp(x.fgDisabledColor, y.fgDisabledColor, t);
    final bg = Color.lerp(x.bgColor, y.bgColor, t);
    final bgDisabled = Color.lerp(x.bgDisabledColor, y.bgDisabledColor, t);
    final hoverColor = Color.lerp(x.hoverColor, y.hoverColor, t);
    final highlightColor = Color.lerp(x.highlightColor, y.highlightColor, t);
    final splashColor = Color.lerp(x.splashColor, y.splashColor, t);
    final focusColor = Color.lerp(x.focusColor, y.focusColor, t);
    final shortcutTextColor =
        Color.lerp(x.shortcutTextColor, y.shortcutTextColor, t);

    return MenuItemStyle(
      fgColor: fgNormal,
      fgFocusedColor: fgFocused,
      fgDisabledColor: fgDisabled,
      bgColor: bg,
      bgDisabledColor: bgDisabled,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      focusColor: focusColor,
      shortcutTextColor: shortcutTextColor,
    );
  }
}
