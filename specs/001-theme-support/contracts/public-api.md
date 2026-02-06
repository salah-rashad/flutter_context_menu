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
class ContextMenuThemeData extends ThemeExtension<ContextMenuThemeData> {
  const ContextMenuThemeData({
    this.surfaceColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.borderRadius,
    this.padding,
    this.maxWidth,
    this.maxHeight,
    this.menuItemTheme,
    this.menuHeaderTheme,
    this.menuDividerTheme,
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
  final MenuItemThemeData? menuItemTheme;
  final MenuHeaderThemeData? menuHeaderTheme;
  final MenuDividerThemeData? menuDividerTheme;

  /// Merges this with [other]. Non-null fields in [other] take priority.
  ContextMenuThemeData merge(ContextMenuThemeData? other);

  @override
  ContextMenuThemeData copyWith({...});

  @override
  ContextMenuThemeData lerp(ContextMenuThemeData? other, double t);
}
```

```dart
@immutable
class MenuItemThemeData {
  const MenuItemThemeData({
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

  MenuItemThemeData copyWith({...});
  MenuItemThemeData merge(MenuItemThemeData? other);
  static MenuItemThemeData? lerp(MenuItemThemeData? a, MenuItemThemeData? b, double t);
}
```

```dart
@immutable
class MenuHeaderThemeData {
  const MenuHeaderThemeData({
    this.textStyle,
    this.textColor,
    this.padding,
  });

  final TextStyle? textStyle;
  final Color? textColor;
  final EdgeInsets? padding;

  MenuHeaderThemeData copyWith({...});
  MenuHeaderThemeData merge(MenuHeaderThemeData? other);
  static MenuHeaderThemeData? lerp(MenuHeaderThemeData? a, MenuHeaderThemeData? b, double t);
}
```

```dart
@immutable
class MenuDividerThemeData {
  const MenuDividerThemeData({
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

  MenuDividerThemeData copyWith({...});
  MenuDividerThemeData merge(MenuDividerThemeData? other);
  static MenuDividerThemeData? lerp(MenuDividerThemeData? a, MenuDividerThemeData? b, double t);
}
```

### Provider Widget

```dart
/// InheritedWidget that provides ContextMenuThemeData to descendants.
class ContextMenuTheme extends InheritedWidget {
  const ContextMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final ContextMenuThemeData data;

  /// Returns the nearest ContextMenuThemeData, or null if none.
  static ContextMenuThemeData? of(BuildContext context);

  /// Alias for [of]. Returns null if no ancestor found.
  static ContextMenuThemeData? maybeOf(BuildContext context);

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
export 'src/core/models/context_menu_theme_data.dart';
export 'src/core/models/menu_item_theme_data.dart';
export 'src/core/models/menu_header_theme_data.dart';
export 'src/core/models/menu_divider_theme_data.dart';
export 'src/widgets/context_menu_theme.dart';
```

## Backward Compatibility

- All new types are additive (new files, new exports).
- No existing constructor signatures change.
- No existing method signatures change.
- No existing fields are removed or renamed.
- When no `ContextMenuTheme` or `ThemeExtension` is provided, behavior is identical to pre-feature behavior.
- This is a MINOR version bump per semver.
