import 'package:flutter/material.dart';

import '../core/utils/extensions.dart';
import '../core/models/context_menu_entry.dart';
import '../widgets/context_menu_state.dart';

// generate doc comment explaining this class
//
/// Represents a text header in a context menu.
///
/// The [DefaultContextMenuTextHeader] class is used to define a text header that can be displayed in a context menu.
/// It extends the [ContextMenuEntry] class, providing additional functionality for displaying the text header.
///
/// The [text] parameter is the text to display in the header.
///
/// The [disableUppercase] parameter is a flag that determines whether the text should be displayed in uppercase.
///
/// When the [DefaultContextMenuTextHeader] is displayed in a context menu, it will be displayed in a text header format.
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
