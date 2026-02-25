import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/menu_header_style.dart';
import '../widgets/provider/context_menu_state.dart';
import '../widgets/theme/context_menu_theme.dart';
import 'menu_divider.dart';
import 'menu_item.dart';

/// Represents a text header in a context menu.
///
/// This class is used to define a header that can be displayed within a context menu.
///
/// #### Parameters:
/// - [text] - The text of the header.
/// - [disableUppercase] - Whether to disable the text in uppercase.
///
/// see:
/// - [ContextMenuEntry]
/// - [MenuDivider]
/// - [MenuItem]
///
final class MenuHeader extends ContextMenuEntry<Never> {
  final String text;
  final bool disableUppercase;

  const MenuHeader({
    required this.text,
    this.disableUppercase = false,
  });

  @override
  Widget builder(BuildContext context, ContextMenuState menuState) {
    final style = ContextMenuTheme.resolve(context).menuHeaderStyle ??
        const MenuHeaderStyle();

    // Resolve styled values with fallback to defaults
    final textStyle =
        style.textStyle ?? Theme.of(context).textTheme.labelMedium;
    final textColor = style.textColor ??
        Theme.of(context).disabledColor.withValues(alpha: 0.3);
    final padding = style.padding ?? const EdgeInsets.all(8.0);

    return Padding(
      padding: padding,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          disableUppercase ? text : text.toUpperCase(),
          style: textStyle?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
