import 'package:flutter/widgets.dart';

import '../../widgets/context_menu_state.dart';
import 'checkable_controller.dart';
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
///   checked: false,
///   onToggle: (value) => print('Grid: $value'),
/// )
/// ```
///
/// For external state access and listening, use [controller]:
/// ```dart
/// final gridController = CheckableController(initialValue: false);
/// // ...
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   controller: gridController,
/// )
/// // Listen from outside:
/// ValueListenableBuilder<bool>(
///   valueListenable: gridController,
///   builder: (context, isChecked, child) => ...,
/// )
/// ```
///
/// see:
/// - [ContextMenuInteractiveEntry]
/// - [CheckableMenuItem]
/// - [ContextMenuItem]
/// - [CheckableController]
abstract base class ContextMenuCheckableItem<T>
    extends ContextMenuInteractiveEntry<T> {
  /// The initial checked state when no [controller] is provided.
  ///
  /// When a [controller] is provided, this value is ignored — the
  /// controller's [CheckableController.value] is used instead.
  final bool checked;

  /// Optional controller for managing the checked state.
  ///
  /// When provided, the controller is the source of truth for the
  /// checked state. This allows reading and listening to state changes
  /// from outside the menu widget tree via [ValueListenableBuilder]
  /// or [CheckableController.addListener].
  ///
  /// When not provided, an internal controller is created automatically
  /// by [CheckableMenuItem], initialized with the [checked] value.
  /// The consumer is responsible for disposing a provided controller.
  final CheckableController? controller;

  /// Callback invoked when the checked state changes.
  ///
  /// The callback receives the new checked value after toggling.
  /// The menu remains open after the toggle.
  final ValueChanged<bool>? onToggle;

  /// Creates a checkable menu entry.
  ///
  /// The [checked] parameter defaults to `false`.
  /// The [enabled] parameter defaults to `true` (inherited).
  /// For external state access, provide a [controller].
  const ContextMenuCheckableItem({
    this.checked = false,
    this.controller,
    this.onToggle,
    super.enabled,
  });

  /// Returns the current checked state.
  ///
  /// If [controller] is provided, returns its current value.
  /// Otherwise, returns the static [checked] value.
  bool get currentChecked => controller?.value ?? checked;

  @override
  void handleItemSelection(
      BuildContext context, ContextMenuState<T> menuState) {
    if (!enabled) return;
    onToggle?.call(!currentChecked);
    // Note: Does NOT call Navigator.pop — menu stays open.
    // The actual state mutation (controller.toggle()) is handled by
    // the widget layer which owns the effective controller lifecycle.
  }
}
