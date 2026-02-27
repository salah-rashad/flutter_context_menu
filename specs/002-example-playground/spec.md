# Feature Specification: Example Playground

**Feature Branch**: `002-example-playground`
**Created**: 2026-02-26
**Status**: Draft
**Input**: User description: "Rebuild the entire example project as an interactive playground for exploring and testing all context menu APIs and features."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View and Interact with a Pre-Rendered Context Menu (Priority: P1)

As a developer exploring the package, I open the playground app and immediately see a context menu rendered at the center of the playground area. The menu displays with default configuration and is fully interactable — I can hover items, open/close submenus, and see keyboard navigation — but it cannot be dismissed or closed entirely.

**Why this priority**: The always-visible context menu is the core of the playground. Without it, no other feature has meaning.

**Independent Test**: Can be fully tested by launching the app and verifying the context menu is visible, interactable (hover states, submenu open/close), and cannot be dismissed.

**Acceptance Scenarios**:

1. **Given** the app is launched, **When** the playground screen loads, **Then** a context menu with default entries (a header, several items with icons/shortcuts, a divider, a submenu item) is rendered at the center of the playground area.
2. **Given** the context menu is displayed, **When** I hover over items, **Then** focus/hover states are visually applied.
3. **Given** the context menu has a submenu item, **When** I hover or arrow-key into the submenu item, **Then** the submenu opens relative to the parent item. **When** I move away, **Then** the submenu closes.
4. **Given** the context menu is displayed, **When** I click outside it or press Escape, **Then** the menu remains visible and is not dismissed.
5. **Given** the context menu is displayed, **When** I select an item, **Then** a feedback indicator (e.g., a snackbar or log area in the playground) shows the selected value, but the menu stays open.

---

### User Story 2 - Modify Menu Entries via the Tools Panel (Priority: P1)

As a developer, I use the tools panel on the left side of the screen to add, remove, and reorder menu entries (items, headers, dividers, submenus). The context menu in the playground updates in real time as I make changes.

**Why this priority**: Manipulating menu entries is the most fundamental configuration and directly exercises the core data model.

**Independent Test**: Can be tested by adding/removing entries in the tools panel and verifying the context menu reflects the changes immediately.

**Acceptance Scenarios**:

1. **Given** the tools panel is visible, **When** I view the menu entries section, **Then** I see a tree view of the current menu entries showing their type and label.
2. **Given** the tree view of entries, **When** I add a new MenuItem with a label, **Then** the context menu updates to include the new item.
3. **Given** the tree view of entries, **When** I add a MenuHeader or MenuDivider, **Then** the context menu updates to include the new entry.
4. **Given** a MenuItem in the tree, **When** I expand it and toggle "submenu" on, **Then** the item becomes a submenu parent and I can add child entries under it.
5. **Given** the tree view, **When** I remove an entry, **Then** the context menu updates to exclude it.
6. **Given** the tree view, **When** I reorder entries via drag-and-drop or move controls, **Then** the context menu reflects the new order.

---

### User Story 3 - Configure Menu Properties via the Tools Panel (Priority: P2)

As a developer, I use the tools panel to adjust ContextMenu-level properties such as `clipBehavior`, `respectPadding`, and `maxWidth`/`maxHeight` constraints. Each change is reflected instantly on the pre-rendered context menu.

**Why this priority**: These are top-level menu properties that affect layout and behavior. Important but secondary to entry manipulation.

**Independent Test**: Can be tested by toggling each property and observing the context menu's behavior and appearance change.

**Acceptance Scenarios**:

1. **Given** the tools panel properties section, **When** I toggle `respectPadding` off, **Then** the context menu behavior updates accordingly.
2. **Given** the tools panel, **When** I change `clipBehavior` via a dropdown, **Then** the context menu reflects the new clip behavior.
3. **Given** the tools panel, **When** I adjust `maxWidth` or `maxHeight` sliders, **Then** the context menu dimensions constrain accordingly.

---

### User Story 4 - Apply Direct Inline Style Overrides (Priority: P2)

