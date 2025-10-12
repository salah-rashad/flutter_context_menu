import 'package:flutter/material.dart';

import '../core/utils/shortcuts/menu_shortcuts.dart';
import 'context_menu_provider.dart';
import 'context_menu_state.dart';
import 'context_menu_widget_view.dart';

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
                    child: ContextMenuWidgetView(
                      menu: state.menu,
                      spawnAnchor: state.spawnAnchor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
