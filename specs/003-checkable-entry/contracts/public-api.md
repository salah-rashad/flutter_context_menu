# Public API Contract: Checkable/Toggle Menu Entry

**Feature**: 003-checkable-entry
**Date**: 2026-03-02
**Version Impact**: 0.4.2 → 0.5.0 (MINOR — new public symbols, no breaking changes)

## New Exports (added to barrel file)

### 1. ContextMenuInteractiveEntry\<T\>

```dart
/// Abstract base class for interactive (focusable, selectable) menu entries.
///
/// Provides shared behavior for entries that respond to user interaction:
/// focus management, enabled/disabled state, and selection handling.
///
/// Subclasses:
/// - [ContextMenuItem] — selectable entries with value and submenu support
/// - [ContextMenuCheckableItem] — toggle entries with checked state
abstract base class ContextMenuInteractiveEntry<T> extends ContextMenuEntry<T> {
  final bool enabled;

  const ContextMenuInteractiveEntry({this.enabled = true});

  bool get autoHandleFocus => true;

  void handleItemSelection(BuildContext context, ContextMenuState<T> menuState);

  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]);
}
```

### 2. ContextMenuCheckableItem\<T\>

```dart
/// Abstract base class for checkable/toggle menu entries.
///
/// Entries that maintain an on/off state and keep the menu open when toggled.
/// Provides toggle-without-close behavior via [handleItemSelection].
///
/// Use [CheckableMenuItem] for a ready-to-use implementation, or subclass
/// this to create custom checkable entries with unique visuals.
abstract base class ContextMenuCheckableItem<T>
    extends ContextMenuInteractiveEntry<T> {
  final bool checked;
  final ValueChanged<bool>? onToggle;

  const ContextMenuCheckableItem({
    this.checked = false,
    this.onToggle,
    super.enabled,
  });

  @override
  void handleItemSelection(
      BuildContext context, ContextMenuState<T> menuState);
  // Implementation: if (!enabled) return; onToggle?.call(!checked);
  // Does NOT call Navigator.pop — menu stays open.
}
```

### 3. CheckableMenuItem\<T\>

```dart
/// A concrete checkable menu entry with check indicator, label, and styling.
///
/// Displays a checkmark (or custom icon) when [checked] is true.
/// The menu remains open after toggling.
///
/// Example:
/// ```dart
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   checked: showGrid,
///   onToggle: (value) => setState(() => showGrid = value),
/// )
/// ```
final class CheckableMenuItem<T> extends ContextMenuCheckableItem<T> {
  final Widget? icon;
  final Widget label;
  final SingleActivator? shortcut;
  final Widget? trailing;
  final BoxConstraints? constraints;
  final Color? textColor;

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
  });
}
```

## Modified Exports (no breaking changes)

### ContextMenuItem\<T\>

**Change**: Now extends `ContextMenuInteractiveEntry<T>` instead of `ContextMenuEntry<T>`.

**Backward compatibility**: All existing code continues to work:
- `entry is ContextMenuEntry<T>` → still true (transitive)
- `entry is ContextMenuItem<T>` → still true
- All properties, methods, constructors unchanged
- `MenuItem<T>` (concrete) unchanged

### ContextMenuState\<T\>

**Change**: None. All `ContextMenuItem` typed properties remain correctly typed to `ContextMenuItem` (submenu-specific).

## Barrel File Diff

```dart
// Existing exports (unchanged)
export 'src/components/menu_divider.dart';
export 'src/components/menu_header.dart';
export 'src/components/menu_item.dart';
export 'src/core/enums/spawn_direction.dart';
export 'src/core/models/context_menu.dart';
export 'src/core/models/context_menu_entry.dart';
export 'src/core/models/context_menu_item.dart';
export 'src/core/utils/extensions/single_activator_ext.dart';
export 'src/core/utils/helpers.dart';
export 'src/core/utils/menu_route_options.dart';
export 'src/widgets/context_menu_region.dart';
export 'src/widgets/context_menu_state.dart';

// New exports
export 'src/components/checkable_menu_item.dart';           // CheckableMenuItem
export 'src/core/models/context_menu_checkable_item.dart';  // ContextMenuCheckableItem
export 'src/core/models/context_menu_interactive_entry.dart'; // ContextMenuInteractiveEntry
```
