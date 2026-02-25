# Plan: Rename ThemeData classes to Style classes

## Context

The theme data classes (`ContextMenuThemeData`, `MenuItemThemeData`, etc.) and `theme` fields should
be renamed to use "Style" naming (`ContextMenuStyle`, `MenuItemStyle`, etc.) for better API clarity.
The `ContextMenuTheme` InheritedWidget keeps its name (it's a widget, not a data class).

## Rename Map

| Old                             | New                       |
|---------------------------------|---------------------------|
| `ContextMenuThemeData`          | `ContextMenuStyle`        |
| `MenuItemThemeData`             | `MenuItemStyle`           |
| `MenuHeaderThemeData`           | `MenuHeaderStyle`         |
| `MenuDividerThemeData`          | `MenuDividerStyle`        |
| `context_menu_theme_data.dart`  | `context_menu_style.dart` |
| `menu_item_theme_data.dart`     | `menu_item_style.dart`    |
| `menu_header_theme_data.dart`   | `menu_header_style.dart`  |
| `menu_divider_theme_data.dart`  | `menu_divider_style.dart` |
| `.theme` (field on ContextMenu) | `.style`                  |
| `.menuItemTheme`                | `.menuItemStyle`          |
| `.menuHeaderTheme`              | `.menuHeaderStyle`        |
| `.menuDividerTheme`             | `.menuDividerStyle`       |

| **NOT renamed**: `ContextMenuTheme` widget, its `data` field, `resolve()`, `of()`, `maybeOf()`.

## Files to modify (Dart)

### 1. Rename files (git mv)

- `lib/src/core/models/context_menu_theme_data.dart` → `context_menu_style.dart`
- `lib/src/core/models/menu_item_theme_data.dart` → `menu_item_style.dart`
- `lib/src/core/models/menu_header_theme_data.dart` → `menu_header_style.dart`
- `lib/src/core/models/menu_divider_theme_data.dart` → `menu_divider_style.dart`

### 2. Class/field renames within each file

- `lib/src/core/models/context_menu_style.dart` — class name, ThemeExtension type param, all field
  names, constructor, copyWith, lerp, merge, ==, hashCode
- `lib/src/core/models/menu_item_style.dart` — class name, all methods
- `lib/src/core/models/menu_header_style.dart` — class name, all methods
- `lib/src/core/models/menu_divider_style.dart` — class name, all methods

### 3. Update imports and references

- `lib/flutter_context_menu.dart` — 4 export paths
- `lib/src/core/models/context_menu.dart` — import path, field type+name, copyWith param
- `lib/src/widgets/theme/context_menu_theme.dart` — import path, type refs in resolve/of/maybeOf
- `lib/src/widgets/base/context_menu_widget_view.dart` — type refs, `.style` access, comments
- `lib/src/widgets/provider/context_menu_state.dart` — `.style` access
- `lib/src/components/menu_divider.dart` — import path, type refs, `.menuDividerStyle`
- `lib/src/components/menu_header.dart` — import path, type refs, `.menuHeaderStyle`

### 4. Example files

- `example/lib/main.dart` — `ContextMenuStyle(` instantiation
- `example/lib/pages/demo_page.dart` — `ContextMenuStyle(`, `MenuHeaderStyle(`, `MenuDividerStyle(`,
  `style:` param
- `example/lib/pages/menu_items.dart` — `ContextMenuStyle(`, `MenuItemStyle(` instantiation

- `example/lib/entries/custom_context_menu_item.dart` — `ContextMenuStyle(` instantiation

### 5. Spec markdown files (update references)

- `specs/001-theme-support/spec.md`
- `specs/001-theme-support/tasks.md`
- `specs/001-theme-support/plan.md`
- `specs/001-theme-support/data-model.md`
- `specs/001-theme-support/quickstart.md`
- `specs/001-theme-support/contracts/public-api.md`
- `specs/001-theme-support/phase3-implementation-summary.md`
- `specs/001-theme-support/phase4-plan.md`
- `specs/001-theme-support/research.md`
- `CLAUDE.md` (if any refs)
