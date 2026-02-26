# Research: Example Playground

**Feature**: 002-example-playground
**Date**: 2026-02-26

## R-001: Embedding ContextMenu Without Route/Overlay

**Decision**: Use `ContextMenuWidget<T>` inside a `Stack` directly in the widget tree, bypassing `showContextMenu()`.

**Rationale**: The `showContextMenu()` function pushes a `PageRouteBuilder` onto the navigator which creates a dismissible overlay. For an always-visible playground menu, we need to:
1. Create a `ContextMenuState<T>` manually
2. Place `ContextMenuWidget<T>` inside a `Stack` (it renders a `Positioned` child)
3. Override the dismiss behavior by providing a custom `onItemSelected` that logs the selection but does not pop any route

The key insight from the source: `ContextMenuWidget` wraps `ContextMenuProvider` → `FocusScope` → `OverlayPortal` (for submenus) → `ContextMenuWidgetView`. Submenus use `OverlayPortal` so an `Overlay` ancestor is required — this is satisfied by `ShadcnApp`/`MaterialApp`'s built-in overlay.

**Alternatives considered**:
- Using `ContextMenuWidgetView` directly: Rejected — loses keyboard navigation, submenu handling, and focus management.
- Wrapping in a custom route that never pops: Over-engineered; direct embedding is simpler.

## R-002: Preventing Menu Dismissal

**Decision**: Provide a custom `onItemSelected` callback on `ContextMenuState` that captures the selected value for display but does not navigate or pop. Override Escape key behavior by wrapping the menu in a `Shortcuts` widget that intercepts `LogicalKeyboardKey.escape`.

**Rationale**: In the normal flow, `ContextMenuItem.handleItemSelection` calls `Navigator.pop`. Since we're not inside a route, there's no route to pop. We provide `onItemSelected` to capture the value. The menu state remains intact.

**Alternatives considered**:
- Forking/patching the widget source: Fragile and increases maintenance burden.

## R-003: UI Framework — shadcn_flutter

**Decision**: Use `shadcn_flutter` package for the playground shell UI.

**Rationale**: The package provides 84+ cross-platform Flutter widgets with a cohesive design system, built-in light/dark theming, and all required components.

**Key components mapped to playground needs**:

| Playground Need | shadcn_flutter Component |
|----------------|--------------------------|
| Root app | `ShadcnApp` with `ThemeData` + `ColorSchemes` |
| Split layout | `ResizablePanel.horizontal` + `ResizablePane` |
| Top-level tabs | `Tabs` + `TabItem` |
| Sub-tabs (theming) | `Tabs` (nested) |
| Toggle switches | `Switch` |
| Sliders | `Slider` with `SliderValue` |
| Color picker | `ColorInput` with `ColorDerivative` |
| Text input | `TextField` |
| Dropdowns | `Select` + `SelectPopup` |
| Tree view | `TreeView` + `TreeItem` |
| Buttons | `PrimaryButton`, `OutlineButton`, `GhostButton`, `DestructiveButton` |
| Accordion panels | `Accordion` + `AccordionItem` |
| Cards | `Card` |
| Light/dark toggle | `ShadcnApp.themeMode` + `Switch` |

**Alternatives considered**:
- `shadcn_ui` (nank1ro): User explicitly switched to `shadcn_flutter` (sunarya-thito).
- Raw Material widgets: Would require significantly more custom styling to look polished.

## R-004: State Management — provider

**Decision**: Use the `provider` package with `ChangeNotifierProvider` for playground state.

**Rationale**: Lightweight, widely understood, and sufficient for the playground's state complexity. The state is a single `PlaygroundState extends ChangeNotifier` with sub-objects for each configuration area. `context.watch()` and `context.select()` provide granular rebuilds.

**Alternatives considered**:
- Raw `ChangeNotifier` + `ListenableBuilder`: Works but less ergonomic for deep widget trees.
- Riverpod/Bloc: Overkill for a single-state playground app.

## R-005: Reconciling shadcn_flutter and flutter_context_menu Theming

**Decision**: The playground app uses `ShadcnApp` as its root. The context menu package resolves styles from `ThemeData` (Material). Since `ShadcnApp` manages its own theme system, we'll need to ensure a `MaterialApp`-compatible `ThemeData` is available for the context menu's `ContextMenuTheme.resolve()` chain.

**Rationale**: `ContextMenuWidgetView` calls `ContextMenuTheme.resolve(context)` which falls back to `ContextMenuStyle.fallback(context)`, which reads `Theme.of(context).colorScheme`. We need `Theme.of(context)` to work.

**Approach**: Wrap the playground area in a `Theme` widget that provides a `ThemeData` constructed from the current `ShadcnApp` color scheme. This bridges the two theme systems. When the "Theme Extension" tab is enabled, that `ThemeData` includes the user-configured `ContextMenuStyle` in its `extensions`. The `ContextMenuTheme` inherited widget (from the "Inherited Theme" tab) wraps the context menu directly.

**Alternatives considered**:
- Using `MaterialApp` as root: Rejected — user explicitly requires `shadcn_flutter`.
- Ignoring Material theme bridge: Would break context menu's fallback style resolution.

## R-006: Playground State Architecture for Future Extensibility

**Decision**: Structure `PlaygroundState` as a composition of focused sub-state objects: `EntryListState`, `MenuPropertiesState`, `InlineStyleState`, `InheritedThemeState`, `ThemeExtensionState`, and `AppSettingsState`.

**Rationale**: This enables:
- **Theme presets** (future): Swap `InlineStyleState`/`InheritedThemeState`/`ThemeExtensionState` wholesale from a preset object.
- **Code export** (future): Each sub-state can independently serialize to Dart code (e.g., `InlineStyleState.toDartCode()` → `ContextMenuStyle(...)` constructor call).
- **Granular rebuilds**: `context.select()` on individual sub-states avoids rebuilding the entire tree on every change.

**Alternatives considered**:
- Flat state object with all fields: Harder to serialize/swap for presets, causes broader rebuilds.
