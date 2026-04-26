import 'package:flutter/foundation.dart';

/// A controller for managing the checked state of a [ContextMenuCheckableItem].
///
/// This follows the same pattern as [TextEditingController] and
/// [ScrollController] — the consumer can optionally provide a controller
/// for external state access, or let the widget create one internally.
///
/// When provided to a [CheckableMenuItem], the controller allows:
/// - Reading the current checked state from outside the menu widget tree
/// - Listening to state changes via [addListener] or [ValueListenableBuilder]
/// - Programmatically toggling the state via [toggle] or setting [value]
///
/// Example:
/// ```dart
/// final controller = CheckableController(initialValue: false);
///
/// // Use in a checkable menu item
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   controller: controller,
/// )
///
/// // Listen from outside
/// ValueListenableBuilder<bool>(
///   valueListenable: controller,
///   builder: (context, isChecked, child) {
///     return Text('Grid: ${isChecked ? "on" : "off"}');
///   },
/// )
/// ```
///
/// The consumer is responsible for disposing the controller when it is
/// no longer needed. If no controller is provided to a [CheckableMenuItem],
/// an internal one is created and disposed automatically.
///
/// see:
/// - [ContextMenuCheckableItem]
/// - [CheckableMenuItem]
class CheckableController extends ValueNotifier<bool> {
  /// Creates a controller for a checkable menu item.
  ///
  /// The [initialValue] defaults to `false` (unchecked).
  CheckableController({bool initialValue = false}) : super(initialValue);

  /// Toggles the checked state.
  ///
  /// If currently `true`, sets to `false`, and vice versa.
  void toggle() => value = !value;
}