As a developer, I use the "Inline Style" tab in the tools panel to configure `ContextMenuStyle` properties that are passed directly to the `ContextMenu` instance. This includes surface color, shadow properties, border radius, padding, and nested `MenuItemStyle`, `MenuHeaderStyle`, and `MenuDividerStyle` overrides.

**Why this priority**: Inline style is the highest-precedence styling layer and the most common customization path.

**Independent Test**: Can be tested by changing any inline style property and verifying the context menu's appearance updates.

**Acceptance Scenarios**:

1. **Given** the Inline Style tab, **When** I change the surface color, **Then** the menu background updates immediately.
2. **Given** the Inline Style tab, **When** I adjust shadow properties (color, offset, blur, spread), **Then** the menu shadow updates.
3. **Given** the Inline Style tab, **When** I modify `MenuItemStyle` properties (background, focus colors, text colors, icon size, height, border radius), **Then** menu items reflect the changes.
4. **Given** the Inline Style tab, **When** I modify `MenuHeaderStyle` properties (text style, color, padding), **Then** menu headers reflect the changes.
5. **Given** the Inline Style tab, **When** I modify `MenuDividerStyle` properties (color, height, thickness, indent), **Then** menu dividers reflect the changes.

---

### User Story 5 - Apply Inherited Theme Overrides via ContextMenuTheme (Priority: P2)

As a developer, I use the "Inherited Theme" tab in the tools panel to configure a `ContextMenuTheme` widget wrapper. A switch controls whether the theme is applied. When enabled, I can set all `ContextMenuStyle` properties that would be provided via `ContextMenuTheme` in real code.

**Why this priority**: The inherited theme is the second-highest precedence layer and a key theming mechanism for the package.

**Independent Test**: Can be tested by enabling the inherited theme switch, setting properties, and verifying the context menu reflects them (and that inline overrides still take precedence).

**Acceptance Scenarios**:

1. **Given** the Inherited Theme tab, **When** the switch is off, **Then** no inherited theme is applied.
2. **Given** the Inherited Theme tab, **When** I toggle the switch on and set a surface color, **Then** the context menu background changes.
3. **Given** both Inherited Theme and Inline Style have surface color set, **When** I view the menu, **Then** the inline style takes precedence.

---

### User Story 6 - Apply Global Theme Extension Overrides (Priority: P2)

As a developer, I use the "Theme Extension" tab in the tools panel to configure a `ContextMenuStyle` that would be added to `ThemeData.extensions`. A switch controls whether the extension is active. When enabled, I can set all `ContextMenuStyle` properties.

**Why this priority**: The ThemeExtension is the lowest custom precedence layer. Important for demonstrating the full theme resolution chain.

**Independent Test**: Can be tested by enabling the extension switch, setting properties, and verifying they appear only when higher-precedence layers don't override them.

**Acceptance Scenarios**:

1. **Given** the Theme Extension tab, **When** the switch is off, **Then** no theme extension is applied.
2. **Given** the Theme Extension tab, **When** I toggle the switch on and set a surface color (with no inherited or inline override), **Then** the context menu background changes.
3. **Given** all three layers have surface color set, **When** I view the menu, **Then** inline > inherited > extension precedence is respected.
4. **Given** the Theme Extension tab has properties set, **When** I toggle it off, **Then** those properties stop affecting the menu.

---

### User Story 7 - Toggle Light and Dark Mode (Priority: P3)

As a developer, I toggle the app between light and dark mode to observe how the context menu adapts to different color schemes and how my custom theme settings interact with each mode.

**Why this priority**: Important for validating theme behavior but secondary to the actual theming controls.

**Independent Test**: Can be tested by toggling the mode switch and observing the app and context menu theme changes.

**Acceptance Scenarios**:

1. **Given** the app is in light mode, **When** I toggle to dark mode, **Then** the entire app UI (including the playground shell built with shadcn_flutter) and the context menu adapt to dark colors.
2. **Given** custom theme overrides are applied, **When** I switch modes, **Then** overrides persist and resolve against the new base theme.

---

### User Story 8 - Configure MenuItem-Level Properties (Priority: P3)

