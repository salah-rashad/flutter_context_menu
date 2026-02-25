import 'package:flutter/widgets.dart';

import 'context_menu_state.dart';

class ContextMenuProvider<T> extends InheritedNotifier<ContextMenuState<T>> {
  const ContextMenuProvider({
    super.key,
    required super.child,
    required ContextMenuState<T> state,
  }) : super(notifier: state);
}
