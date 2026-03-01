# Implementation Plan: Checkable/Toggle Menu Entry

**Branch**: `003-checkable-entry` | **Date**: 2026-03-02 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/003-checkable-entry/spec.md`

## Summary

Introduce a checkable/toggle menu entry type that maintains on/off state and keeps the menu open after toggling. This requires refactoring the type hierarchy to extract a shared interactive base class from `ContextMenuEntry` and `ContextMenuItem`, then building `ContextMenuCheckableItem` and `CheckableMenuItem` on top of it. The refactor touches the models layer, components layer, and the `MenuEntryWidget` in the widgets layer, while preserving full backward compatibility for existing consumers.

## Technical Context

**Language/Version**: Dart ^3.6.0, Flutter >=3.27.0
**Primary Dependencies**: Flutter SDK only (zero-dependency package)
**Storage**: N/A
**Testing**: Manual testing via example app; smoke test in `example/test/`
**Target Platform**: All Flutter platforms (Android, iOS, Web, macOS, Windows, Linux)
**Project Type**: Library (published on pub.dev as `flutter_context_menu`)
**Performance Goals**: 60fps menu rendering, instant visual feedback on toggle
**Constraints**: Zero runtime dependencies; barrel-file-only public API
**Scale/Scope**: ~20 source files in `lib/src/`, 3-layer architecture (Models → Components → Widgets)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Zero-Dependency | PASS | No new dependencies. All implemented with Flutter SDK primitives. |
| II. Public API Surface Control | PASS | New public classes (`ContextMenuCheckableItem`, `CheckableMenuItem`, shared base) will be added to barrel file. This is a MINOR version bump. Existing `ContextMenuItem` public API unchanged — no breaking change. |
| III. Static Analysis Compliance | PASS | All new code must pass `flutter analyze --fatal-warnings` and `dart format`. |
| IV. Layered Architecture | PASS | Shared base and `ContextMenuCheckableItem` go in `lib/src/core/models/` (models layer). `CheckableMenuItem` goes in `lib/src/components/` (components layer). `MenuEntryWidget` changes stay in `lib/src/widgets/` (widgets layer). Dependency direction preserved: Models → Components → Widgets. |
| V. Simplicity & YAGNI | PASS | The shared intermediate class is justified by a concrete need (two distinct interactive entry types). The checkable entry uses the recommended subclassing extension point. No speculative abstractions. |

**Gate result: PASS** — all principles satisfied. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/003-checkable-entry/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── public-api.md    # Public API contract for new/changed exports
├── checklists/
│   └── requirements.md  # Specification quality checklist
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── flutter_context_menu.dart          # Barrel file (add new exports)
└── src/
    ├── core/
    │   └── models/
    │       ├── context_menu_entry.dart          # Existing (unchanged)
    │       ├── context_menu_item.dart           # Refactor: extract shared base, extend it
    │       ├── context_menu_interactive_entry.dart  # NEW: shared interactive base class
    │       └── context_menu_checkable_item.dart     # NEW: abstract checkable entry
    ├── components/
    │   ├── menu_item.dart                # Existing (unchanged)
    │   └── checkable_menu_item.dart      # NEW: concrete checkable component
    └── widgets/
        └── menu_entry_widget.dart        # Modify: check for interactive base type
```

**Structure Decision**: Follows existing package conventions. New model files in `core/models/`, new component in `components/`. File naming matches existing patterns (`context_menu_*.dart` for models, `*_menu_item.dart` for components).

## Complexity Tracking

No constitution violations to justify — all principles pass cleanly.
