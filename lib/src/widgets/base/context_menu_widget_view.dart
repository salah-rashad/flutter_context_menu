import 'package:flutter/material.dart';

import '../../../flutter_context_menu.dart';
import 'menu_entry_widget.dart';

class ContextMenuWidgetView<T> extends StatelessWidget {
  final ContextMenu<T> menu;
  final AlignmentGeometry spawnAnchor;

  const ContextMenuWidgetView(
      {super.key, required this.menu, required this.spawnAnchor});

  @override
  Widget build(BuildContext context) {
    // Style resolution follows a four-level precedence chain:
    //
    // 1. menu.style (per-instance override) - HIGHEST PRIORITY
    //    Individual properties in menu.style override corresponding properties
    //    from the resolved style. Null properties fall back to resolved values.
    //
    // 2. ContextMenuTheme widget (InheritedWidget)
    //    A widget-level style that applies to all descendant menus.
    //
    // 3. ThemeExtension<ContextMenuStyle> on ThemeData
    //    A global style defined via ThemeData.extensions.
    //
    // 4. ContextMenuStyle.fallback() - LOWEST PRIORITY
    //    Default values derived from ColorScheme when no style is configured.
    //
    // The effective style is computed by merging menu.style on top of the
    // resolved style, allowing fine-grained property overrides.
    final style = ContextMenuTheme.resolve(context).merge(menu.style);

    // Resolve styled values - all properties are guaranteed non-null after merge
    final surfaceColor = style.surfaceColor!;
    final shadowColor = style.shadowColor!;
    final shadowOffset = style.shadowOffset!;
    final shadowBlurRadius = style.shadowBlurRadius!;
    final shadowSpreadRadius = style.shadowSpreadRadius!;
    final borderRadius = style.borderRadius!;
    final maxWidth = style.maxWidth!;
    final maxHeight = style.maxHeight!;
    final padding = style.padding;
    final clipBehavior = menu.clipBehavior ?? Clip.antiAlias;

    // Build the decoration from resolved style values.
    // To fully override the decoration, provide menu.style with custom
    // surfaceColor, shadowColor, shadowOffset, etc.
    final boxDecoration = BoxDecoration(
      color: surfaceColor,
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: shadowOffset,
          blurRadius: shadowBlurRadius,
          spreadRadius: shadowSpreadRadius,
        )
      ],
      borderRadius: borderRadius,
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
            padding: padding,
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            clipBehavior: clipBehavior,
            decoration: boxDecoration,
            child: Material(
              type: MaterialType.transparency,
              child: IntrinsicWidth(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in menu.entries)
                        MenuEntryWidget<T>(entry: item)
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
