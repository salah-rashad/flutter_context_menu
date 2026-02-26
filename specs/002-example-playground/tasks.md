# Tasks: Example Playground

**Input**: Design documents from `/specs/002-example-playground/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/state-contracts.md, quickstart.md

**Tests**: No test tasks generated (not requested in spec). Manual visual testing via `flutter run -d chrome`.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, dependency setup, and scaffold

- [x] T001 Clean existing example app: remove `example/lib/pages/`, `example/lib/entries/`, and old `example/lib/main.dart` content
- [x] T002 Update `example/pubspec.yaml` to add `shadcn_flutter` and `provider` dependencies, remove `flutter_web_plugins`
- [x] T003 Run `flutter pub get` in `example/` to resolve dependencies
- [x] T004 Create directory structure: `example/lib/state/`, `example/lib/screens/`, `example/lib/widgets/tools_panel/structure_tab/`, `example/lib/widgets/tools_panel/theming_tab/shared/`, `example/lib/widgets/common/`, `example/lib/utils/`
- [x] T005 Create `example/lib/main.dart` with `ShadcnApp` root, `ChangeNotifierProvider<PlaygroundState>`, light/dark theme config using `ColorSchemes`
- [x] T006 Create `example/lib/app.dart` with root app widget that reads `PlaygroundState.appSettings.themeMode` and passes it to `ShadcnApp`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: State models and utility layers that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T007 [P] Create `example/lib/state/app_settings_state.dart` with `AppSettingsState` class containing `ThemeMode themeMode` field
- [x] T008 [P] Create `example/lib/state/entry_node.dart` with `EntryNode` class and `EntryType` enum per data-model.md, including `toEntry()` conversion method that produces `MenuItem<String>`, `MenuHeader`, or `MenuDivider`
- [x] T009 [P] Create `example/lib/state/menu_properties_state.dart` with `MenuPropertiesState` class (clipBehavior, respectPadding). Note: maxWidth/maxHeight are ContextMenuStyle properties and live in InlineStyleState, not here.
- [x] T010 [P] Create `example/lib/state/menu_item_style_state.dart` with `MenuItemStyleState` class (all nullable fields per data-model.md) and `toMenuItemStyle()` builder
- [x] T011 [P] Create `example/lib/state/menu_header_style_state.dart` with `MenuHeaderStyleState` class and `toMenuHeaderStyle()` builder
- [x] T012 [P] Create `example/lib/state/menu_divider_style_state.dart` with `MenuDividerStyleState` class and `toMenuDividerStyle()` builder
- [x] T013 [P] Create `example/lib/state/inline_style_state.dart` with `InlineStyleState` class containing all `ContextMenuStyle` fields + nested sub-style states, and `toContextMenuStyle()` builder
- [x] T014 [P] Create `example/lib/state/inherited_theme_state.dart` with `InheritedThemeState` class (enabled flag + `InlineStyleState style`)
- [x] T015 [P] Create `example/lib/state/theme_extension_state.dart` with `ThemeExtensionState` class (enabled flag + `InlineStyleState style`)
- [x] T016 Create `example/lib/state/playground_state.dart` with `PlaygroundState extends ChangeNotifier` composing all sub-states, implementing `buildContextMenu()`, `buildInlineStyle()`, `buildInheritedStyle()`, `buildThemeExtensionStyle()`, and all mutation methods per contracts/state-contracts.md
- [x] T017 [P] Create `example/lib/utils/default_entries.dart` with default sample `List<EntryNode>` (header, items with icons/shortcuts, divider, submenu, disabled item) per data-model.md
- [x] T018 [P] Create `example/lib/utils/theme_bridge.dart` with `buildMaterialTheme()` function that produces a `ThemeData` from current shadcn_flutter color context and optional `ContextMenuStyle` extension
- [x] T019 Create `example/lib/screens/playground_screen.dart` with `ResizablePanel.horizontal` split layout: left `ResizablePane` (tools panel placeholder) + right `ResizablePane` (playground area placeholder)

**Checkpoint**: Foundation ready — state model complete, split layout renders, `flutter run -d chrome` shows empty split view

---

## Phase 3: User Story 1 — View and Interact with Pre-Rendered Context Menu (Priority: P1) 🎯 MVP

**Goal**: Display an always-visible, fully interactable context menu at the center of the playground area with default entries. Menu cannot be dismissed.

**Independent Test**: Launch app → context menu visible at center → hover shows focus states → submenus open/close → clicking outside or pressing Escape does not dismiss → selecting an item shows feedback but menu stays open.

### Implementation for User Story 1

- [x] T020 [US1] Create `example/lib/widgets/embedded_context_menu.dart` — StatefulWidget that creates `ContextMenuState<String>` from `PlaygroundState.buildContextMenu()`, places `ContextMenuWidget<String>` inside a `Stack`, provides custom `onItemSelected` that updates `PlaygroundState.lastSelectedValue` without dismissing, intercepts Escape key to prevent dismissal, and recreates state when entries change
- [x] T021 [US1] Create `example/lib/widgets/playground_area.dart` — Reads `PlaygroundState` via `context.watch`, wraps content in `Theme` widget (Material bridge from `theme_bridge.dart`), centers `EmbeddedContextMenu`, shows selection feedback (toast via shadcn_flutter `showToast` or bottom status bar) when `lastSelectedValue` changes. NOTE: Do NOT add ContextMenuTheme wrapping here — that is added by T048 (US5).
- [x] T022 [US1] Wire `PlaygroundArea` into the right pane of `PlaygroundScreen` and wire a minimal placeholder into the left pane
- [x] T023 [US1] Verify: run `flutter run -d chrome`, confirm context menu renders at center with default entries, hover/focus states work, submenus open/close, Escape/click-outside does not dismiss, item selection shows feedback

**Checkpoint**: MVP complete — always-visible interactable context menu displayed with default config

---

## Phase 4: User Story 2 — Modify Menu Entries via Tools Panel (Priority: P1)

**Goal**: Tree-based editor in the tools panel for adding, removing, reordering, and editing menu entries. Changes reflected on context menu in real time.

**Independent Test**: Open tree editor → add MenuItem → see it in menu → add Header/Divider → see in menu → remove entry → disappears → reorder → menu reflects new order → convert item to submenu → add children → submenu works.

### Implementation for User Story 2

- [ ] T024 [P] [US2] Create `example/lib/widgets/common/icon_picker.dart` — `Select` dropdown with predefined list of common Material icons (file, edit, save, copy, paste, delete, settings, etc.), returns `IconData?`
- [ ] T025 [P] [US2] Create `example/lib/widgets/common/section_header.dart` — Collapsible section header widget using shadcn_flutter `Accordion` or styled `GhostButton`
- [ ] T026 [US2] Create `example/lib/widgets/tools_panel/structure_tab/entry_node_tile.dart` — Single tree node widget showing entry type icon, label, and action buttons (delete, move up/down), tappable to select for property editing
- [ ] T027 [US2] Create `example/lib/widgets/tools_panel/structure_tab/entry_properties.dart` — Property editor panel for the currently selected `EntryNode` with basic fields: label `TextField`, enabled `Switch`, value input, submenu toggle `Switch`, and divider/header-specific fields (disableUppercase, dividerHeight, etc.) depending on `EntryType`. NOTE: Icon picker, shortcut selector, text color, and trailing widget are added by T060 (US8).
- [ ] T028 [US2] Create `example/lib/widgets/tools_panel/structure_tab/entry_tree_editor.dart` — Full tree editor using shadcn_flutter `TreeView` or custom list with `EntryNodeTile` widgets, "Add" button (dropdown to pick MenuItem/MenuHeader/MenuDivider), reorder via move up/down buttons, recursive rendering for submenu children, selected entry state for property editing
- [ ] T029 [US2] Create `example/lib/widgets/tools_panel/structure_tab/structure_tab.dart` — Layout combining `EntryTreeEditor` at top and `EntryProperties` below (or side by side), scrollable
- [ ] T030 [US2] Create `example/lib/widgets/tools_panel/tools_panel.dart` — Two-level `Tabs` container: "Structure" tab (renders `StructureTab`) and "Theming" tab (placeholder for now)
- [ ] T031 [US2] Wire `ToolsPanel` into the left pane of `PlaygroundScreen`, replacing the placeholder
- [ ] T032 [US2] Verify: add/remove/reorder entries in tree → context menu updates in real time; edit entry properties → reflected on menu; convert to submenu → add children → submenu renders

**Checkpoint**: Entry manipulation complete — full CRUD on menu entries with real-time preview

---

## Phase 5: User Story 3 — Configure Menu Properties (Priority: P2)

**Goal**: Controls for ContextMenu-level properties (clipBehavior, respectPadding, maxWidth, maxHeight) in the Structure tab.

**Independent Test**: Toggle respectPadding → behavior changes → change clipBehavior via dropdown → menu reflects → adjust maxWidth/maxHeight sliders → menu constrains.

### Implementation for User Story 3

- [ ] T033 [P] [US3] Create `example/lib/widgets/common/number_field.dart` — Numeric input widget combining shadcn_flutter `TextField` (number input) with `Slider` for visual adjustment, supports min/max/step, optional null toggle for nullable values
- [ ] T034 [US3] Create `example/lib/widgets/tools_panel/structure_tab/menu_properties.dart` — Section with: `Select` dropdown for `Clip` enum, `Switch` for respectPadding. Reads/writes `PlaygroundState.menuProperties`. Note: maxWidth/maxHeight are configured in the StyleEditor (theme tabs), not here.
- [ ] T035 [US3] Add `MenuProperties` widget to `StructureTab` below the entry tree editor, wrapped in a collapsible `SectionHeader`
- [ ] T036 [US3] Update `EmbeddedContextMenu` to pass `clipBehavior` and `respectPadding` from `PlaygroundState.menuProperties` to the built `ContextMenu`
- [ ] T037 [US3] Verify: toggle each property → observe behavior change on pre-rendered menu

**Checkpoint**: All ContextMenu-level properties are configurable

---

## Phase 6: User Story 4 — Inline Style Overrides (Priority: P2)

**Goal**: "Inline Style" sub-tab under Theming for configuring all `ContextMenuStyle` properties passed directly to the `ContextMenu` instance.

**Independent Test**: Change surface color → menu background updates → adjust shadow → shadow changes → modify MenuItemStyle properties → items reflect changes.

### Implementation for User Story 4

- [ ] T038 [P] [US4] Create `example/lib/widgets/common/color_field.dart` — Wrapper around shadcn_flutter `ColorInput` with label, nullable toggle (checkbox to enable/disable), returns `Color?`
- [ ] T039 [P] [US4] Create `example/lib/widgets/tools_panel/theming_tab/shared/menu_item_style_editor.dart` — Collapsible editor for all `MenuItemStyleState` fields: color fields for backgroundColor/focusedBackgroundColor/textColor/focusedTextColor/disabledTextColor/iconColor/shortcutTextColor, number fields for iconSize/height/borderRadius, slider for shortcutTextOpacity
- [ ] T040 [P] [US4] Create `example/lib/widgets/tools_panel/theming_tab/shared/menu_header_style_editor.dart` — Collapsible editor for `MenuHeaderStyleState` fields: color field for textColor, number field for padding
- [ ] T041 [P] [US4] Create `example/lib/widgets/tools_panel/theming_tab/shared/menu_divider_style_editor.dart` — Collapsible editor for `MenuDividerStyleState` fields: color field for color, number fields for height/thickness/indent/endIndent
- [ ] T042 [US4] Create `example/lib/widgets/tools_panel/theming_tab/shared/style_editor.dart` — Reusable `ContextMenuStyle` editor composing: color fields for surfaceColor/shadowColor, offset fields for shadowOffset, number fields for shadowBlurRadius/shadowSpreadRadius/borderRadius/padding/maxWidth/maxHeight, plus embedded `MenuItemStyleEditor`, `MenuHeaderStyleEditor`, `MenuDividerStyleEditor`. Takes an `InlineStyleState` and `onChanged` callback
- [ ] T043 [US4] Create `example/lib/widgets/tools_panel/theming_tab/inline_style_tab.dart` — Renders `StyleEditor` bound to `PlaygroundState.inlineStyle`, scrollable
- [ ] T044 [US4] Create `example/lib/widgets/tools_panel/theming_tab/theming_tab.dart` — Sub-tabs container with `Tabs`: "Inline Style" (renders `InlineStyleTab`), "Inherited Theme" (placeholder), "Theme Extension" (placeholder)
- [ ] T045 [US4] Wire `ThemingTab` into the "Theming" tab of `ToolsPanel`, replacing the placeholder
- [ ] T046 [US4] Verify: change inline style properties → context menu appearance updates in real time for surface color, shadows, border radius, padding, and all nested sub-styles

**Checkpoint**: Inline style layer fully configurable — highest-precedence theme layer working

---

## Phase 7: User Story 5 — Inherited Theme (ContextMenuTheme) (Priority: P2)

**Goal**: "Inherited Theme" sub-tab with enable/disable switch that wraps the context menu in a `ContextMenuTheme` widget.

**Independent Test**: Toggle switch on → set surface color → menu changes → set inline style too → inline takes precedence → toggle switch off → inherited styles removed.

### Implementation for User Story 5

- [ ] T047 [US5] Create `example/lib/widgets/tools_panel/theming_tab/inherited_theme_tab.dart` — `Switch` at top to enable/disable, `StyleEditor` below bound to `PlaygroundState.inheritedTheme.style`, grayed out / disabled when switch is off
- [ ] T048 [US5] Update `PlaygroundArea` to conditionally wrap the context menu area in `ContextMenuTheme(style: inheritedStyle)` when `PlaygroundState.inheritedTheme.enabled` is true
- [ ] T049 [US5] Wire `InheritedThemeTab` into the "Inherited Theme" sub-tab of `ThemingTab`, replacing placeholder
- [ ] T050 [US5] Verify: enable inherited theme → set properties → menu reflects → enable inline style with same property → inline wins → disable inherited → styles revert

**Checkpoint**: Second-precedence theme layer working, demonstrating inline > inherited

---

## Phase 8: User Story 6 — Theme Extension (ThemeData.extensions) (Priority: P2)

**Goal**: "Theme Extension" sub-tab with enable/disable switch that adds `ContextMenuStyle` to `ThemeData.extensions`.

**Independent Test**: Toggle switch on → set surface color → menu changes → enable inherited and inline with same property → correct precedence (inline > inherited > extension) → toggle off → extension styles removed.

### Implementation for User Story 6

- [ ] T051 [US6] Create `example/lib/widgets/tools_panel/theming_tab/theme_extension_tab.dart` — `Switch` at top to enable/disable, `StyleEditor` below bound to `PlaygroundState.themeExtension.style`, grayed out when switch is off
- [ ] T052 [US6] Update `theme_bridge.dart` to accept optional `ContextMenuStyle` and include it in `ThemeData.extensions` when provided
- [ ] T053 [US6] Update `PlaygroundArea` to pass `PlaygroundState.buildThemeExtensionStyle()` to the Material theme bridge when `themeExtension.enabled` is true
- [ ] T054 [US6] Wire `ThemeExtensionTab` into the "Theme Extension" sub-tab of `ThemingTab`, replacing placeholder
- [ ] T055 [US6] Verify: enable all three layers with different surface colors → menu shows inline color → disable inline → shows inherited → disable inherited → shows extension → disable extension → shows fallback default

**Checkpoint**: Full three-layer theme precedence demonstrable (inline > inherited > extension > fallback)

---

## Phase 9: User Story 7 — Light and Dark Mode Toggle (Priority: P3)

**Goal**: Toggle the app between light and dark mode from the UI; both the shadcn_flutter shell and the context menu adapt.

**Independent Test**: Toggle to dark mode → entire app darkens → context menu fallback colors adapt → custom overrides persist → toggle back → light mode restored.

### Implementation for User Story 7

- [ ] T056 [US7] Add a light/dark mode toggle `Switch` to the app UI (e.g., in the app bar or top-right of playground screen), wired to `PlaygroundState.appSettings.setThemeMode()`
- [ ] T057 [US7] Update `app.dart` to read `themeMode` from `PlaygroundState` and pass to `ShadcnApp` (light theme via `ColorSchemes.lightZinc`, dark theme via `ColorSchemes.darkZinc`, or similar)
- [ ] T058 [US7] Update `theme_bridge.dart` to derive Material `ThemeData.brightness` and `ColorScheme` from the current mode
- [ ] T059 [US7] Verify: toggle modes → shadcn_flutter UI adapts → context menu default colors adapt → custom theme overrides persist across mode changes

**Checkpoint**: Light/dark mode fully functional

---

## Phase 10: User Story 8 — Configure MenuItem-Level Properties (Priority: P3)

**Goal**: Select a specific MenuItem in the tree and configure its individual properties (icon, label, shortcut, enabled, text color, value).

**Independent Test**: Select item in tree → change label → menu updates → toggle enabled off → item disabled → set icon → icon appears → set shortcut text → shortcut shows.

### Implementation for User Story 8

- [ ] T060 [US8] Enhance `EntryProperties` in `example/lib/widgets/tools_panel/structure_tab/entry_properties.dart` to add: icon picker (`IconPicker` from `common/`), shortcut key selector (text input for display label), text color (`ColorField`), trailing widget selector (`Select` dropdown with options: none, chevron, custom text — maps to `TrailingType` enum), and trailing text input when `customText` is selected. Ensure all `EntryNode` fields are now editable.
- [ ] T061 [US8] Update `EntryNode.toEntry()` in `example/lib/state/entry_node.dart` to properly convert shortcut label string to `SingleActivator` display and trailing widget to a `Widget`
- [ ] T062 [US8] Verify: select entry → edit each property → context menu item reflects changes in real time

**Checkpoint**: All per-item properties configurable — full API surface coverage

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Refinement, edge cases, and final validation

- [ ] T063 [P] Add empty state handling in `EmbeddedContextMenu` — when all entries are removed, show an empty container with minimum dimensions and a hint message in the playground area
- [ ] T064 [P] Add a "Reset to Defaults" button in the tools panel that resets `PlaygroundState` to initial defaults (supports future theme presets pattern)
- [ ] T065 [P] Ensure responsive layout: `ResizablePanel` has sensible min/max constraints, tools panel collapses gracefully on narrow windows
- [ ] T066 [P] Style the tools panel with consistent spacing, padding, and scroll behavior using shadcn_flutter `Card` and layout primitives
- [ ] T067 Run `flutter analyze --fatal-warnings` in `example/` and fix all warnings
- [ ] T068 Run `dart format .` in `example/` and fix formatting
- [ ] T069 Update `example/test/widget_test.dart` smoke test to work with the new `ShadcnApp` root
- [ ] T070 Final manual validation: run `cd example && flutter run -d chrome`, test all 8 user stories end-to-end

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational — MVP, must complete first
- **US2 (Phase 4)**: Depends on Foundational + US1 (needs playground area wired)
- **US3 (Phase 5)**: Depends on US2 (needs Structure tab wired)
- **US4 (Phase 6)**: Depends on US2 (needs ToolsPanel with Theming tab placeholder)
- **US5 (Phase 7)**: Depends on US4 (needs StyleEditor and ThemingTab)
- **US6 (Phase 8)**: Depends on US4 (needs StyleEditor and ThemingTab)
- **US7 (Phase 9)**: Depends on Foundational (can run after Phase 2, independent of tools panel)
- **US8 (Phase 10)**: Depends on US2 (needs entry properties panel)
- **Polish (Phase 11)**: Depends on all user stories

### User Story Dependencies

```
Phase 1: Setup
    ↓
