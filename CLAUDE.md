# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A zero-dependency Flutter package for creating customizable context menus with hierarchical submenus, keyboard navigation, and smart boundary positioning. Published on pub.dev as `flutter_context_menu`.

**Requirements:** Dart ^3.6.0, Flutter >=3.27.0

## Commands

```bash
# Install dependencies
flutter pub get

# Static analysis (CI runs this with --fatal-warnings)
flutter analyze --fatal-warnings

# Format check (CI enforces this)
dart format --output=none --set-exit-if-changed .

# Format fix
dart format .

# Run example app
cd example && flutter run
```

There are no unit tests for the package itself. The only test is a smoke test in `example/test/`.

## Lint Rules

Uses `flutter_lints` with these additional rules enforced:
- `prefer_relative_imports` — always use relative imports within the package
- `prefer_const_declarations`, `prefer_const_constructors`, `prefer_final_fields`

## Architecture

### Public API (`lib/flutter_context_menu.dart`)

All public exports go through the barrel file. The package has three layers:

**Models** (`lib/src/core/models/`):
- `ContextMenu<T>` — data model holding menu entries, position, styling, and shortcuts. The `show()` method triggers display via `showContextMenu()`.
- `ContextMenuEntry<T>` — abstract base class for all menu entries.
- `ContextMenuItem<T>` — abstract base for selectable/interactive entries (extends `ContextMenuEntry`).

**Components** (`lib/src/components/`):
- `MenuItem<T>` — concrete selectable entry with label, icon, shortcut indicator, trailing widget, and optional submenu. Implements both `ContextMenuEntry` and `ContextMenuItem`.
- `MenuHeader` — non-interactive header text.
- `MenuDivider` — visual separator.

**Widgets** (`lib/src/widgets/`):
- `ContextMenuRegion` — wraps any widget to detect right-click/long-press and show a menu at the interaction point.
- `ContextMenuState<T>` — `ChangeNotifier` managing focus, selection, submenu visibility, and position verification.
- `ContextMenuWidget` — assembles state via `ContextMenuProvider` (InheritedNotifier), keyboard shortcuts, and focus scope.
- `ContextMenuWidgetView` — renders the menu container with box decoration and scale animation.
- `MenuEntryWidget` — renders individual entries with mouse region and focus handling.

### Menu Display Flow

1. `ContextMenuRegion` captures tap position → calls `showContextMenu<T>()`
2. `showContextMenu()` creates `ContextMenuState`, pushes a transparent `PageRoute` on the **root navigator**
3. `ContextMenuWidget` wraps state in provider, sets up keyboard shortcuts
4. Position is calculated post-frame via `calculateContextMenuBoundaries()` which scores 4 candidate positions (penalizing overflow, flips, distance) and clamps to safe area
5. Submenus render via `OverlayPortal` on the parent `MenuItem`, positioned relative to the parent item bounds

### Keyboard Navigation

Arrow keys navigate between entries (via `FocusScopeNode`), Space/Enter selects, Right arrow opens submenu, Left arrow closes submenu.

### Custom Entries

Create custom menu entries by subclassing `ContextMenuEntry<T>` and implementing the `builder` method.
