# Tasks: Theme Support

**Input**: Design documents from `/specs/001-theme-support/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Not requested in the feature specification. Test tasks are omitted.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter package**: `lib/src/` for source, `lib/flutter_context_menu.dart` for barrel file, `example/` for demo app

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: No project initialization needed — this is an existing Flutter package. Setup phase creates the new theme data model files that all user stories depend on.

*Nothing to do — existing project is already set up. Proceed to Phase 2.*

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create all theme data classes and the provider widget. These are required by ALL user stories before any rendering changes can be made.

**CRITICAL**: No user story work can begin until this phase is complete.

- [x] T001 [P] Create `MenuItemThemeData` class with all fields (backgroundColor, focusedBackgroundColor, textColor, focusedTextColor, disabledTextColor, iconColor, iconSize, shortcutTextOpacity, height, borderRadius), const constructor, copyWith, merge, lerp, operator ==, and hashCode in `lib/src/core/models/menu_item_theme_data.dart`
- [x] T002 [P] Create `MenuHeaderThemeData` class with all fields (textStyle, textColor, padding), const constructor, copyWith, merge, lerp, operator ==, and hashCode in `lib/src/core/models/menu_header_theme_data.dart`
- [x] T003 [P] Create `MenuDividerThemeData` class with all fields (color, height, thickness, indent, endIndent), const constructor, copyWith, merge, lerp, operator ==, and hashCode in `lib/src/core/models/menu_divider_theme_data.dart`
- [x] T004 Create `ContextMenuThemeData` class extending `ThemeExtension<ContextMenuThemeData>` with all fields (surfaceColor, shadowColor, shadowOffset, shadowBlurRadius, shadowSpreadRadius, borderRadius, padding, maxWidth, maxHeight, menuItemTheme, menuHeaderTheme, menuDividerTheme), const constructor, copyWith, merge, lerp, operator ==, and hashCode in `lib/src/core/models/context_menu_theme_data.dart` (depends on T001, T002, T003)
- [x] T005 Create `ContextMenuTheme` InheritedWidget with `data` field, static `of(BuildContext)` and `maybeOf(BuildContext)` accessors (both return `ContextMenuThemeData?`), and `updateShouldNotify` in `lib/src/widgets/context_menu_theme.dart` (depends on T004)
- [x] T006 Add new exports to barrel file `lib/flutter_context_menu.dart`: export `context_menu_theme_data.dart`, `menu_item_theme_data.dart`, `menu_header_theme_data.dart`, `menu_divider_theme_data.dart`, and `context_menu_theme.dart` (depends on T004, T005)
- [x] T007 Run `flutter analyze --fatal-warnings` and `dart format --output=none --set-exit-if-changed .` to verify all new files pass static analysis and formatting

**Checkpoint**: All theme data classes and provider widget exist, are exported, and pass analysis. User story implementation can now begin.

---

## Phase 3: User Story 1 - Define Global Context Menu Theme (Priority: P1) MVP

**Goal**: Developers can define a context menu theme globally (via `ThemeExtension` on `ThemeData` or `ContextMenuTheme` widget) and all context menus inherit that styling without explicit per-menu parameters. Full backward compatibility when no theme is configured.

**Independent Test**: Define a `ContextMenuThemeData` with custom `surfaceColor` and `borderRadius` on `ThemeData.extensions`, render a context menu with no inline overrides, and verify the menu uses the themed values. Then remove the theme and verify the menu renders with current defaults.

### Implementation for User Story 1

- [ ] T008 [US1] Update `ContextMenuWidgetView.build()` in `lib/src/widgets/context_menu_widget_view.dart` to resolve the effective theme: look up `ContextMenuTheme.of(context)`, then `Theme.of(context).extension<ContextMenuThemeData>()`, merge them (InheritedWidget wins), and use resolved `surfaceColor`, `shadowColor`, `shadowOffset`, `shadowBlurRadius`, `shadowSpreadRadius`, `borderRadius` for the default `BoxDecoration` instead of hardcoded values. Preserve existing `menu.boxDecoration` override behavior (inline wins). Preserve existing `menu.borderRadius` and `menu.padding` inline overrides taking precedence over theme values.
- [ ] T009 [US1] Update `MenuHeader.builder()` in `lib/src/components/menu_header.dart` to resolve `MenuHeaderThemeData` from the effective theme and use themed `textStyle`, `textColor`, and `padding` instead of hardcoded values. Fall back to current defaults (`Theme.textTheme.labelMedium`, `Theme.disabledColor @ 30%`, `EdgeInsets.all(8.0)`) when theme values are null.
- [ ] T010 [US1] Update `MenuDivider.builder()` in `lib/src/components/menu_divider.dart` to resolve `MenuDividerThemeData` from the effective theme. Use themed values as defaults when inline constructor parameters (`height`, `thickness`, `indent`, `endIndent`, `color`) are null. Preserve existing inline override behavior — constructor params still win.
- [ ] T011 [US1] Run `flutter analyze --fatal-warnings` and `dart format --output=none --set-exit-if-changed .` to verify all modified files pass
- [ ] T012 [US1] Update `example/lib/main.dart` to demonstrate theme support: add a `ContextMenuThemeData` to `ThemeData.extensions` in the `MaterialApp` with custom `surfaceColor`, `borderRadius`, and `padding`. Verify context menus adopt the theme. Also show `ContextMenuTheme` widget wrapping a subtree with a different theme.

**Checkpoint**: Global theming works via both `ThemeExtension` and `ContextMenuTheme` widget for the menu container, headers, and dividers. Menus without any theme configured render identically to pre-feature behavior.

---

## Phase 4: User Story 2 - Override Global Theme Per Menu Instance (Priority: P2)

**Goal**: Inline parameters on `ContextMenu` and `MenuDivider` take precedence over global theme values for that specific instance only.

**Independent Test**: Define a global theme with custom `surfaceColor` and `borderRadius`. Render two menus: one with no overrides (should use global theme) and one with explicit `borderRadius: 12.0` (should use inline value while falling back to theme for other properties).

### Implementation for User Story 2

- [ ] T013 [US2] Verify and refine the precedence logic in `ContextMenuWidgetView.build()` in `lib/src/widgets/context_menu_widget_view.dart`: ensure `menu.boxDecoration` fully overrides the themed decoration, `menu.borderRadius` overrides only border radius (other theme properties still apply), and `menu.padding`/`menu.maxWidth`/`menu.maxHeight` override their respective theme values. Add inline comments documenting the four-level precedence chain.
- [ ] T014 [US2] Verify and refine the precedence logic in `MenuDivider.builder()` in `lib/src/components/menu_divider.dart`: ensure constructor parameters (`height`, `thickness`, `indent`, `endIndent`, `color`) override theme values when non-null.
- [ ] T015 [US2] Run `flutter analyze --fatal-warnings` and `dart format --output=none --set-exit-if-changed .`
- [ ] T016 [US2] Update `example/lib/main.dart` to add a second context menu with inline overrides (e.g., different `borderRadius` and `boxDecoration`) alongside the globally-themed menu, demonstrating that overrides apply only to that instance.

**Checkpoint**: Inline overrides work at single-property granularity. Global theme still applies to non-overridden menus.

---

## Phase 5: User Story 3 - Customize Individual Menu Item Styles via Theme (Priority: P3)

**Goal**: Developers can control menu item appearance globally via `MenuItemThemeData` within the global theme — text colors, background colors for normal/focused/disabled states, icon color, icon size, item height, border radius, and shortcut text opacity.

**Independent Test**: Define a `ContextMenuThemeData` with `menuItemTheme: MenuItemThemeData(height: 40.0, focusedBackgroundColor: Colors.blue.shade50, textColor: Colors.indigo)`. Render a menu with several items. Verify items use themed height, themed focused background on hover/focus, and themed text color. Then add a `MenuItem` with explicit `textColor: Colors.red` and verify it overrides the theme.

### Implementation for User Story 3

- [ ] T017 [US3] Update `MenuItem.builder()` in `lib/src/components/menu_item.dart` to resolve `MenuItemThemeData` from the effective theme. Replace hardcoded color logic: use themed `backgroundColor` (fallback: `ColorScheme.surface`), `focusedBackgroundColor` (fallback: `ColorScheme.surfaceContainer`), `textColor` (fallback: `ColorScheme.onSurface @ 70%` blended with background), `focusedTextColor` (fallback: `ColorScheme.onSurface`), `disabledTextColor` (fallback: `ColorScheme.onSurface @ 20%`), `iconColor` (fallback: same as textColor), `iconSize` (fallback: `16.0`), `shortcutTextOpacity` (fallback: `0.6`), `height` (fallback: `32.0`, replacing `kMenuItemHeight`), and `borderRadius` (fallback: `BorderRadius.circular(4.0)`). Preserve `MenuItem.textColor` inline override taking precedence over theme.
- [ ] T018 [US3] Run `flutter analyze --fatal-warnings` and `dart format --output=none --set-exit-if-changed .`
- [ ] T019 [US3] Update `example/lib/main.dart` to demonstrate item-level theming: set `menuItemTheme` with custom `height`, `focusedBackgroundColor`, and `textColor` in the global theme. Include one `MenuItem` with an explicit `textColor` to demonstrate inline override precedence.

**Checkpoint**: All three user stories complete. Menu container, headers, dividers, and items all respect the global theme with inline override precedence.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation, version bump, and cleanup

- [ ] T020 Run full `flutter analyze --fatal-warnings` across entire package
- [ ] T021 Run `dart format --output=none --set-exit-if-changed .` across entire package
- [ ] T022 Bump version in `pubspec.yaml` from `0.4.1` to `0.5.0` (MINOR — additive public API, no breaking changes)
- [ ] T023 Run `example/lib/main.dart` and verify quickstart.md scenarios: themed menu renders correctly, light/dark switch works, inline overrides win, no-theme case matches pre-feature behavior
- [ ] T024 Update `CHANGELOG.md` with theme support feature entry under version `0.5.0`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Skipped — existing project
- **Foundational (Phase 2)**: No dependencies — can start immediately. BLOCKS all user stories.
- **User Story 1 (Phase 3)**: Depends on Phase 2 completion
- **User Story 2 (Phase 4)**: Depends on Phase 3 (refines precedence logic introduced in US1)
- **User Story 3 (Phase 5)**: Depends on Phase 2 completion (independent of US1/US2 for item theming, but sequenced after for clean integration)
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Phase 2. Implements theme resolution in container, header, divider.
- **User Story 2 (P2)**: Starts after US1. Refines and validates the inline-override precedence logic introduced in US1.
- **User Story 3 (P3)**: Starts after US2. Implements theme resolution in `MenuItem.builder()`.

### Within Each User Story

- Theme resolution logic before rendering changes
- Rendering changes before example app updates
- Analysis/format check after each story's code changes

### Parallel Opportunities

- T001, T002, T003 can all run in parallel (independent sub-theme data classes in separate files)
- T008, T009, T010 modify different files and could theoretically run in parallel, but T008 establishes the theme resolution pattern that T009 and T010 follow — sequential is safer

---

## Parallel Example: Phase 2

```bash
# Launch all sub-theme data classes in parallel:
Task: "Create MenuItemThemeData in lib/src/core/models/menu_item_theme_data.dart"
Task: "Create MenuHeaderThemeData in lib/src/core/models/menu_header_theme_data.dart"
Task: "Create MenuDividerThemeData in lib/src/core/models/menu_divider_theme_data.dart"

# Then sequentially:
Task: "Create ContextMenuThemeData in lib/src/core/models/context_menu_theme_data.dart"
Task: "Create ContextMenuTheme in lib/src/widgets/context_menu_theme.dart"
Task: "Update barrel file"
Task: "Run analysis"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 2: Foundational (theme data classes + provider)
2. Complete Phase 3: User Story 1 (container, header, divider theming)
3. **STOP and VALIDATE**: Verify global theming works, backward compatibility holds
4. This alone delivers the core value proposition

### Incremental Delivery

1. Phase 2 → Foundation ready
2. Phase 3 (US1) → Global theming works (MVP!)
3. Phase 4 (US2) → Inline overrides validated
4. Phase 5 (US3) → Item-level theming complete
5. Phase 6 → Polish, version bump, publish

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- All theme data classes use `@immutable`, `const` constructors, relative imports
- No new runtime dependencies (constitution principle I)
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
