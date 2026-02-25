# Plan: Phase 4 Fixes — Deprecated Fields, Theme Resolution Consolidation, Example Demo

## Context

During 001-theme-support Phase 3/4, five styling fields (`padding`, `borderRadius`, `maxWidth`, `maxHeight`, `boxDecoration`) were removed from `ContextMenu` and replaced by a single `theme: ContextMenuStyle?` field. This is a breaking API change. The user wants to restore them as `@Deprecated` for backward compatibility. Additionally, theme resolution logic is duplicated across 3 files and needs consolidation, and the example app lacks a `ContextMenuTheme` InheritedWidget demo.

## Changes (in execution order)

### 1. Consolidate duplicated `_resolveTheme()` logic

**Add `resolve()` to `ContextMenuTheme`** — `lib/src/widgets/theme/context_menu_theme.dart`
- Add `static ContextMenuStyle resolve(BuildContext context)` that contains the shared fallback → ThemeExtension → InheritedWidget merge chain (currently in `ContextMenuWidgetView.resolveTheme()`)

**Simplify `ContextMenuWidgetView.resolveTheme()`** — `lib/src/widgets/base/context_menu_widget_view.dart`
- Delegate to `ContextMenuTheme.resolve(context)` (keep method as public convenience API)

**Simplify `MenuDivider._resolveTheme()`** — `lib/src/components/menu_divider.dart`
- Replace 15-line if-else with: `ContextMenuTheme.resolve(context).menuDividerStyle ?? const MenuDividerStyle()`
- Remove unused `context_menu_style.dart` import

**Simplify `MenuHeader._resolveTheme()`** — `lib/src/components/menu_header.dart`
- Same pattern: `ContextMenuTheme.resolve(context).menuHeaderStyle ?? const MenuHeaderStyle()`
- Remove unused `context_menu_style.dart` import

### 2. Restore deprecated fields on `ContextMenu`

**File**: `lib/src/core/models/context_menu.dart`

Add back 5 named constructor parameters with `@Deprecated` annotations:
- `padding: EdgeInsets?`
- `borderRadius: BorderRadiusGeometry?`
- `maxWidth: double?`
- `maxHeight: double?`
- `boxDecoration: BoxDecoration?`

**Merging strategy**:
- `padding`, `borderRadius`, `maxWidth`, `maxHeight` — folded into `theme` via a `static _mergeDeprecatedIntoTheme()` helper called in the initializer list. Explicit `theme` values win over deprecated values (`deprecatedTheme.merge(theme)`).
- `boxDecoration` — stored as a deprecated class field (cannot be cleanly decomposed into theme properties). Handled in the view.
- `theme` parameter changes from `this.theme` to plain `ContextMenuStyle? theme` since it's now computed in the initializer list.

**Update `copyWith`**: Add deprecated params, pre-merge into theme before constructing, pass `boxDecoration` through.

**Handle `boxDecoration` in view** — `lib/src/widgets/base/context_menu_widget_view.dart`
- After building `BoxDecoration` from theme, check `menu.boxDecoration` — if non-null, use it instead (preserves old full-override behavior).
- Add `// ignore: deprecated_member_use_from_same_package` where needed.

### 3. Add `ContextMenuTheme` InheritedWidget demo to example

**File**: `example/lib/pages/demo_page.dart`

- Add one extra grid tile wrapping a `ContextMenuRegion` with `ContextMenuTheme(data: ..., child: ...)` — distinct visual (teal surface, rounded corners) to show the InheritedWidget subtree override mechanism.
- Increment `itemCount` by 1, handle the extra index with a dedicated builder method.

## Verification

1. `flutter analyze --fatal-warnings` — must pass (deprecated ignores where needed)
2. `dart format --output=none --set-exit-if-changed .` — must pass
3. Run example app — verify all 6 tiles work: global theme, inline override, full override, position override, long menu, InheritedWidget theme
4. Backward compat smoke test: old constructor call like `ContextMenu(entries: e, padding: EdgeInsets.all(8))` should compile with a deprecation warning and work correctly