Phase 2: Foundational
    ↓
Phase 3: US1 (Pre-rendered menu) ← MVP
    ↓
Phase 4: US2 (Entry tree editor)
   ↓ ↘
   ↓  Phase 5: US3 (Menu properties)
   ↓  Phase 10: US8 (Item-level properties)
   ↓
Phase 6: US4 (Inline style)
   ↓ ↘
   ↓  Phase 7: US5 (Inherited theme) ─┐
   ↓  Phase 8: US6 (Theme extension) ─┤
   ↓                                   ↓
   ↓               (Both can run in parallel)
   ↓
Phase 9: US7 (Light/dark mode) ← can start after Phase 2, independent
    ↓
Phase 11: Polish
```

### Parallel Opportunities

**Within Phase 2** (all [P] tasks): T007–T015 can all run in parallel, then T016–T019.

**After Phase 4 (US2)**:
- US3 (Phase 5) and US8 (Phase 10) can run in parallel (different files in structure_tab)
- US4 (Phase 6) can start simultaneously if different developer

**After Phase 6 (US4)**:
- US5 (Phase 7) and US6 (Phase 8) can run in parallel (different tab files, both use shared StyleEditor)

**US7 (Phase 9)** is largely independent — only needs Foundational and app.dart, can start as early as after Phase 2.

---

## Parallel Example: Phase 2 (Foundational)

```
# All state models in parallel:
Task: T007 — AppSettingsState
Task: T008 — EntryNode + EntryType
Task: T009 — MenuPropertiesState
Task: T010 — MenuItemStyleState
Task: T011 — MenuHeaderStyleState
Task: T012 — MenuDividerStyleState
Task: T013 — InlineStyleState
Task: T014 — InheritedThemeState
Task: T015 — ThemeExtensionState

