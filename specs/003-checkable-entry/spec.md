# Feature Specification: Checkable/Toggle Menu Entry

**Feature Branch**: `003-checkable-entry`
**Created**: 2026-03-02
**Status**: Draft
**Input**: User description: "Implement a checkable/toggle entry type with on/off state (e.g., 'Show grid'). Entries should allow toggle without closing menu after each toggle. Includes a ready-to-use component widget."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Toggle a Setting Without Closing the Menu (Priority: P1)

A developer adds checkable entries to a context menu (e.g., "Show grid", "Snap to guides", "Auto-save"). When the user right-clicks and toggles one of these entries, the menu stays open so they can toggle additional entries without re-opening the menu each time. The check indicator updates immediately to reflect the new state.

**Why this priority**: This is the core value proposition — toggle entries that keep the menu open. Without this, the feature has no reason to exist.

**Independent Test**: Can be fully tested by creating a context menu with a single checkable entry, toggling it, and verifying the menu stays open and the visual state updates.

**Acceptance Scenarios**:

1. **Given** a context menu with a checkable entry in the "off" state, **When** the user clicks the entry, **Then** the entry toggles to the "on" state and displays a check indicator, and the menu remains open.
2. **Given** a context menu with a checkable entry in the "on" state, **When** the user clicks the entry, **Then** the entry toggles to the "off" state and the check indicator is removed, and the menu remains open.
3. **Given** a context menu with multiple checkable entries, **When** the user toggles several entries in sequence, **Then** each entry updates independently and the menu remains open throughout.

---

### User Story 2 - Developer Configures Checkable Entries Declaratively (Priority: P1)

A developer creates checkable menu entries by providing a label, an initial checked state, and an `onToggle` callback. The API follows the same patterns as the existing `MenuItem` — supporting optional icons, keyboard shortcuts, trailing widgets, constraints, and disabled state.

**Why this priority**: Equally critical as Story 1 — the developer-facing API must be clean and consistent with the existing entry system for the feature to be usable.

**Independent Test**: Can be tested by instantiating a `CheckableMenuItem` with various configurations and verifying that all properties are correctly applied in the rendered widget.

**Acceptance Scenarios**:

1. **Given** a developer creating a checkable entry, **When** they provide a label and `onToggle` callback, **Then** the entry renders with the label and an unchecked indicator by default.
2. **Given** a developer creating a checkable entry with `checked: true`, **When** the menu renders, **Then** the entry displays with the check indicator in the "on" position.
3. **Given** a developer creating a checkable entry with `enabled: false`, **When** the user attempts to click the entry, **Then** the entry does not toggle and appears visually dimmed.

---

### User Story 3 - Keyboard Navigation for Checkable Entries (Priority: P2)

A user navigates the context menu with arrow keys and reaches a checkable entry. Pressing Space or Enter toggles the entry's checked state without closing the menu, consistent with keyboard accessibility standards.

**Why this priority**: Keyboard navigation is already supported by the menu system. Checkable entries must participate in it correctly, but it extends existing behavior rather than introducing new core value.

**Independent Test**: Can be tested by focusing a checkable entry via keyboard, pressing Space/Enter, and verifying the state toggles without the menu closing.

**Acceptance Scenarios**:

1. **Given** a checkable entry is focused via keyboard navigation, **When** the user presses Space or Enter, **Then** the entry toggles its checked state and the menu remains open.
2. **Given** a checkable entry with `enabled: false` is focused, **When** the user presses Space or Enter, **Then** nothing happens.

---

### User Story 4 - Abstract Checkable Entry Type for Custom Implementations (Priority: P2)

A developer wants to build a custom checkable entry with a unique visual design. They subclass `ContextMenuCheckableItem` and override the `builder` method to provide their own widget, while inheriting toggle-without-close behavior and state management.

**Why this priority**: The package's architecture encourages subclassing for custom entries. Providing an abstract checkable base class enables extensibility, but the ready-to-use component (Story 2) delivers value on its own.

**Independent Test**: Can be tested by creating a custom subclass of `ContextMenuCheckableItem`, providing a custom `builder`, and verifying the toggle behavior and state management work correctly.

**Acceptance Scenarios**:

1. **Given** a developer creates a subclass of `ContextMenuCheckableItem`, **When** they override only the `builder` method, **Then** the toggle-without-close behavior, `onToggle` callback, and state management still work correctly.
2. **Given** a custom checkable entry subclass, **When** the user interacts with it in the menu, **Then** it participates in keyboard navigation and focus management identically to built-in entries.

---

### Edge Cases

- What happens when a checkable entry is inside a submenu? The toggle-without-close behavior still applies — the submenu and its parent menu both stay open.
- What happens when the developer changes the `checked` state externally while the menu is open? The entry reflects the new state because a new `ContextMenu` would be constructed with updated entries.
- What happens when a checkable entry also has a submenu? Checkable entries with submenus are not supported — a checkable entry represents a leaf toggle action. The submenu constructor is not available on the checkable entry type.

## Requirements *(mandatory)*

### Functional Requirements

#### Type Hierarchy Refactor

- **FR-001**: The package MUST introduce a new abstract intermediate class `ContextMenuInteractiveEntry<T>` that extends `ContextMenuEntry<T>` and holds shared interactive-entry behavior: `enabled`, `autoHandleFocus`, `handleItemSelection`, and focus integration. Both the existing selectable entry type (`ContextMenuItem<T>`) and the new checkable entry type (`ContextMenuCheckableItem<T>`) MUST extend this shared base.
- **FR-002**: The existing `ContextMenuItem<T>` MUST be refactored to extend the new shared interactive base class, retaining its current `value`, `items`, `onSelected`, and submenu-related behavior.
- **FR-003**: `MenuEntryWidget` MUST be updated to check for the shared interactive base type (instead of `ContextMenuItem`) for focus handling, keyboard shortcuts, and mouse interaction.

