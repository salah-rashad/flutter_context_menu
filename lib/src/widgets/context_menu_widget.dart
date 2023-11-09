import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import 'context_menu_state.dart';
import 'menu_entry_widget.dart';

/// A context menu contextMenu.
///
/// Displays a list of items that can be performed on the current context.
///
/// The context menu is displayed when the user right-clicks or presses the
/// context menu key.
///
/// To use the context menu, create a list of `ContextMenuEntry` objects and
/// pass them to the `items` property. Each `ContextMenuEntry` object
/// represents a single item in the context menu.
///
/// You can also use the `ContextMenu.submenu()` constructor to create a
/// context menu that is a submenu of another context menu.
///
/// Example usage:
/// ```dart
/// final contextMenu = ContextMenu(
///   items: [
///     DefaultContextMenuItem(
///       title: 'Copy',
///       onSelected: () {
///         // implement copy
///       },
///     ),
///     DefaultContextMenuItem(
///       title: 'Cut',
///       onSelected: () {
///         // implement cut
///       },
///     ),
///     DefaultContextMenuItem(
///       title: 'Paste',
///       onSelected: () {
///         // implement paste
///       },
///     ),
///   ],
/// );
/// ```
///
/// See also:
/// - [ContextMenuState]
/// - [ContextMenuEntry]
/// - [ContextMenuItem]

class ContextMenuWidget extends StatelessWidget {
  final ContextMenuState menuState;

  const ContextMenuWidget({
    super.key,
    required this.menuState,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => menuState,
      child: Consumer<ContextMenuState>(
        builder: (context, state, _) {
          state.verifyPosition(context);

          return Positioned(
            left: state.position.dx,
            top: state.position.dy,
            child: FocusScope(
              autofocus: true,
              node: state.focusScopeNode,
              child: Opacity(
                opacity: state.isPositionVerified ? 1.0 : 0.0,
                child: _buildMenuView(context, state),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the context menu view.
  Widget _buildMenuView(BuildContext context, ContextMenuState state) {
    var boxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.5),
          offset: const Offset(0.0, 2.0),
          blurRadius: 10,
          spreadRadius: -1,
        )
      ],
      borderRadius: state.borderRadius ?? BorderRadius.circular(4.0),
    );

    return Container(
      padding: state.padding,
      constraints: BoxConstraints(
        maxWidth: state.maxWidth,
      ),
      clipBehavior: state.clipBehavior,
      decoration: state.boxDecoration ?? boxDecoration,
      child: Material(
        type: MaterialType.transparency,
        child: IntrinsicWidth(
          child: Column(
            children: [
              for (final item in state.entries) MenuEntry(entry: item)
            ],
          ),
        ),
      ),
    );
  }
}
