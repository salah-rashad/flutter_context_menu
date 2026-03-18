import 'package:flutter/widgets.dart';

class MenuRouteOptions {
  final RouteSettings? routeSettings;
  final bool? requestFocus;
  final RouteTransitionsBuilder transitionsBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;
  final bool allowSnapshotting;

  const MenuRouteOptions({
    this.routeSettings,
    this.requestFocus,
    this.transitionsBuilder = _defaultTransitionsBuilder,
    this.transitionDuration = Duration.zero,
    this.reverseTransitionDuration = Duration.zero,
    this.opaque = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.allowSnapshotting = true,
  });

  MenuRouteOptions copyWith({
    RouteSettings? routeSettings,
    bool? requestFocus,
    RouteTransitionsBuilder? transitionsBuilder,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    bool? opaque,
    bool? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MenuRouteOptions(
      routeSettings: routeSettings ?? this.routeSettings,
      requestFocus: requestFocus ?? this.requestFocus,
      transitionsBuilder: transitionsBuilder ?? this.transitionsBuilder,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? this.reverseTransitionDuration,
      opaque: opaque ?? this.opaque,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierColor: barrierColor ?? this.barrierColor,
      barrierLabel: barrierLabel ?? this.barrierLabel,
      maintainState: maintainState ?? this.maintainState,
      allowSnapshotting: allowSnapshotting ?? this.allowSnapshotting,
    );
  }
}

Widget _defaultTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return child;
}