# Then sequential (depends on above):
Task: T016 — PlaygroundState (composes all sub-states)

# Then parallel again:
Task: T017 — default_entries.dart
Task: T018 — theme_bridge.dart
Task: T019 — playground_screen.dart
```

## Parallel Example: After US2 Complete

```
# These can run in parallel:
Task: T033-T037 — US3 (Menu properties in Structure tab)
Task: T060-T062 — US8 (Item-level properties in Structure tab)
Task: T038-T046 — US4 (Inline style in Theming tab)
Task: T056-T059 — US7 (Light/dark mode in app shell)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001–T006)
2. Complete Phase 2: Foundational (T007–T019)
3. Complete Phase 3: User Story 1 (T020–T023)
4. **STOP and VALIDATE**: `flutter run -d chrome` → menu visible, interactable, non-dismissible
5. This alone demonstrates the core playground concept

### Incremental Delivery

1. Setup + Foundational → scaffold renders
2. US1 → interactable menu displayed (MVP!)
3. US2 → entry tree editor working → real-time CRUD on entries
4. US3 + US4 → menu properties + inline styling → appearance customization
5. US5 + US6 → full theme precedence chain demonstrable
6. US7 → light/dark mode toggle
7. US8 → per-item property editing
8. Polish → edge cases, formatting, final validation

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- No test tasks included (not requested; manual visual testing via Chrome)
- Commit after each phase checkpoint for safe rollback points
- The `shadcn_flutter` component reference is at `specs/002-example-playground/shadcn_flutter_reference.md` (57k lines) — consult for exact widget APIs during implementation
- The context menu package source is in `lib/` — read but do not modify
