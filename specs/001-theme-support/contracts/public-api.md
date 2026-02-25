# Public API Contract: Theme Support

**Feature Branch**: `001-theme-support`
**Date**: 2026-02-05

This is a Flutter widget package (not a REST/GraphQL service). The "contract" is the public Dart API surface exposed via the barrel file.

## New Public Exports

All new types MUST be added to `lib/flutter_context_menu.dart`.

### Theme Data Classes

```dart
/// Top-level theme data. Extends ThemeExtension for ThemeData integration.
@immutable
class ContextMenuStyle extends ThemeExtension<ContextMenuStyle> {
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

  final Color? surfaceColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final double? shadowSpreadRadius;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;
  final double? maxWidth;
  final double? maxHeight;
  final MenuItemStyle? menuItemStyle;
  final MenuHeaderStyle? menuHeaderStyle;
  final MenuDividerStyle? menuDividerStyle;

  /// Merges this with [other]. Non-null fields in [other] take priority.
  ContextMenuStyle merge(ContextMenuStyle? other);

  @override
  ContextMenuStyle copyWith({...});

  @override
  ContextMenuStyle lerp(ContextMenuStyle? other, double t);
}
```

```dart
@immutable
class MenuItemStyle {
  const MenuItemStyle({
    this.backgroundColor,
    this.focusedBackgroundColor,
    this.textColor,
    this.focusedTextColor,
    this.disabledTextColor,
    this.iconColor,
    this.iconSize,
    this.shortcutTextOpacity,
    this.height,
    this.borderRadius,
  });

  final Color? backgroundColor;
  final Color? focusedBackgroundColor;
  final Color? textColor;
  final Color? focusedTextColor;
  final Color? disabledTextColor;
  final Color? iconColor;
  final double? iconSize;
  final double? shortcutTextOpacity;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  MenuItemStyle copyWith({...});
  MenuItemStyle merge(MenuItemStyle? other);
  static MenuItemStyle? lerp(MenuItemStyle? a, MenuItemStyle? b, double t);
}
```

```dart
@immutable
class MenuHeaderStyle {
  const MenuHeaderStyle({
    this.textStyle,
    this.textColor,
    this.padding,
  });

  final TextStyle? textStyle;
  final Color? textColor;
  final EdgeInsets? padding;

  MenuHeaderStyle copyWith({...});
  MenuHeaderStyle merge(MenuHeaderStyle? other);
  static MenuHeaderStyle? lerp(MenuHeaderStyle? a, MenuHeaderStyle? b, double t);
}
```

```dart
@immutable
class MenuDividerStyle {
  const MenuDividerStyle({
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  final Color? color;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  MenuDividerStyle copyWith({...});
  MenuDividerStyle merge(MenuDividerStyle? other);
  static MenuDividerStyle? lerp(MenuDividerStyle? a, MenuDividerStyle? b, double t);
}
```

### Provider Widget

```dart
/// InheritedWidget that provides ContextMenuStyle to descendants.
class ContextMenuTheme extends InheritedWidget {
  const ContextMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final ContextMenuStyle data;

  /// Returns the nearest ContextMenuStyle, or null if none.
  static ContextMenuStyle? of(BuildContext context);

  /// Alias for [of]. Returns null if no ancestor found.
  static ContextMenuStyle? maybeOf(BuildContext context);

  @override
  bool updateShouldNotify(ContextMenuTheme oldWidget);
}
```

## Modified Public API

### ContextMenu (existing — no breaking changes)

No fields are removed. Existing `padding`, `borderRadius`, `maxWidth`, `maxHeight`, `boxDecoration` continue to work as inline overrides. They take the highest precedence per FR-006.

### MenuItem (existing — no breaking changes)

Existing `textColor` field continues to work as an inline override, taking precedence over theme values.

### MenuHeader (existing — no breaking changes)

No public API changes. Theme values are read internally from context.

### MenuDivider (existing — no breaking changes)

Existing `height`, `thickness`, `indent`, `endIndent`, `color` constructor parameters continue to work as inline overrides.

## Barrel File Additions

```dart
// In lib/flutter_context_menu.dart — add these exports:
export 'src/core/models/context_menu_style.dart';
export 'src/core/models/menu_item_style.dart';
export 'src/core/models/menu_header_style.dart';
export 'src/core/models/menu_divider_style.dart';
export 'src/widgets/context_menu_theme.dart';
```

## Backward Compatibility

- All new types are additive (new files, new exports).
- No existing constructor signatures change.
- No existing method signatures change.
- No existing fields are removed or renamed.
- When no `ContextMenuTheme` or `ThemeExtension` is provided, behavior is identical to pre-feature behavior.
- This is a MINOR version bump per semver.
