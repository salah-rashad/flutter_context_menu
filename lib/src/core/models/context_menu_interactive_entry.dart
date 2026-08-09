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

  /// Whether the menu wraps this entry in its own focus widget.
  ///
  /// When `true` (the default), the menu owns the entry's focus node and
  /// keyboard navigation works with no effort from [builder] — determine the
  /// highlight with `menuState.focusedEntry == this`.
  ///
  /// Override to `false` when [builder] returns a widget that must own focus
  /// itself (a `ListTile`, a `TextField`). The menu then leaves its wrapper
  /// unfocusable and hands the focus node to [builder] instead, which must
  /// attach it for keyboard navigation to keep working.
  bool get autoHandleFocus => true;

  /// Returns the default activation callback for this entry — what happens
  /// when it is tapped, or focused and activated with Space/Enter.
  ///
  /// Registered automatically when the entry is built. Return `null` to skip
  /// registration, leaving activation to a widget that registers its own
  /// callback.
  ///
  /// Subclasses:
  /// - [ContextMenuItem] opens its submenu, or selects it and closes the menu
  /// - [ContextMenuCheckableItem] toggles the checked state, leaving the menu open
  VoidCallback? createActivator(
          BuildContext context, ContextMenuState<T> menuState) =>
      null;

  /// Builds the widget representation of this menu entry.
  ///
  /// [focusNode] is only meaningful when [autoHandleFocus] is `false` — attach
  /// it to the focusable widget you return so the entry stays reachable by
  /// keyboard. Leave it alone otherwise: the menu's own focus widget already
  /// owns that node, and attaching it twice breaks focus traversal.
  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]);
}
