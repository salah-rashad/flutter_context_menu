# Research: Theme Support

**Feature Branch**: `001-theme-support`
**Date**: 2026-02-05

## Decision 1: Theme Distribution Mechanism

**Decision**: Use both a standalone `ContextMenuTheme` `InheritedWidget` and `ThemeExtension<ContextMenuThemeData>` registration on `ThemeData.extensions`.

**Rationale**: `ThemeExtension` is Flutter's official mechanism for custom theme data (available since Flutter 3.0). It integrates with `ThemeData`, supports `lerp` for smooth theme transitions, and lets developers define context menu styling alongside light/dark themes without extra widget wrappers. The standalone `InheritedWidget` adds the ability to override themes locally in a subtree, matching Flutter patterns like `IconTheme`, `DefaultTextStyle`, etc.

**Alternatives considered**:
- `ThemeExtension` only: Would lack local subtree overrides without wrapping in a new `Theme` widget.
- `InheritedWidget` only: Would require an explicit widget wrapper even for app-wide theming — more boilerplate for the common case.
- Passing theme data directly on `ContextMenu` model: Already exists for per-menu overrides; doesn't solve the "define once" problem.

## Decision 2: Theme Data Structure

**Decision**: Single top-level `ContextMenuThemeData` class containing nested sub-theme classes: `MenuItemThemeData`, `MenuHeaderThemeData`, `MenuDividerThemeData`.

**Rationale**: Mirrors the component hierarchy. Developers can override just the parts they care about (e.g., only item colors). Nested structure keeps the top-level class clean while allowing granular control. `copyWith` on each class enables partial overrides.

**Alternatives considered**:
- Flat structure (all properties on one class): Becomes unwieldy with 20+ properties, harder to discover what affects what.
- Separate `ThemeExtension` per component: Overcomplicates access; developers would need to register 4 extensions. A single extension with nested data is simpler.

## Decision 3: Default Value Resolution Strategy

**Decision**: Theme data classes have all-nullable fields. Resolution happens at render time with a 4-level fallback chain: inline params > `ContextMenuTheme` widget > `ThemeExtension` on `ThemeData` > Material `ColorScheme` defaults (matching current behavior).

**Rationale**: All-nullable fields mean partial themes "just work" — any unset property falls through to the next level. This preserves full backward compatibility: when no theme is configured, every property resolves to the same `ColorScheme`-derived defaults currently hardcoded in the widgets.

**Alternatives considered**:
- Non-nullable fields with factory defaults: Would force developers to specify all values even for small overrides, or require a `ContextMenuThemeData.fallback(context)` factory that reads `ColorScheme`. The nullable approach is simpler and standard in Flutter (see `ButtonStyle`, `InputDecorationTheme`).

## Decision 4: ThemeExtension lerp Implementation

**Decision**: Implement `lerp` on `ContextMenuThemeData` and all sub-theme classes using Flutter's built-in lerp functions (`Color.lerp`, `BorderRadius.lerp`, `EdgeInsets.lerp`, `lerpDouble`).

**Rationale**: Required by the `ThemeExtension` contract. Enables smooth animated transitions when switching between themes (e.g., light ↔ dark). Without `lerp`, theme switches would snap abruptly.

**Alternatives considered**:
- No-op `lerp` (return `this`): Would compile but break animated theme transitions. Not acceptable for a published package.

## Decision 5: Equality and Hashcode

**Decision**: Use `@immutable` annotation on all theme data classes and implement `operator ==` and `hashCode` based on all fields.

**Rationale**: Required by FR-009. Flutter's widget rebuilding system uses equality checks to avoid unnecessary rebuilds. Without proper equality, every frame would trigger a full repaint of themed menus. The `equatable` package could help but would violate the zero-dependency constitution principle — manual implementation is needed.

**Alternatives considered**:
- `equatable` package: Violates constitution principle I (zero dependencies).
- No equality (rely on identical): Would cause unnecessary rebuilds since `copyWith` creates new instances.

## Current Hardcoded Values Catalog

These values will become theme-able properties. Captured from source analysis:

### Menu Container (`ContextMenuWidgetView`)
| Property | Current Default | Source |
|----------|----------------|--------|
| Surface color | `ColorScheme.surface` | line 18 |
| Shadow color | `Theme.shadowColor @ 50%` | line 21 |
| Shadow offset | `Offset(0.0, 2.0)` | line 22 |
| Shadow blur radius | `10` | line 23 |
| Shadow spread radius | `-1` | line 24 |
| Border radius | `BorderRadius.circular(4.0)` | line 27 |

### Menu Item (`MenuItem.builder`)
| Property | Current Default | Source |
|----------|----------------|--------|
| Background | `ColorScheme.surface` | line 81 |
| Focused background | `ColorScheme.surfaceContainer` | line 82 |
| Normal text color | `ColorScheme.onSurface @ 70%` blended with background | line 84 |
| Focused text color | `ColorScheme.onSurface` | line 88 |
| Disabled text color | `ColorScheme.onSurface @ 20%` | line 90 |
| Shortcut text opacity | `0.6` of normal text | line 144 |
| Item height | `32.0` | line 11 const |
| Icon size | `16.0` | line 98 |
| Border radius | `BorderRadius.circular(4.0)` | line 113 |

### Menu Header (`MenuHeader.builder`)
| Property | Current Default | Source |
|----------|----------------|--------|
| Text style | `Theme.textTheme.labelMedium` | line 38 |
| Text color | `Theme.disabledColor @ 30%` | line 39 |
| Padding | `EdgeInsets.all(8.0)` | line 33 |

### Menu Divider (`MenuDivider.builder`)
| Property | Current Default | Source |
|----------|----------------|--------|
| Height | `8.0` | line 45 |
| Thickness | `0.0` | line 46 |
| Color | Flutter Divider default | inherited |
