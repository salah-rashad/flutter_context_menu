import 'package:flutter/widgets.dart';

import '../../widgets/context_menu_state.dart';
import '../../widgets/context_menu_widget.dart';
import '../models/context_menu.dart';
import 'menu_route_options.dart';

/// Shows the root context menu popup.
Future<T?> showContextMenu<T>(
  BuildContext context, {
  required ContextMenu<T> contextMenu,
  MenuRouteOptions? routeOptions,
  bool useRootNavigator = true,
}) async {
  final menuState = ContextMenuState(menu: contextMenu);
  routeOptions ??= const MenuRouteOptions(
    barrierDismissible: true,
  );

  // Use root navigator to make sure the context menu is always on top, and to
  // fix the issue where the context menu may be opened for each navigator, and
  // to make sure the context menu is opened once.
  return await Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
    PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [ContextMenuWidget(menuState: menuState)],
        );
      },
      fullscreenDialog: true,
      settings: routeOptions.routeSettings,
      barrierDismissible: routeOptions.barrierDismissible,
      opaque: routeOptions.opaque,
      transitionDuration: routeOptions.transitionDuration,
      reverseTransitionDuration: routeOptions.reverseTransitionDuration,
      barrierColor: routeOptions.barrierColor,
      barrierLabel: routeOptions.barrierLabel,
      transitionsBuilder: routeOptions.transitionsBuilder,
      allowSnapshotting: routeOptions.allowSnapshotting,
      maintainState: routeOptions.maintainState,
      requestFocus: routeOptions.requestFocus,
    ),
  );
}
