# Implementation Plan: Example Playground

**Branch**: `002-example-playground` | **Date**: 2026-02-26 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/002-example-playground/spec.md`

## Summary

Rebuild the example project as an interactive playground app using `shadcn_flutter` for the shell UI. The playground displays an always-visible, non-dismissible context menu at center stage, with a tools panel on the left providing real-time controls for menu entries, properties, and a three-layer theme system (inline style, inherited theme, theme extension). State is managed via `provider` with a `ChangeNotifier`. The context menu is embedded directly in the widget tree by instantiating `ContextMenuWidget<T>` inside a `Stack`, bypassing the normal route/overlay display flow.

The playground area (`PlaygroundArea`) wraps its content in a `MaterialApp` widget (with `theme`, `darkTheme`, and `themeMode`) rather than a bare `Theme` widget. This establishes a full `ThemeData` ancestry so that: (a) the Theme Extension layer can inject `ContextMenuStyle` via `ThemeData.extensions`, and (b) light/dark mode toggling is scoped to the playground area without affecting the outer `shadcn_flutter` shell. Both `theme` and `darkTheme` are built from Flutter's `ThemeData.light()`/`ThemeData.dark()` defaults with the active extension appended when enabled.

## Technical Context

**Language/Version**: Dart ^3.6.0, Flutter >=3.27.0
**Primary Dependencies**: `flutter_context_menu` (path: ../), `shadcn_flutter`, `provider`
**Storage**: N/A (no persistence; state resets on app restart)
**Testing**: Smoke test in `example/test/` (manual visual testing for playground features)
**Target Platform**: Web (Chrome) primary, Desktop secondary
**Project Type**: Single Flutter app (example project within package repo)
**Performance Goals**: 60 fps during tools panel interaction; instant (<16ms) menu re-render on state change
**Constraints**: No modifications to the main `lib/` package source; example-only changes
**Scale/Scope**: ~30 Dart files in `example/lib/`, 1 screen with split layout

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Zero Dependencies | PASS | `shadcn_flutter` and `provider` are added to `example/pubspec.yaml` only, not the main package. The main `lib/` is untouched. |
| II. Public API Discipline | PASS | No changes to `lib/flutter_context_menu.dart` or the barrel file. The example imports the public API as a consumer. |
| III. Static Analysis Compliance | PASS | Example project will follow `flutter analyze --fatal-warnings` and `dart format`. |
| IV. Cross-Platform Compatibility | PASS | No platform-specific code. Primary target is web, but standard Flutter widgets work on all platforms. |
| V. Simplicity & Extensibility | PASS | State model uses composition (sub-state objects) for future preset/export extensibility. No speculative abstractions — each piece is justified by current requirements. |

**Post-Phase 1 Re-check**: All gates still PASS. The design adds no new abstractions to the main package. The `provider` + `ChangeNotifier` pattern is the simplest viable approach for the playground's single-screen state.

## Project Structure

### Documentation (this feature)

```text
specs/002-example-playground/
├── plan.md                        # This file
├── spec.md                        # Feature specification
├── research.md                    # Phase 0: research findings
├── data-model.md                  # Phase 1: state model design
├── quickstart.md                  # Phase 1: setup and architecture guide
├── contracts/
│   └── state-contracts.md         # Phase 1: state mutation interface
├── checklists/
│   └── requirements.md            # Spec quality checklist
├── shadcn_flutter_reference.md    # shadcn_flutter component reference (57k lines)
└── tasks.md                       # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
example/
├── lib/
│   ├── main.dart                          # ShadcnApp entry point + provider setup
│   ├── app.dart                           # Root app widget with theme management
│   ├── state/
│   │   ├── playground_state.dart          # Central ChangeNotifier
│   │   ├── entry_node.dart                # Menu entry tree node model + EntryType enum
│   │   ├── menu_properties_state.dart     # ContextMenu-level properties
│   │   ├── inline_style_state.dart        # Inline ContextMenuStyle config
│   │   ├── inherited_theme_state.dart     # ContextMenuTheme wrapper config (with enabled flag)
│   │   ├── theme_extension_state.dart     # ThemeData.extensions config (with enabled flag)
│   │   ├── menu_item_style_state.dart     # MenuItemStyle sub-state
│   │   ├── menu_header_style_state.dart   # MenuHeaderStyle sub-state
│   │   ├── menu_divider_style_state.dart  # MenuDividerStyle sub-state
│   │   └── app_settings_state.dart        # App brightness mode
│   ├── screens/
│   │   └── playground_screen.dart         # Main split layout (ResizablePanel)
│   ├── widgets/
│   │   ├── playground_area.dart           # Center area: MaterialApp wrapper (ThemeData.extensions + themeMode) + embedded menu
│   │   ├── embedded_context_menu.dart     # Wraps ContextMenuWidget for always-on display
│   │   ├── tools_panel/
│   │   │   ├── tools_panel.dart           # Two-level tab container (Structure / Theming)
│   │   │   ├── structure_tab/
│   │   │   │   ├── structure_tab.dart     # Structure tab layout (tree + properties)
│   │   │   │   ├── entry_tree_editor.dart # TreeView for menu entries CRUD
│   │   │   │   ├── entry_node_tile.dart   # Single tree node widget
│   │   │   │   ├── entry_properties.dart  # Selected entry's property editor
│   │   │   │   └── menu_properties.dart   # ContextMenu-level property controls
│   │   │   └── theming_tab/
│   │   │       ├── theming_tab.dart       # Sub-tabs container (Inline/Inherited/Extension)
│   │   │       ├── inline_style_tab.dart  # Inline style controls
│   │   │       ├── inherited_theme_tab.dart # Inherited theme controls + enable switch
│   │   │       ├── theme_extension_tab.dart # Theme extension controls + enable switch
│   │   │       └── shared/
│   │   │           ├── style_editor.dart          # Reusable ContextMenuStyle editor widget
│   │   │           ├── menu_item_style_editor.dart   # MenuItemStyle controls
│   │   │           ├── menu_header_style_editor.dart  # MenuHeaderStyle controls
│   │   │           └── menu_divider_style_editor.dart # MenuDividerStyle controls
│   │   └── common/
│   │       ├── color_field.dart           # ColorInput wrapper
│   │       ├── number_field.dart          # Numeric input with Slider
│   │       ├── icon_picker.dart           # Predefined icon selector (Select dropdown)
│   │       └── section_header.dart        # Collapsible section header
│   └── utils/
│       ├── default_entries.dart           # Default sample EntryNode list
│       └── theme_bridge.dart             # shadcn_flutter ↔ Material ThemeData bridge
├── pubspec.yaml
├── web/                                   # Flutter web bootstrap (existing)
└── test/
    └── widget_test.dart                   # Smoke test
```

**Structure Decision**: Single Flutter project in `example/`. All new code goes under `example/lib/` organized by responsibility: `state/` for models, `screens/` for top-level layout, `widgets/` for composable UI pieces, `utils/` for helpers. This replaces the existing example app entirely (existing `example/lib/pages/` and `example/lib/entries/` will be removed).

## Complexity Tracking

No constitution violations. No complexity justifications needed.
