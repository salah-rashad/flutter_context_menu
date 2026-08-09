import 'package:flutter/widgets.dart';

import '../../widgets/context_menu_state.dart';
import 'checkable_controller.dart';
import 'context_menu_interactive_entry.dart';

/// Abstract base class for checkable/toggle menu entries.
///
/// Entries that maintain an on/off state and keep the menu open when toggled.
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
  /// The checked state when no [controller] is provided.
  ///
  /// When a [controller] is provided this value is ignored — the controller's
  /// [CheckableController.value] is the source of truth.
  ///
  /// Without a controller the entry holds no state of its own: [CheckableMenuItem]
  /// treats this as the initial value of a controller it creates internally,
  /// while a subclass that toggles through [toggle] leaves the state with the
  /// caller, who is expected to rebuild the menu with a new [checked] value.
  final bool checked;

  /// Optional controller for managing the checked state.
  ///
  /// When provided, the controller is the source of truth for the
  /// checked state. This allows reading and listening to state changes
  /// from outside the menu widget tree via [ValueListenableBuilder]
  /// or [CheckableController.addListener].
  ///
  /// When not provided, [CheckableMenuItem] creates an internal controller
  /// initialized with [checked] and disposes it automatically. A controller
  /// you provide is yours to dispose.
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

  /// Toggles the checked state and notifies [onToggle].
  ///
  /// Does nothing when the entry is disabled. When a [controller] is
  /// provided, its value is toggled and [onToggle] receives the new value.
  /// Otherwise [onToggle] receives the inverse of [checked] — the caller
  /// owns the state in that case.
  ///
  /// The menu is intentionally left open.
  void toggle() {
    if (!enabled) return;
    final controller = this.controller;
    if (controller != null) {
      controller.toggle();
      onToggle?.call(controller.value);
    } else {
      onToggle?.call(!checked);
    }
  }

  /// Default activation for checkable entries — [toggle], which leaves the
  /// menu open.
  ///
  /// A subclass that overrides only [builder] gets keyboard activation
  /// (Space/Enter) for free, and should call [toggle] from its own `onTap`
  /// so tap and keyboard behave identically.
  ///
  /// [CheckableMenuItem] replaces this with an activator bound to its widget
  /// state, so that the controller it creates internally is the one toggled.
  @override
  VoidCallback? createActivator(
          BuildContext context, ContextMenuState<T> menuState) =>
      toggle;
}
