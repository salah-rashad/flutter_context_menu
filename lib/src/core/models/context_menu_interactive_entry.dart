import 'package:flutter/widgets.dart';

import '../../widgets/context_menu_state.dart';
import 'context_menu_entry.dart';

/// Abstract base class for interactive (focusable, selectable) menu entries.
///
/// Provides shared behavior for entries that respond to user interaction:
/// focus management, enabled/disabled state, and selection handling.
///
/// Subclasses:
/// - [ContextMenuItem] — selectable entries with value and submenu support
/// - [ContextMenuCheckableItem] — toggle entries with checked state
///
/// see:
/// - [ContextMenuEntry]
/// - [ContextMenuItem]
/// - [ContextMenuCheckableItem]
abstract base class ContextMenuInteractiveEntry<T> extends ContextMenuEntry<T> {
  /// Whether the entry is enabled for interaction.
  ///
  /// When `false`, the entry appears dimmed and does not respond to
  /// mouse hover, keyboard navigation, or selection.
  final bool enabled;

  /// Creates an interactive menu entry.
  ///
  /// The [enabled] parameter defaults to `true`.
  const ContextMenuInteractiveEntry({this.enabled = true});

  /// Indicates whether the menu item is using the focus node in a child widget.
  ///
  /// Used internally by the [MenuEntryWidget].
  ///
  /// This is helpful when users want to manually handle focus in the [builder].
  /// Override this getter and return `false` if the builder manages its own
  /// focus node.
  bool get autoHandleFocus => true;

  /// Returns the default activation callback for this entry.
  ///
  /// Called by [MenuEntryWidget] to register keyboard and tap activation
  /// automatically. Return a [VoidCallback] to enable default activation,
  /// or `null` to skip (e.g., when a widget subclass registers its own
  /// activator via [ContextMenuState.registerActivator] in `initState`).
  ///
  /// Subclasses:
  /// - [ContextMenuItem] returns a callback that calls [ContextMenuState.activateMenuItem]
  /// - [ContextMenuCheckableItem] returns `null` — activation is handled by the widget layer
  VoidCallback? createActivator(
          BuildContext context, ContextMenuState<T> menuState) =>
      null;

  /// Builds the widget representation of this menu entry.
  ///
  /// The optional [focusNode] parameter is provided when [autoHandleFocus]
  /// returns `true`, allowing the entry to integrate with keyboard navigation.
  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]);
}
