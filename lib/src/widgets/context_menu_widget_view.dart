import 'package:flutter/material.dart';

import '../../flutter_context_menu.dart';
import '../core/utils/extensions.dart';
import '../core/utils/utils.dart';
import 'menu_entry_widget.dart';

class ContextMenuWidgetView extends StatelessWidget {
  final ContextMenu menu;
  final AlignmentGeometry spawnAnchor;

  const ContextMenuWidgetView(
      {super.key, required this.menu, required this.spawnAnchor});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: context.colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: context.theme.shadowColor.withValues(alpha: 0.5),
          offset: const Offset(0.0, 2.0),
          blurRadius: 10,
          spreadRadius: -1,
        )
      ],
      borderRadius: menu.borderRadius ?? BorderRadius.circular(4.0),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.8,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 60),
      builder: (context, value, child) {
        return Transform.scale(
          alignment: spawnAnchor,
          scale: value,
          child: Container(
            padding: menu.padding,
            constraints: BoxConstraints(
              maxWidth: menu.maxWidth,
              maxHeight: menu.maxHeight ??
                  MediaQuery.of(context).size.height -
                      (kContextMenuSafeArea * 2),
            ),
            clipBehavior: menu.clipBehavior,
            decoration: menu.boxDecoration ?? boxDecoration,
            child: Material(
              type: MaterialType.transparency,
              child: IntrinsicWidth(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in menu.entries)
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
