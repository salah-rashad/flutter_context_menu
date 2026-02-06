# Feature Specification: Theme Support

**Feature Branch**: `001-theme-support`
**Created**: 2026-02-05
**Status**: Draft
**Input**: User description: "Currently, the flutter_context_menu package does not provide a standardized way to customize its appearance globally. Developers must manually pass style parameters (e.g., colors, shapes, paddings) to each menu or item, which leads to repetitive code and inconsistent styling across the app. Adding proper theme support would allow developers to define context menu styling once and have it applied consistently throughout the application."

## Clarifications

### Session 2026-02-05

- Q: Should the theme be provided via a standalone `ContextMenuTheme` InheritedWidget only, via `ThemeExtension` on `ThemeData` only, or both? → A: Both — standalone `ContextMenuTheme` widget AND `ThemeExtension<ContextMenuThemeData>` support, with the InheritedWidget taking precedence when both are present.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Define Global Context Menu Theme (Priority: P1)

A developer wants to set a consistent visual style for all context menus in their application. They define the context menu theme once at the app level and every context menu rendered throughout the app automatically inherits that styling — surface colors, border radius, shadow, padding, and text appearance — without passing style parameters to each individual menu or item.

**Why this priority**: This is the core value proposition. Without a global theming mechanism, every other theming feature is moot. Developers currently repeat style parameters on every menu instance, which is the primary pain point described.

**Independent Test**: Can be fully tested by defining a theme at the app root, rendering a context menu with no inline style overrides, and verifying that the menu and its items adopt the global theme values.

**Acceptance Scenarios**:

1. **Given** a developer has defined a context menu theme at the app level, **When** a context menu is shown anywhere in the app without explicit style parameters, **Then** the menu container, items, headers, and dividers all render using the global theme values.
2. **Given** a developer has not defined any context menu theme, **When** a context menu is shown, **Then** the menu renders identically to the current default behavior (derived from the Material `ColorScheme`), ensuring full backward compatibility.
3. **Given** a developer updates the global context menu theme at runtime (e.g., switching between light and dark mode), **When** a context menu is shown after the change, **Then** it reflects the updated theme values.

---

### User Story 2 - Override Global Theme Per Menu Instance (Priority: P2)

A developer has set a global context menu theme but needs one specific menu to look different — for example, a destructive-action confirmation menu with a red-tinted background. They pass inline style parameters to that specific `ContextMenu` instance and those values take precedence over the global theme for that menu only.

**Why this priority**: After global theming works, the most common follow-up need is selective overrides. Without this, global theming becomes too rigid for real-world apps that need occasional variation.

**Independent Test**: Can be tested by defining a global theme, rendering two menus — one with no overrides and one with an explicit override — and verifying the overridden menu uses the inline values while the other uses the global theme.

**Acceptance Scenarios**:

1. **Given** a global context menu theme is defined and a specific menu instance provides an inline style override for surface color, **When** that menu is shown, **Then** the overridden surface color is used while all other properties still fall back to the global theme.
2. **Given** a global theme sets a border radius and a specific menu provides a different border radius, **When** the menu is shown, **Then** the menu-level border radius wins.
3. **Given** a menu instance provides a complete inline style, **When** the menu is shown, **Then** all inline values take precedence and no global theme values are used for the overridden properties.

---

### User Story 3 - Customize Individual Menu Item Styles via Theme (Priority: P3)

A developer wants to control the appearance of menu items globally — text color, background on focus/hover, icon color, item height, and disabled state appearance — without setting these on each `MenuItem`. They define item-level styling as part of the global context menu theme.

**Why this priority**: Item-level theming is a natural extension of container-level theming. It addresses the second half of the repetitive-code problem (per-item styling), but the container-level theme (P1) delivers the most visible value first.

**Independent Test**: Can be tested by defining item-level theme properties at the app level, rendering a menu with several items (including disabled and focused items), and verifying all items adopt the themed colors and sizes without any inline item-level style parameters.

**Acceptance Scenarios**:

1. **Given** a global theme defines item text color and focus background color, **When** a menu with default items is shown and an item receives focus, **Then** the item text uses the themed text color and the focus background uses the themed focus color.
2. **Given** a global theme defines disabled item opacity, **When** a disabled menu item is rendered, **Then** it uses the themed opacity value instead of the hardcoded default.
3. **Given** a global theme defines item height, **When** items are rendered, **Then** they use the themed height value.
4. **Given** a `MenuItem` provides an explicit `textColor`, **When** the item is rendered, **Then** the inline `textColor` takes precedence over the global item theme.

---

### Edge Cases