As a developer, I select a specific MenuItem in the entry tree and configure its individual properties: icon, label text, shortcut indicator, trailing widget, enabled/disabled state, text color override, and value.

**Why this priority**: Per-item configuration is useful for testing specific API features but less fundamental than overall menu and theme configuration.

**Independent Test**: Can be tested by selecting an item, changing its properties, and verifying the changes on the rendered menu.

**Acceptance Scenarios**:

1. **Given** I select a MenuItem in the tree, **When** I change its label, **Then** the label updates on the rendered menu.
2. **Given** I select a MenuItem, **When** I toggle `enabled` off, **Then** the item appears in its disabled style.
3. **Given** I select a MenuItem, **When** I set an icon from a picker, **Then** the icon appears on the item.
4. **Given** I select a MenuItem, **When** I set a shortcut indicator (e.g., Ctrl+C), **Then** the shortcut text appears on the item.

---

### Edge Cases

- What happens when all entries are removed? The context menu should render as an empty container with minimum dimensions.
- What happens when deeply nested submenus exceed the playground bounds? The menu's boundary positioning should handle this automatically.
- What happens when conflicting theme values are set across multiple layers? The documented precedence chain (inline > inherited > extension > fallback) should be visibly demonstrated.
- What happens on window resize? The playground layout should be responsive and the context menu should reposition as needed.
- What happens when a very long label or many entries are added? The menu should respect maxWidth/maxHeight constraints and scroll or clip as configured.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST display a split layout with a tools panel on the left and a playground area occupying the remaining space. The tools panel MUST use a two-level tab structure: a top-level "Structure" tab (containing entries tree editor and menu properties) and a top-level "Theming" tab (containing sub-tabs for Inline Style, Inherited Theme, and Theme Extension).
- **FR-002**: The playground area MUST render a single context menu at its center using the current configuration state.
- **FR-003**: The pre-rendered context menu MUST be fully interactable (hover, focus, keyboard navigation, submenu open/close) but MUST NOT be dismissible (clicking outside, pressing Escape, or selecting an item must not close the root menu).
- **FR-004**: The tools panel MUST provide a tree-based editor for managing menu entries (MenuItem, MenuHeader, MenuDivider) with add, remove, and reorder capabilities.
- **FR-005**: The tools panel MUST expose `ContextMenu`-level properties (`clipBehavior`, `respectPadding`) as interactive controls (dropdowns, toggles). Note: `maxWidth`/`maxHeight` are `ContextMenuStyle` properties and are configured via the three theme tabs (FR-006/007/008), not here. The `shortcuts` map is out of scope for the playground (complex key binding UI).
- **FR-006**: The tools panel MUST provide an "Inline Style" tab for configuring all `ContextMenuStyle` properties and nested style objects (`MenuItemStyle`, `MenuHeaderStyle`, `MenuDividerStyle`).
- **FR-007**: The tools panel MUST provide an "Inherited Theme" tab with an enable/disable switch that wraps the context menu in a `ContextMenuTheme` widget when enabled.
- **FR-008**: The tools panel MUST provide a "Theme Extension" tab with an enable/disable switch that adds a `ContextMenuStyle` to `ThemeData.extensions` when enabled. The playground area achieves this by wrapping its content in a `MaterialApp` widget (configured with `theme`, `darkTheme`, and `themeMode`) whose `ThemeData.extensions` includes the active `ContextMenuStyle` extension.
- **FR-009**: All three theme tabs MUST expose the same full set of `ContextMenuStyle` properties so users can observe precedence behavior.
- **FR-010**: Changes in the tools panel MUST be reflected on the pre-rendered context menu in real time (no manual refresh or rebuild needed).
- **FR-011**: The app MUST support light and dark mode toggling, and the toggle MUST be accessible from the app UI.
- **FR-012**: The app MUST be built using the `shadcn_flutter` package ([GitHub](https://github.com/sunarya-thito/shadcn_flutter)) for the playground shell UI (tools panel, layout, controls, all UI elements outside the playground content area). Material widgets MUST only be used within the playground content area to simulate real-world context menu usage. Component reference: `specs/002-example-playground/shadcn_flutter_reference.md`.
- **FR-013**: The tree editor MUST allow configuring individual MenuItem properties: label, icon, shortcut indicator, trailing widget, enabled state, text color, and value.
- **FR-014**: The tree editor MUST allow converting a MenuItem to/from a submenu item and editing child entries within it.
- **FR-015**: When an item is selected in the context menu, the app MUST display feedback (selected value) without dismissing the menu.
- **FR-016**: The app architecture MUST be structured to accommodate future features: pre-defined theme presets and code export from current configuration.

### Key Entities

- **PlaygroundState**: Central configuration state holding the current menu entries list, ContextMenu properties, inline ContextMenuStyle, inherited theme ContextMenuStyle (with enabled flag), theme extension ContextMenuStyle (with enabled flag), and app brightness mode.
- **EntryNode**: Represents a menu entry in the tree editor, holding entry type (item/header/divider), all configurable properties for that type, and child EntryNodes for submenus.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can launch the playground and see a fully rendered, interactable context menu within 3 seconds of app start.
- **SC-002**: All public API properties of `ContextMenu`, `ContextMenuStyle`, `MenuItemStyle`, `MenuHeaderStyle`, `MenuDividerStyle`, `MenuItem`, `MenuHeader`, and `MenuDivider` are configurable through the tools panel.
- **SC-003**: Changes to any tool/setting are reflected on the pre-rendered context menu instantly (within the same frame or next frame).
- **SC-004**: The three-layer theme precedence (inline > inherited > extension) is demonstrable by setting conflicting values and observing the correct winner.
- **SC-005**: The app functions correctly in both light and dark mode with all controls and the context menu adapting to the selected theme.
- **SC-006**: The example project builds and runs without errors using `cd example && flutter run` on the supported Flutter version (>=3.27.0).

## Clarifications

### Session 2026-02-26

- Q: How should the tools panel sections be organized? → A: Two-level tabs — top-level "Structure" tab (entries tree + menu properties) and "Theming" tab (sub-tabs for Inline Style, Inherited Theme, Theme Extension).
- Q: What is the primary target platform? → A: Web (Chrome) as primary; desktop as secondary.

### Session 2026-02-27

- Q: How is the Theme Extension layer injected and how is light/dark mode scoped? → A: The playground area (`PlaygroundArea`) wraps its content in a `MaterialApp` widget. This gives the embedded context menu a proper `ThemeData` ancestry so that `ThemeData.extensions` (for FR-008) and `themeMode` (for FR-011 scoped to the playground) work correctly. The outer `shadcn_flutter` shell is unaffected.

## Assumptions

- The playground targets Web (Chrome) as the primary platform and desktop as secondary. Mobile responsiveness is not a primary concern but the layout should not break on tablet-sized screens.
- The playground area (`PlaygroundArea`) wraps its content in a `MaterialApp` widget (not a bare `Theme`) to establish a full `ThemeData` context. This is the mechanism by which the Theme Extension tab injects `ContextMenuStyle` via `ThemeData.extensions`, and by which light/dark mode toggling (via `themeMode`) is scoped to the playground area without affecting the outer `shadcn_flutter` shell. Both `theme` (light) and `darkTheme` (dark) are constructed using Flutter's `ThemeData.light()`/`ThemeData.dark()` defaults with the active extension appended.
- The `shadcn_flutter` package provides sufficient components (tabs, switches, sliders, color pickers, tree views, dropdowns) for the tools panel; any gaps will be filled with standard Flutter widgets.
- The "pre-rendered" context menu will be implemented by directly embedding the menu widget in the widget tree (bypassing the overlay/route-based display) so it can remain always visible.
- Icon selection will use a predefined set of common Material icons rather than a full icon browser.
- Shortcut indicators are display-only in the playground (they show the shortcut text but don't register actual keyboard shortcuts for item actions).
- The future "code export" feature will be accommodated by structuring state in a way that can be serialized to Dart code, but no export UI is built in this feature.
- The future "theme presets" feature will be accommodated by structuring theme state as a self-contained object that can be swapped, but no preset UI is built in this feature.
