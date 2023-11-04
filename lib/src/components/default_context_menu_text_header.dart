import 'package:flutter/material.dart';

import '../core/utils/extensions.dart';
import '../core/models/context_menu_entry.dart';
import '../widgets/context_menu_state.dart';
import 'default_context_menu_divider.dart';
import 'default_context_menu_item.dart';

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
/// - [DefaultContextMenuDivider]
/// - [DefaultContextMenuItem]
/// 
class DefaultContextMenuTextHeader extends ContextMenuEntry {
  final String text;
  final bool disableUppercase;

  const DefaultContextMenuTextHeader({
    required this.text,
    this.disableUppercase = false,
  });

  @override
  Widget builder(BuildContext context, ContextMenuState menuState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          disableUppercase ? text : text.toUpperCase(),
          style: context.textTheme.labelMedium?.copyWith(
            color: context.theme.disabledColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
