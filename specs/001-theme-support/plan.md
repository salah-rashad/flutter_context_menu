# Implementation Plan: Theme Support

**Branch**: `001-theme-support` | **Date**: 2026-02-05 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-theme-support/spec.md`

## Summary

Add a global theming system to `flutter_context_menu` so developers can define context menu styling once and have it applied consistently throughout their application. The implementation provides two complementary theme delivery mechanisms: a `ThemeExtension<ContextMenuThemeData>` for `ThemeData` integration (convenient for app-wide light/dark themes) and a standalone `ContextMenuTheme` `InheritedWidget` for subtree-level overrides. A four-level precedence chain (inline > InheritedWidget > ThemeExtension > ColorScheme defaults) ensures flexibility while maintaining full backward compatibility.

## Technical Context

**Language/Version**: Dart ^3.6.0, Flutter >=3.27.0
**Primary Dependencies**: Flutter SDK only (zero runtime dependencies — constitution principle I)
**Storage**: N/A
**Testing**: `flutter_test` (dev dependency); smoke test in `example/test/`
**Target Platform**: Android, iOS, Web, Desktop (macOS, Windows, Linux)
**Project Type**: Single Flutter package
**Performance Goals**: No measurable performance regression from theme resolution; `InheritedWidget` lookup is O(1) per Flutter's element tree
**Constraints**: Zero runtime dependencies; all code must pass `flutter analyze --fatal-warnings` and `dart format`
**Scale/Scope**: ~6 new files, ~4 modified files; MINOR version bump

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Zero Dependencies | PASS | No new runtime dependencies. All new code uses only Flutter SDK APIs (`ThemeExtension`, `InheritedWidget`, `Color.lerp`, etc.) |
| II. Public API Discipline | PASS | New types placed in correct layers: theme data in `lib/src/core/models/`, provider widget in `lib/src/widgets/`. All exported via barrel file. |
| III. Static Analysis Compliance | PASS | All new code will use relative imports, const constructors where possible, final fields (theme data is immutable). CI gates enforced. |
| IV. Cross-Platform Compatibility | PASS | No platform-specific code. `ThemeExtension` and `InheritedWidget` are Flutter-universal. |
| V. Simplicity & Extensibility | PASS | Minimal new abstraction (theme data + provider). Custom entry builders retain access to theme via `BuildContext`. Extension point preserved. |

**Post-Phase 1 Re-check**: All principles still hold. The design adds 4 immutable data classes and 1 `InheritedWidget` — no unnecessary abstraction layers, no new dependencies.

## Project Structure

### Documentation (this feature)

```text
specs/001-theme-support/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── public-api.md    # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── flutter_context_menu.dart          # Barrel file (MODIFY: add new exports)
└── src/
    ├── core/
    │   └── models/
    │       ├── context_menu.dart       # (EXISTING — no changes)
    │       ├── context_menu_entry.dart  # (EXISTING — no changes)
    │       ├── context_menu_theme_data.dart  # NEW: top-level theme data + ThemeExtension
    │       ├── menu_item_theme_data.dart     # NEW: item-level theme data
    │       ├── menu_header_theme_data.dart   # NEW: header-level theme data
    │       └── menu_divider_theme_data.dart  # NEW: divider-level theme data
    ├── components/
    │   ├── menu_item.dart              # MODIFY: resolve colors from theme
    │   ├── menu_header.dart            # MODIFY: resolve styles from theme
    │   └── menu_divider.dart           # MODIFY: resolve styles from theme
    └── widgets/
        ├── context_menu_theme.dart     # NEW: InheritedWidget provider
        ├── context_menu_widget.dart    # (EXISTING — no changes needed)
        └── context_menu_widget_view.dart  # MODIFY: resolve decoration from theme

example/
└── lib/
    └── main.dart                       # MODIFY: demonstrate theme usage
```

**Structure Decision**: Flutter package layout — all source in `lib/src/` following existing Models/Components/Widgets layering. New theme data classes go in `lib/src/core/models/` (data-only, immutable). New provider widget goes in `lib/src/widgets/` (rendering/state layer).

## Complexity Tracking

> No constitution violations. Table intentionally empty.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |
