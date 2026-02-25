# Data Model: Theme Support

**Feature Branch**: `001-theme-support`
**Date**: 2026-02-05

## Entity Diagram

```text
ContextMenuStyle (extends ThemeExtension<ContextMenuStyle>)
├── surfaceColor: Color?
├── shadowColor: Color?
├── shadowOffset: Offset?
├── shadowBlurRadius: double?
├── shadowSpreadRadius: double?
├── borderRadius: BorderRadiusGeometry?
├── padding: EdgeInsets?
├── maxWidth: double?
├── maxHeight: double?
├── menuItemStyle: MenuItemStyle?
├── menuHeaderStyle: MenuHeaderStyle?
└── menuDividerStyle: MenuDividerStyle?

MenuItemStyle
├── backgroundColor: Color?
├── focusedBackgroundColor: Color?
├── textColor: Color?
├── focusedTextColor: Color?
├── disabledTextColor: Color?
├── iconColor: Color?
├── iconSize: double?
├── shortcutTextOpacity: double?
├── height: double?
└── borderRadius: BorderRadiusGeometry?

MenuHeaderStyle
├── textStyle: TextStyle?
├── textColor: Color?
└── padding: EdgeInsets?

MenuDividerStyle
├── color: Color?
├── height: double?
├── thickness: double?
├── indent: double?
└── endIndent: double?
```

## Entity Details

### ContextMenuStyle

Top-level theme data class. Extends `ThemeExtension<ContextMenuStyle>` for `ThemeData.extensions` registration. Also used as the data payload for the `ContextMenuTheme` `InheritedWidget`.

**All fields are nullable.** Null means "not specified at this level; fall through to next precedence level."

| Field | Type | Resolves To (when null) |
|-------|------|------------------------|
| `surfaceColor` | `Color?` | `ColorScheme.surface` |
| `shadowColor` | `Color?` | `Theme.shadowColor @ 50%` |
| `shadowOffset` | `Offset?` | `Offset(0.0, 2.0)` |
| `shadowBlurRadius` | `double?` | `10.0` |
| `shadowSpreadRadius` | `double?` | `-1.0` |
| `borderRadius` | `BorderRadiusGeometry?` | `BorderRadius.circular(4.0)` |
| `padding` | `EdgeInsets?` | `EdgeInsets.all(4.0)` |
| `maxWidth` | `double?` | `350.0` |
| `maxHeight` | `double?` | unconstrained |
| `menuItemStyle` | `MenuItemStyle?` | all item defaults |
| `menuHeaderStyle` | `MenuHeaderStyle?` | all header defaults |
| `menuDividerStyle` | `MenuDividerStyle?` | all divider defaults |

**Required methods**:
- `copyWith(...)` — all fields as optional named parameters
- `lerp(ContextMenuStyle? other, double t)` — delegates to per-field lerp
- `operator ==` and `hashCode` — field-by-field comparison
- `merge(ContextMenuStyle? other)` — combines two instances (other's non-null fields win)

### MenuItemStyle

Theme data for selectable menu items (`MenuItem`).

| Field | Type | Resolves To (when null) |
|-------|------|------------------------|
| `backgroundColor` | `Color?` | `ColorScheme.surface` |
| `focusedBackgroundColor` | `Color?` | `ColorScheme.surfaceContainer` |
| `textColor` | `Color?` | `ColorScheme.onSurface @ 70%` blended with background |
| `focusedTextColor` | `Color?` | `ColorScheme.onSurface` |
| `disabledTextColor` | `Color?` | `ColorScheme.onSurface @ 20%` |
| `iconColor` | `Color?` | same as `textColor` resolution |
| `iconSize` | `double?` | `16.0` |
| `shortcutTextOpacity` | `double?` | `0.6` |
| `height` | `double?` | `32.0` |
| `borderRadius` | `BorderRadiusGeometry?` | `BorderRadius.circular(4.0)` |

**Required methods**: `copyWith`, `lerp`, `operator ==`, `hashCode`, `merge`

### MenuHeaderStyle

Theme data for non-interactive header entries (`MenuHeader`).

| Field | Type | Resolves To (when null) |
|-------|------|------------------------|
| `textStyle` | `TextStyle?` | `Theme.textTheme.labelMedium` |
| `textColor` | `Color?` | `Theme.disabledColor @ 30%` |
| `padding` | `EdgeInsets?` | `EdgeInsets.all(8.0)` |

**Required methods**: `copyWith`, `lerp`, `operator ==`, `hashCode`, `merge`

### MenuDividerStyle

Theme data for separator entries (`MenuDivider`).

| Field | Type | Resolves To (when null) |
|-------|------|------------------------|
| `color` | `Color?` | Flutter `Divider` default |
| `height` | `double?` | `8.0` |
| `thickness` | `double?` | `0.0` |
| `indent` | `double?` | `null` (no indent) |
| `endIndent` | `double?` | `null` (no indent) |

**Required methods**: `copyWith`, `lerp`, `operator ==`, `hashCode`, `merge`

## Provider Widget

### ContextMenuTheme

An `InheritedWidget` (not `InheritedNotifier` — theme data is immutable, not a `ChangeNotifier`).

**Fields**:
- `data`: `ContextMenuStyle` (required)
- `child`: `Widget` (required)

**Static accessor**:
- `ContextMenuTheme.of(BuildContext context)` → `ContextMenuStyle?`
  - Returns null if no ancestor `ContextMenuTheme` exists (does NOT throw)
- `ContextMenuTheme.maybeOf(BuildContext context)` → `ContextMenuStyle?`
  - Alias for consistency with Flutter conventions

## Theme Resolution Function

A static or top-level helper that resolves the effective theme for a given context:

```text
resolveTheme(BuildContext context) → ContextMenuStyle:
  1. Check ContextMenuTheme.of(context) → inherited widget data
  2. Check Theme.of(context).extension<ContextMenuStyle>() → extension data
  3. Merge: inherited (if present) takes priority over extension (if present)
  4. Return merged result (may still have null fields — render code fills defaults)
```

Individual render methods then apply inline overrides on top, and fall back to `ColorScheme` defaults for any remaining null fields.
