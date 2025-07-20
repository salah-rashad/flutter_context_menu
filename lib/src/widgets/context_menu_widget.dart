import 'package:flutter/material.dart';

import '../core/utils/shortcuts/menu_shortcuts.dart';
import '../core/utils/utils.dart';
import 'context_menu_provider.dart';
import 'context_menu_state.dart';
import 'menu_entry_widget.dart';

/// Widget that displays the context menu.
///
/// This widget is used internally.
///
/// see:
/// - [ContextMenuState]

class ContextMenuWidget extends StatelessWidget {
  final ContextMenuState menuState;

  const ContextMenuWidget({
    super.key,
    required this.menuState,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuProvider(
      state: menuState,
      child: Builder(
        builder: (context) {
          final state = ContextMenuState.of(context);
          state.verifyPosition(context);

          return Positioned(
            key: state.key,
            left: state.position.dx,
            top: state.position.dy,
            child: OverlayPortal(
              controller: state.overlayController,
              overlayChildBuilder: state.submenuBuilder,
              child: CallbackShortcuts(
                bindings: defaultMenuShortcuts(context, state)
                  ..addAll(state.shortcuts),
                child: FocusScope(
                  autofocus: true,
                  node: state.focusScopeNode,
                  child: Opacity(
                    opacity: state.isPositionVerified ? 1.0 : 0.0,
                    child: _buildMenuView(context, state),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the context menu view.
  Widget _buildMenuView(BuildContext context, ContextMenuState state) {
    // final parentItem = state.parentItem;
    // if (parentItem?.isSubmenuItem == true) {
    //   print(parentItem?.debugLabel);
    // }

    var boxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withValues(alpha: 0.5),
          offset: const Offset(0.0, 2.0),
          blurRadius: 10,
          spreadRadius: -1,
        )
      ],
      borderRadius: state.borderRadius ?? BorderRadius.circular(4.0),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.8,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 60),
      builder: (context, value, child) {
        return Transform.scale(
          alignment: state.spawnAnchor,
          scale: value,
          child: Container(
            padding: state.padding,
            constraints: BoxConstraints(
              maxWidth: state.maxWidth,
              maxHeight: MediaQuery.of(context).size.height -
                  (kContextMenuSafeArea * 2),
            ),
            clipBehavior: state.clipBehavior,
            decoration: state.boxDecoration ?? boxDecoration,
            child: Material(
              type: MaterialType.transparency,
              child: IntrinsicWidth(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in state.entries)
                        MenuEntryWidget(entry: item)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
