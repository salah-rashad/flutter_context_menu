import 'package:flutter/widgets.dart';

import '../../widgets/context_menu_state.dart';
import 'context_menu_interactive_entry.dart';

/// Abstract base class for checkable/toggle menu entries.
///
/// Entries that maintain an on/off state and keep the menu open when toggled.
/// Provides toggle-without-close behavior via [handleItemSelection].
///
/// Use [CheckableMenuItem] for a ready-to-use implementation, or subclass
/// this to create custom checkable entries with unique visuals.
///
/// Example:
/// ```dart
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   checked: showGrid,
///   onToggle: (value) => setState(() => showGrid = value),
/// )
/// ```
///
/// For reactive updates while the menu is open, use [checkedNotifier]:
/// ```dart
/// final showGridNotifier = ValueNotifier<bool>(false);
/// // ...
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   checkedNotifier: showGridNotifier,
///   onToggle: (value) => showGridNotifier.value = value,
/// )
/// ```
///
/// see:
/// - [ContextMenuInteractiveEntry]
/// - [CheckableMenuItem]
/// - [ContextMenuItem]
abstract base class ContextMenuCheckableItem<T>
    extends ContextMenuInteractiveEntry<T> {
  /// Whether the entry is currently checked (toggled on).
  ///
  /// This is a static value. For reactive updates while the menu is open,
  /// use [checkedNotifier] instead.
  final bool checked;

  /// Optional notifier for the checked state.
  ///
  /// When provided, the menu entry will listen to this notifier and
  /// rebuild when the value changes. This allows the check indicator
  /// to update in real-time while the menu remains open.
  ///
  /// If both [checked] and [checkedNotifier] are provided, [checkedNotifier]
  /// takes precedence for displaying the current state.
  final ValueNotifier<bool>? checkedNotifier;

  /// Callback invoked when the checked state changes.
  ///
  /// The callback receives the new checked value (`!checked`).
  /// The menu remains open after the toggle — the parent widget
  /// is responsible for updating state and rebuilding.
  final ValueChanged<bool>? onToggle;

  /// Creates a checkable menu entry.
  ///
  /// The [checked] parameter defaults to `false`.
  /// The [enabled] parameter defaults to `true` (inherited).
  /// For reactive updates, provide [checkedNotifier] instead of [checked].
  const ContextMenuCheckableItem({
    this.checked = false,
    this.checkedNotifier,
    this.onToggle,
    super.enabled,
  });

  /// Returns the current checked state.
  ///
  /// If [checkedNotifier] is provided, returns its current value.
  /// Otherwise, returns the static [checked] value.
  bool get currentChecked => checkedNotifier?.value ?? checked;

  @override
  void handleItemSelection(
      BuildContext context, ContextMenuState<T> menuState) {
    if (!enabled) return;
    onToggle?.call(!currentChecked);
    // Note: Does NOT call Navigator.pop — menu stays open
  }
}
