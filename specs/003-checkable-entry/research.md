# Research: Checkable/Toggle Menu Entry

**Feature**: 003-checkable-entry
**Date**: 2026-03-02

## R1: Naming the Shared Interactive Base Class

**Decision**: `ContextMenuInteractiveEntry<T>`

**Rationale**: The class represents an entry that is interactive (focusable, selectable, has enabled/disabled state). The name follows the existing naming convention (`ContextMenu` prefix + descriptive noun) and clearly distinguishes it from the passive `ContextMenuEntry` base. The word "Interactive" signals focus handling and user interaction without implying selection semantics (which belong to `ContextMenuItem`).

**Alternatives considered**:
- `ContextMenuActionEntry` — "Action" implies a one-shot operation, doesn't fit toggle entries well.
- `ContextMenuFocusableEntry` — Too implementation-focused; focusability is a mechanism, not the concept.
- `ContextMenuSelectableEntry` — "Selectable" implies value-return semantics that checkable entries don't have.
- `ContextMenuActiveEntry` — Ambiguous; "active" could mean currently active/focused.

## R2: Refactoring Strategy for Type Hierarchy

**Decision**: Extract-and-extend approach with backward-compatible intermediate.

**Approach**:
1. Create `ContextMenuInteractiveEntry<T>` extending `ContextMenuEntry<T>` with:
   - `enabled` property (bool, default true)
   - `autoHandleFocus` getter (bool, default true)
   - `handleItemSelection` abstract method signature
   - Overridden `builder` method signature with optional `FocusNode` parameter

2. Refactor `ContextMenuItem<T>` to extend `ContextMenuInteractiveEntry<T>`:
   - Move `enabled` and `autoHandleFocus` up to the base
   - Keep `value`, `items`, `onSelected`, submenu logic, `handleItemSelection` implementation
   - Constructors unchanged — public API preserved

3. Create `ContextMenuCheckableItem<T>` extending `ContextMenuInteractiveEntry<T>`:
   - Own properties: `checked`, `onToggle`
   - Own `handleItemSelection` that calls `onToggle(!checked)` without closing menu

4. Update `MenuEntryWidget` to check `is ContextMenuInteractiveEntry<T>` instead of `is ContextMenuItem<T>` for focus/keyboard/mouse handling.

5. Update `menu_item_shortcuts.dart` to accept `ContextMenuInteractiveEntry` instead of `ContextMenuItem` for the base parameter type.

**Rationale**: This approach minimizes changes to existing code. The `ContextMenuItem` public API is unchanged — consumers don't need to update any code. The `MenuEntryWidget` type check change is a drop-in replacement. The keyboard shortcut function needs a slight signature change but the arrow-right submenu logic needs a `ContextMenuItem`-specific check internally.

**Alternatives considered**:
- Mixin-based approach — Dart sealed/base class modifiers complicate mixin composition. The existing classes use `abstract base class`, and mixins can't be used on base classes without `mixin class` which has its own limitations.
- Interface-based approach — Would require implementing rather than extending, losing the constructor chain. More boilerplate for consumers who subclass.

## R3: MenuEntryWidget Refactor Impact

**Decision**: Minimal changes to `MenuEntryWidget` — replace type checks only.

**Current behavior** (6 locations in `menu_entry_widget.dart` that check `ContextMenuItem`):
1. Line 48: `if (entry is ContextMenuItem<T>)` — for focus/keyboard wrapper → change to `ContextMenuInteractiveEntry<T>`
2. Line 49: `final item = entry as ContextMenuItem<T>` — cast → change to `ContextMenuInteractiveEntry<T>`
3. Line 83: `if (entry is ContextMenuItem<T> && entry.enabled)` — mouse enter → change to `ContextMenuInteractiveEntry<T>`
4. Line 84: `final item = widget.entry as ContextMenuItem<T>` — cast for submenu logic → keep `ContextMenuItem<T>` check inside for submenu-specific behavior
5. Line 102: `if (entry is ContextMenuItem<T> && entry.enabled)` — mouse exit → change to `ContextMenuInteractiveEntry<T>`
6. Line 103: `final item = widget.entry as ContextMenuItem` — cast for submenu check → keep `ContextMenuItem` for `isOpened` check

**Key insight**: The `_onMouseEnter` method has submenu-specific logic (`isSubmenuItem`, `showSubmenu`, `isOpened`). This logic only applies to `ContextMenuItem` entries. The method needs to be restructured to:
1. Check `ContextMenuInteractiveEntry` for focus/enabled gating
2. Check `ContextMenuItem` specifically for submenu behavior within the enabled block

## R4: ContextMenuState Type References

**Decision**: `ContextMenuState` references to `ContextMenuItem` for submenu-related properties remain unchanged.

**Analysis**: `ContextMenuState` uses `ContextMenuItem` in these typed positions:
- `_selectedItem` / `selectedItem` — tracks the currently opened submenu parent
- `parentItem` — tracks the parent item when this state represents a submenu
- `showSubmenu(parent: ContextMenuItem<T>)` — only `ContextMenuItem` has items
- `setSelectedItem(ContextMenuItem<T>?)` — submenu tracking
- `isOpened(ContextMenuItem)` — submenu tracking

All of these are submenu-specific and correctly typed to `ContextMenuItem`. No changes needed in `ContextMenuState`.

## R5: Keyboard Shortcuts Refactor

**Decision**: Change `defaultMenuItemShortcuts` parameter type from `ContextMenuItem` to `ContextMenuInteractiveEntry`, with internal `ContextMenuItem` check for arrow-right submenu logic.

**Current signature**: `defaultMenuItemShortcuts(BuildContext, ContextMenuItem, ContextMenuState)`

**New signature**: `defaultMenuItemShortcuts(BuildContext, ContextMenuInteractiveEntry, ContextMenuState)`

**Impact**: The Space/Enter/NumpadEnter shortcuts call `item.handleItemSelection()` which exists on the base class. The arrow-right shortcut checks `item.isSubmenuItem` which is `ContextMenuItem`-specific — this needs a `is ContextMenuItem` guard internally.

## R6: Dart `base` Class Modifier Propagation

**Decision**: Use `abstract base class` for `ContextMenuInteractiveEntry` and `ContextMenuCheckableItem`. Use `final class` for `CheckableMenuItem`.

**Rationale**: The existing hierarchy uses `abstract base class` for `ContextMenuEntry` and `ContextMenuItem`, and `final class` for `MenuItem`. Following the same pattern:
- `abstract base class ContextMenuInteractiveEntry<T> extends ContextMenuEntry<T>` — can be subclassed but not implemented
- `abstract base class ContextMenuCheckableItem<T> extends ContextMenuInteractiveEntry<T>` — same, designed for subclassing
- `final class CheckableMenuItem<T> extends ContextMenuCheckableItem<T>` — concrete, not further subclassable (matches `MenuItem`)
- `abstract base class ContextMenuItem<T> extends ContextMenuInteractiveEntry<T>` — same modifier as before, just new parent

## R7: Version Impact

**Decision**: MINOR version bump (0.5.0)

**Rationale per Constitution II**:
- New public symbols added: `ContextMenuInteractiveEntry`, `ContextMenuCheckableItem`, `CheckableMenuItem` → MINOR
- Existing public API unchanged: `ContextMenuItem` retains all properties, methods, and constructors → not a MAJOR bump
- `ContextMenuItem` now extends `ContextMenuInteractiveEntry` instead of `ContextMenuEntry` directly, but since `ContextMenuInteractiveEntry` extends `ContextMenuEntry`, all `is ContextMenuEntry` checks still pass → no breaking change for consumers
