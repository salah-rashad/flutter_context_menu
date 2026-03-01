# Tasks: Checkable/Toggle Menu Entry

**Input**: Design documents from `/specs/003-checkable-entry/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in feature specification. No test tasks included.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: No new project initialization needed — this is an existing package. Phase skipped.

---

## Phase 2: Foundational (Type Hierarchy Refactor)

**Purpose**: Extract shared interactive base class and refactor `ContextMenuItem` to extend it. This MUST be complete before any checkable entry work can begin.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete. This phase refactors the existing type hierarchy without adding checkable entry functionality.

- [x] T001 Create `ContextMenuInteractiveEntry<T>` abstract base class in `lib/src/core/models/context_menu_interactive_entry.dart`. Extract `enabled` field and `autoHandleFocus` getter from `ContextMenuItem`. Add abstract `handleItemSelection(BuildContext, ContextMenuState<T>)` method. Override `builder` signature to include optional `FocusNode` parameter. Use `abstract base class` modifier. Import `ContextMenuEntry` and `ContextMenuState`. See data-model.md entity definition and contracts/public-api.md for exact signatures.

- [x] T002 Refactor `ContextMenuItem<T>` in `lib/src/core/models/context_menu_item.dart` to extend `ContextMenuInteractiveEntry<T>` instead of `ContextMenuEntry<T>`. Remove `enabled` field and `autoHandleFocus` getter (now inherited). Pass `enabled` to `super.enabled` in both constructors. Add `@override` to `handleItemSelection`. Import the new interactive entry file. Ensure `handleItemSelection` implementation, `_toggleSubmenu`, `value`, `items`, `onSelected`, `isSubmenuItem`, and `builder` remain unchanged.

- [x] T003 Update `defaultMenuItemShortcuts` in `lib/src/core/utils/shortcuts/menu_item_shortcuts.dart`. Change parameter type from `ContextMenuItem item` to `ContextMenuInteractiveEntry item`. Add `is ContextMenuItem` guard around the arrow-right submenu logic (line 17-28). Space/Enter/NumpadEnter handlers remain unchanged — they call `item.handleItemSelection()` which exists on the base class.

- [x] T004 Update `MenuEntryWidget<T>` in `lib/src/widgets/menu_entry_widget.dart`. Change `build` method type checks from `ContextMenuItem<T>` to `ContextMenuInteractiveEntry<T>` (lines 48-49). In `_onMouseEnter`: change outer check to `ContextMenuInteractiveEntry<T>` for enabled/focus gating, add inner `is ContextMenuItem<T>` check for submenu-specific logic (`isSubmenuItem`, `showSubmenu`, `closeSubmenu`). In `_onMouseExit`: change outer check to `ContextMenuInteractiveEntry<T>`, add inner `is ContextMenuItem` check for `isOpened` submenu logic. See research.md R3 for all 6 locations and their specific changes.

- [x] T005 Add new export to barrel file `lib/flutter_context_menu.dart`: `export 'src/core/models/context_menu_interactive_entry.dart';`

- [x] T006 Run `flutter analyze --fatal-warnings` and `dart format --set-exit-if-changed .` to verify the refactor introduces no regressions. Verify the example app builds successfully: `cd example && flutter build`.

**Checkpoint**: Type hierarchy refactor complete. `ContextMenuItem` extends `ContextMenuInteractiveEntry`. `MenuEntryWidget` checks for `ContextMenuInteractiveEntry`. All existing functionality preserved. Ready for checkable entry implementation.

---

## Phase 3: User Story 1 & 2 - Core Toggle Behavior and Declarative API (Priority: P1) 🎯 MVP

**Goal**: Implement `ContextMenuCheckableItem<T>` (abstract) and `CheckableMenuItem<T>` (concrete) so developers can add checkable entries that toggle without closing the menu.

**Independent Test**: Create a context menu in the example app with checkable entries ("Show grid", "Snap to guides"). Toggle them and verify: check indicator toggles, menu stays open, `onToggle` callback fires with correct value, disabled entries don't toggle.

**Note**: User Stories 1 and 2 are combined in this phase because they are tightly coupled — the toggle behavior (US1) and the declarative API (US2) are implemented in the same classes.

### Implementation

- [ ] T007 [P] [US1] Create `ContextMenuCheckableItem<T>` abstract base class in `lib/src/core/models/context_menu_checkable_item.dart`. Extend `ContextMenuInteractiveEntry<T>`. Add `checked` (bool, default false) and `onToggle` (`ValueChanged<bool>?`) fields. Implement `handleItemSelection`: if `!enabled` return; call `onToggle?.call(!checked)`. Do NOT call `Navigator.pop` — menu stays open. Leave `builder` abstract. Single constructor only (no `.submenu()`). Use `abstract base class` modifier. See data-model.md and contracts/public-api.md for exact API.

- [ ] T008 [P] [US2] Create `CheckableMenuItem<T>` concrete component in `lib/src/components/checkable_menu_item.dart`. Extend `ContextMenuCheckableItem<T>`. Add properties: `icon` (Widget?, optional custom check indicator), `label` (Widget, required), `shortcut` (SingleActivator?), `trailing` (Widget?), `constraints` (BoxConstraints?), `textColor` (Color?). Implement `builder` method matching `MenuItem` layout and theming: leading icon area shows `icon ?? Icon(Icons.check)` when `checked` is true, empty `SizedBox` when false. Use same color scheme, text styles, focus/disabled states, InkWell, and Row structure as `MenuItem.builder` in `lib/src/components/menu_item.dart`. Use `final class` modifier.

- [ ] T009 [US1] Add new exports to barrel file `lib/flutter_context_menu.dart`: `export 'src/core/models/context_menu_checkable_item.dart';` and `export 'src/components/checkable_menu_item.dart';`

- [ ] T010 [US1] Add checkable menu entries to the example app in `example/lib/pages/menu_items.dart` (or appropriate demo page). Add 2-3 `CheckableMenuItem` entries (e.g., "Show grid", "Snap to guides", "Auto-save") with state management via `StatefulWidget.setState`. Include one entry with a custom icon, one disabled entry. Also add a checkable entry inside a submenu to verify toggle-without-close works in nested menus. Verify toggle behavior and menu-stays-open behavior manually.

- [ ] T011 [US1] Run `flutter analyze --fatal-warnings` and `dart format --set-exit-if-changed .` to verify no warnings. Run the example app and manually test: toggle on/off, multiple toggles without menu closing, disabled entry, custom icon indicator.

**Checkpoint**: MVP complete. Checkable entries toggle without closing the menu. Developers can create them declaratively with `CheckableMenuItem`. Example app demonstrates the feature.

---

## Phase 4: User Story 3 - Keyboard Navigation (Priority: P2)

**Goal**: Ensure checkable entries work correctly with keyboard navigation — Space/Enter toggles without closing.

**Independent Test**: Open a context menu with checkable entries, navigate to one with arrow keys, press Space or Enter, verify toggle happens and menu stays open.

### Implementation

- [ ] T012 [US3] Verify keyboard navigation works with checkable entries in `lib/src/widgets/menu_entry_widget.dart` and `lib/src/core/utils/shortcuts/menu_item_shortcuts.dart`. The foundational refactor (Phase 2, T003-T004) already changed type checks to `ContextMenuInteractiveEntry`, so Space/Enter/NumpadEnter should already call `handleItemSelection` on checkable entries. Manually test with the example app: focus a checkable entry via arrow keys, press Space/Enter, verify toggle and menu stays open. If issues found, fix in the relevant files.

**Checkpoint**: Keyboard navigation works for checkable entries. Space/Enter toggles, arrow keys navigate, disabled entries ignore input.

---

## Phase 5: User Story 4 - Abstract Checkable Entry for Custom Implementations (Priority: P2)

**Goal**: Verify that `ContextMenuCheckableItem` is properly subclassable and that custom implementations inherit toggle behavior.

**Independent Test**: Create a custom subclass of `ContextMenuCheckableItem` in the example app with a unique visual (e.g., switch-style toggle). Verify toggle-without-close works and keyboard navigation functions.

### Implementation

- [ ] T013 [US4] Create a custom checkable entry example in `example/lib/entries/` (e.g., `custom_checkable_menu_item.dart`). Subclass `ContextMenuCheckableItem`, override only `builder` with a custom visual (e.g., a row with label + switch indicator). Add it to the example app demo page. Verify toggle behavior, keyboard navigation, and focus management work correctly without any extra boilerplate. This validates the extensibility contract from spec US4.

**Checkpoint**: Custom subclassing works. Developers can create custom checkable entries by overriding `builder` only.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final quality checks and version bump

- [ ] T014 [P] Update `pubspec.yaml` version from 0.4.2 to 0.5.0 (MINOR bump — new public symbols added per Constitution II)
- [ ] T015 [P] Update `CHANGELOG.md` with 0.5.0 entry describing: new `ContextMenuInteractiveEntry` base class, new `ContextMenuCheckableItem` and `CheckableMenuItem` components, type hierarchy refactor (non-breaking)
- [ ] T016 Run full quality gate: `flutter analyze --fatal-warnings`, `dart format --set-exit-if-changed .`, `cd example && flutter build`. Verify example app smoke test passes: `cd example && flutter test`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Foundational (Phase 2)**: No dependencies — starts immediately. BLOCKS all user stories.
- **User Story 1 & 2 (Phase 3)**: Depends on Phase 2 completion. This is the MVP.
- **User Story 3 (Phase 4)**: Depends on Phase 3 (needs checkable entries to exist for keyboard testing). Mostly verification — may require no code changes if Phase 2 refactor is correct.
- **User Story 4 (Phase 5)**: Depends on Phase 3 (needs `ContextMenuCheckableItem` to exist for subclassing). Independent of Phase 4.
- **Polish (Phase 6)**: Depends on all user stories being complete.

### User Story Dependencies

- **US1 & US2 (P1)**: Combined — tightly coupled. Can start after Phase 2.
- **US3 (P2)**: Depends on US1/US2 (needs checkable entries). Mostly verification.
- **US4 (P2)**: Depends on US1/US2 (needs abstract base). Independent of US3. Can run in parallel with US3.

### Within Each Phase

- T001 must complete before T002 (T002 depends on the new base class)
- T002 must complete before T003 and T004 (they reference the new type)
- T003 and T004 can run in parallel (different files)
- T005 can run in parallel with T003/T004
- T006 must run after T001-T005 (validation gate)
- T007 and T008 can run in parallel [P] (different files)
- T009 depends on T007 and T008 (exports require the files)
- T010 depends on T009 (example needs exports)

### Parallel Opportunities

- T003 + T004 + T005: Three different files, no inter-dependencies
- T007 + T008: Abstract model and concrete component in different files
- T013 + T012: US4 and US3 can run in parallel after Phase 3
- T014 + T015: Version bump and changelog in different files

---

## Parallel Example: Phase 2

```bash
# After T002 completes, launch T003 + T004 + T005 together:
Task: "Update defaultMenuItemShortcuts in lib/src/core/utils/shortcuts/menu_item_shortcuts.dart"
Task: "Update MenuEntryWidget in lib/src/widgets/menu_entry_widget.dart"
Task: "Add export to barrel file lib/flutter_context_menu.dart"
```

## Parallel Example: Phase 3

```bash
# After Phase 2, launch T007 + T008 together:
Task: "Create ContextMenuCheckableItem in lib/src/core/models/context_menu_checkable_item.dart"
Task: "Create CheckableMenuItem in lib/src/components/checkable_menu_item.dart"
```

---

## Implementation Strategy

### MVP First (Phase 2 + Phase 3)

1. Complete Phase 2: Type hierarchy refactor (T001-T006)
2. Complete Phase 3: Checkable entry model + component + example (T007-T011)
3. **STOP and VALIDATE**: Toggle entries in example app, verify menu stays open
4. This delivers US1 + US2 — the core feature is usable

### Incremental Delivery

1. Phase 2 → Refactor complete, existing behavior preserved
2. Phase 3 → MVP: checkable entries work with mouse → Demo-ready
3. Phase 4 → Keyboard navigation verified → Accessibility complete
4. Phase 5 → Custom subclass example → Extensibility validated
5. Phase 6 → Version bump, changelog → Publish-ready

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- US1 and US2 are combined in Phase 3 because they share the same implementation (the classes that deliver toggle behavior ARE the declarative API)
- US3 (keyboard) is primarily a verification phase — the foundational refactor in Phase 2 should handle most of the keyboard integration automatically
- No unit tests included (not requested in spec; project relies on manual testing via example app and smoke test)
- Commit after each task or logical group
- Stop at any checkpoint to validate independently