- What happens when a developer nests multiple theme providers (e.g., an inner theme override wrapping a subtree)? The nearest ancestor theme provider MUST win, following Flutter's standard `InheritedWidget` resolution.
- What happens when partial theme data is provided (e.g., only surface color, nothing else)? All unspecified properties MUST fall back to defaults derived from the Material `ColorScheme`, matching current behavior.
- What happens when the app switches between light and dark mode? The theme MUST react to `MediaQuery` brightness changes if it references `ColorScheme` values, just as the current defaults do.
- What happens when `boxDecoration` is provided on a `ContextMenu` instance alongside a global theme? The inline `boxDecoration` MUST take full precedence for the menu container decoration, as it does today.
- What happens when both a `ContextMenuTheme` ancestor widget and a `ThemeExtension<ContextMenuThemeData>` on `ThemeData` are present? The `ContextMenuTheme` ancestor widget MUST take precedence, as it represents a more specific/local override.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The package MUST provide a theme data class that encapsulates all visual properties for the context menu container: surface color, shadow, border radius, padding, maximum width, and maximum height.
- **FR-002**: The package MUST provide a theme data class (or section within the main theme data) that encapsulates all visual properties for menu items: text color, focused text color, disabled text color, background color, focused background color, icon color, item height, and shortcut text opacity.
- **FR-003**: The package MUST provide a theme data class (or section within the main theme data) that encapsulates visual properties for menu headers: text style, text color, and padding.
- **FR-004**: The package MUST provide a theme data class (or section within the main theme data) that encapsulates visual properties for menu dividers: color, height, thickness, indent, and end indent.
- **FR-005**: The package MUST provide two complementary mechanisms for supplying theme data: (a) a standalone `ContextMenuTheme` `InheritedWidget` that can wrap any subtree, and (b) a `ThemeExtension<ContextMenuThemeData>` integration so developers can register the theme on `ThemeData.extensions` alongside their existing Material theme.
- **FR-006**: The package MUST resolve styling with a clear four-level precedence order: inline parameters on the widget > nearest `ContextMenuTheme` ancestor widget > `ThemeExtension<ContextMenuThemeData>` on `ThemeData` > Material `ColorScheme` defaults.
- **FR-007**: When no theme is provided and no inline parameters are set, the package MUST render identically to its current behavior (full backward compatibility).
- **FR-008**: The theme data classes MUST support `copyWith` for easy partial overrides.
- **FR-009**: The theme data classes MUST support equality comparison and hash codes for efficient rebuild detection.
- **FR-010**: The package MUST continue to work with zero additional runtime dependencies (constitution principle I).

### Key Entities

- **ContextMenuThemeData**: Represents the complete set of visual properties for a context menu, including sub-themes for items, headers, and dividers.
- **MenuItemThemeData**: Represents visual properties specific to selectable menu items (colors, sizing, states).
- **MenuHeaderThemeData**: Represents visual properties specific to non-interactive header entries.
- **MenuDividerThemeData**: Represents visual properties specific to divider entries.
- **ContextMenuTheme (provider widget)**: A standalone `InheritedWidget` that supplies `ContextMenuThemeData` to descendant widgets in the tree. Takes precedence over the `ThemeExtension` approach.
- **ContextMenuThemeData as ThemeExtension**: The same `ContextMenuThemeData` class also implements `ThemeExtension<ContextMenuThemeData>`, allowing registration on `ThemeData.extensions` for app-wide theming without an extra widget wrapper.

### Assumptions

- The theme provider will follow Flutter's standard `InheritedWidget` pattern, consistent with how `Theme`, `IconTheme`, and other Flutter theme mechanisms work.
- Animation properties (duration, curve) are out of scope for this feature. They may be added in a future iteration.
- The theme applies only to visual/style properties. Behavioral properties (keyboard shortcuts, focus traversal) remain outside the theme system.
- Menu entry builders (custom `ContextMenuEntry` subclasses) will have access to the theme data via the build context but are not required to use it — this preserves the existing extension point.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can define context menu styling once at the app level and have it apply to all context menus without any per-menu or per-item style parameters — reducing style-related code per menu instance to zero lines.
- **SC-002**: An existing app using the package with no theme configuration renders identically before and after upgrading — zero visual regressions.
- **SC-003**: A developer can override any individual style property on a specific menu instance without affecting other menus — selective override works at single-property granularity.
- **SC-004**: The package maintains zero runtime dependencies after this feature is added.
- **SC-005**: All theme data classes support partial construction (all properties optional with sensible defaults), allowing developers to customize only the properties they care about.
- **SC-006**: Theme changes (e.g., light-to-dark mode switch) are reflected in subsequently shown context menus without requiring app restart or manual cache invalidation.