#### Checkable Entry

- **FR-004**: The package MUST provide an abstract base class `ContextMenuCheckableItem<T>` that extends the shared interactive base class and encapsulates toggle-without-close behavior.
- **FR-005**: `ContextMenuCheckableItem` MUST accept a `checked` boolean parameter indicating the current on/off state.
- **FR-006**: `ContextMenuCheckableItem` MUST accept an `onToggle` callback (`ValueChanged<bool>`) that is invoked with the new checked state when the entry is toggled.
- **FR-007**: When a checkable entry is selected (via click or keyboard), the menu MUST remain open instead of closing.
- **FR-008**: The `onToggle` callback MUST be invoked with the negated value of the current `checked` state upon selection.
- **FR-009**: `ContextMenuCheckableItem` MUST NOT inherit or expose `value`, `onSelected`, or submenu-related properties — these belong exclusively to `ContextMenuItem`.
- **FR-010**: The package MUST provide a concrete `CheckableMenuItem<T>` component that extends `ContextMenuCheckableItem<T>` and is ready to use out of the box.
- **FR-011**: `CheckableMenuItem` MUST accept an optional `icon` parameter. When `checked` is `true`: if a custom `icon` is provided, it is displayed in the leading icon area as the checked indicator; if no custom `icon` is provided, a default checkmark icon is displayed. When `checked` is `false`, the leading icon area shows empty space regardless of `icon`.
- **FR-012**: `CheckableMenuItem` MUST support visual properties: `label`, `icon` (optional custom check indicator), `shortcut`, `trailing`, `constraints`, `textColor`, and `enabled`.
- **FR-013**: When `enabled` is `false`, the entry MUST NOT toggle on interaction and MUST appear visually dimmed.
- **FR-014**: Checkable entries MUST participate in existing keyboard navigation (arrow keys for focus, Space/Enter for toggle).
- **FR-015**: `ContextMenuCheckableItem`, `CheckableMenuItem`, and the new shared interactive base class MUST all be exported through the package barrel file.

### Key Entities

- **ContextMenuInteractiveEntry\<T\>**: New abstract intermediate class between `ContextMenuEntry<T>` and both `ContextMenuItem<T>` / `ContextMenuCheckableItem<T>`. Holds `enabled`, `autoHandleFocus`, `handleItemSelection` (abstract), and focus-related contracts.
- **ContextMenuItem\<T\>**: Refactored to extend the shared interactive base. Retains `value`, `items`, `onSelected`, and submenu behavior.
- **ContextMenuCheckableItem\<T\>**: Abstract base class for checkable/toggle entries. Extends the shared interactive base. Holds `checked` state, `onToggle` callback, and overrides selection to toggle without closing. Does not expose `value`, `onSelected`, or submenu properties.
- **CheckableMenuItem\<T\>**: Concrete, ready-to-use checkable entry component. Extends `ContextMenuCheckableItem<T>`. Renders a check indicator, label, optional shortcut, trailing widget, with styling consistent with `MenuItem`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can toggle a checkable entry's on/off state with a single click or keypress without the menu closing.
- **SC-002**: Developers can create a checkable menu entry with no more code than creating a standard `MenuItem` (same number of required parameters plus `onToggle`).
- **SC-003**: The checkable entry visually indicates its current state (checked vs. unchecked) immediately upon toggle.
- **SC-004**: Developers can subclass `ContextMenuCheckableItem` and provide a fully custom visual while retaining toggle behavior with zero additional boilerplate.
- **SC-005**: All existing menu features (keyboard navigation, focus management, disabled state, submenu interaction on other entries) continue to work correctly with checkable entries present in the menu.
- **SC-006**: The package passes static analysis (`flutter analyze --fatal-warnings`) and format checks (`dart format --set-exit-if-changed .`) with the new entry types included.

## Clarifications

### Session 2026-03-02

- Q: Should `ContextMenuCheckableItem` extend `ContextMenuItem` (inheriting `value`/`items`/`onSelected` baggage), extend `ContextMenuEntry` directly (losing focus/keyboard integration), or use a new shared intermediate class? → A: Introduce a shared intermediate abstract class between `ContextMenuEntry` and both `ContextMenuItem`/`ContextMenuCheckableItem` — extracting `enabled`, `autoHandleFocus`, `handleItemSelection`, and focus handling. Cleanest hierarchy; requires refactoring `ContextMenuItem` and `MenuEntryWidget`.
- Q: When a developer provides a custom `icon` on `CheckableMenuItem`, should the check indicator replace it, coexist alongside it, or should the developer choose? → A: Developer chooses — `icon` parameter is optional. When provided, it replaces the default checkmark as the "checked" indicator. When absent, the standard checkmark is used. In both cases, the leading area is empty when unchecked.

## Assumptions

- The `checked` state is owned by the developer's application code, not by the menu entry itself. The entry displays whatever `checked` value is provided. The `onToggle` callback is the mechanism for the developer to update their state and rebuild the menu with the new value.
- The default check indicator uses a standard checkmark icon (e.g., `Icons.check`) consistent with platform conventions. Developers can provide a custom `icon` parameter on `CheckableMenuItem` to replace the default checkmark, or subclass `ContextMenuCheckableItem` for fully custom layouts.
- The `handleItemSelection` method on the shared interactive base will be implemented differently by `ContextMenuItem` (select and close) and `ContextMenuCheckableItem` (toggle and stay open).
- The refactor of `ContextMenuItem` to extend the new shared base is an internal restructuring — the public API surface of `ContextMenuItem` remains unchanged (no breaking change for existing users).
