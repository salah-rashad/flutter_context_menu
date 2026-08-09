# Data Model: Checkable/Toggle Menu Entry

**Feature**: 003-checkable-entry
**Date**: 2026-03-02

## Type Hierarchy

```
ContextMenuEntry<T>                          (abstract base - unchanged)
├── MenuHeader                               (unchanged)
├── MenuDivider                              (unchanged)
└── ContextMenuInteractiveEntry<T>           (NEW - abstract base)
    ├── ContextMenuItem<T>                   (REFACTORED - new parent)
    │   └── MenuItem<T>                      (unchanged)
    └── ContextMenuCheckableItem<T>          (NEW - abstract base)
        └── CheckableMenuItem<T>             (NEW - concrete)
```

## Entities

### ContextMenuInteractiveEntry\<T\> (NEW)

**File**: `lib/src/core/models/context_menu_interactive_entry.dart`
**Extends**: `ContextMenuEntry<T>`
**Modifier**: `abstract base class`

| Property | Type | Default | Source |
|----------|------|---------|--------|
| `enabled` | `bool` | `true` | Constructor param |
| `autoHandleFocus` | `bool` | `true` | Getter (overridable) |

| Method | Signature | Abstract? |
|--------|-----------|-----------|
| `handleItemSelection` | `void handleItemSelection(BuildContext, ContextMenuState<T>)` | Yes |
| `builder` | `Widget builder(BuildContext, ContextMenuState<T>, [FocusNode?])` | Yes (overrides base) |

**Notes**:
- Extracted from `ContextMenuItem<T>`. The `enabled` field and `autoHandleFocus` getter move here.
- `handleItemSelection` becomes abstract — each subclass defines its own selection behavior.
- `builder` signature adds optional `FocusNode` parameter (matching current `ContextMenuItem.builder`).

### ContextMenuItem\<T\> (REFACTORED)

**File**: `lib/src/core/models/context_menu_item.dart`
**Extends**: `ContextMenuInteractiveEntry<T>` (was `ContextMenuEntry<T>`)
**Modifier**: `abstract base class` (unchanged)

| Property | Type | Default | Change |
|----------|------|---------|--------|
| `enabled` | `bool` | `true` | Moved to parent (passed via `super.enabled`) |
| `value` | `T?` | `null` | Unchanged |
| `items` | `List<ContextMenuEntry<T>>?` | `null` | Unchanged |
| `onSelected` | `ValueChanged<T?>?` | `null` | Unchanged |

| Method | Change |
|--------|--------|
| `handleItemSelection` | Now implements abstract from parent (was original definition) |
| `autoHandleFocus` | Moved to parent as getter |
| `isSubmenuItem` | Unchanged |
| `builder` | Unchanged signature |
| `_toggleSubmenu` | Unchanged |

**Constructors**: Unchanged — `ContextMenuItem({...})` and `ContextMenuItem.submenu({...})` retain same parameters. `enabled` passed to super.

### ContextMenuCheckableItem\<T\> (NEW)

**File**: `lib/src/core/models/context_menu_checkable_item.dart`
**Extends**: `ContextMenuInteractiveEntry<T>`
**Modifier**: `abstract base class`

| Property | Type | Default | Source |
|----------|------|---------|--------|
| `checked` | `bool` | `false` | Constructor param |
| `onToggle` | `ValueChanged<bool>?` | `null` | Constructor param |

| Method | Signature | Behavior |
|--------|-----------|----------|
| `handleItemSelection` | `void handleItemSelection(BuildContext, ContextMenuState<T>)` | If `!enabled`, return. Call `onToggle?.call(!checked)`. Does NOT close menu (no `Navigator.pop`). |
| `builder` | `Widget builder(BuildContext, ContextMenuState<T>, [FocusNode?])` | Abstract — subclasses define visual. |

**Constructor**: Single constructor only (no `.submenu()`):
```
const ContextMenuCheckableItem({
  this.checked = false,
  this.onToggle,
  super.enabled,
})
```

### CheckableMenuItem\<T\> (NEW)

**File**: `lib/src/components/checkable_menu_item.dart`
**Extends**: `ContextMenuCheckableItem<T>`
**Modifier**: `final class`

| Property | Type | Default | Source |
|----------|------|---------|--------|
| `icon` | `Widget?` | `null` | Constructor param (optional custom check indicator) |
| `label` | `Widget` | required | Constructor param |
| `shortcut` | `SingleActivator?` | `null` | Constructor param |
| `trailing` | `Widget?` | `null` | Constructor param |
| `constraints` | `BoxConstraints?` | `null` | Constructor param |
| `textColor` | `Color?` | `null` | Constructor param |

**Constructor**:
```
const CheckableMenuItem({
  this.icon,
  required this.label,
  this.shortcut,
  this.trailing,
  super.checked,
  super.onToggle,
  super.enabled,
  this.constraints,
  this.textColor,
})
```

**Builder behavior**:
- Leading icon area: When `checked` is `true`, shows `icon ?? Icon(Icons.check)`. When `checked` is `false`, shows empty `SizedBox`.
- Label, shortcut, trailing, styling: Matches `MenuItem` layout and theming exactly.
- Disabled state: Same dimming as `MenuItem` when `enabled` is `false`.

## Modified Entities

### MenuEntryWidget\<T\> (widgets layer)

**Changes**:
- Type checks `ContextMenuItem<T>` → `ContextMenuInteractiveEntry<T>` for focus/keyboard/enabled gating
- `_onMouseEnter`: Additional `ContextMenuItem` check inside for submenu-specific logic
- `_onMouseExit`: Additional `ContextMenuItem` check inside for `isOpened` submenu logic

### defaultMenuItemShortcuts (utils layer)

**Changes**:
- Parameter type: `ContextMenuItem item` → `ContextMenuInteractiveEntry item`
- Arrow-right handler: Add `is ContextMenuItem` guard before submenu logic
- Space/Enter/NumpadEnter: Call `item.handleItemSelection()` unchanged (exists on base)

### Barrel file

**New exports**:
```dart
export 'src/core/models/context_menu_interactive_entry.dart';
export 'src/core/models/context_menu_checkable_item.dart';
export 'src/components/checkable_menu_item.dart';
```
