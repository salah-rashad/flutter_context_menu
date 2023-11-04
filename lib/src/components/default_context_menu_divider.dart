import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../widgets/context_menu_state.dart';
import 'default_context_menu_item.dart';
import 'default_context_menu_text_header.dart';

/// Represents a divider in a context menu.
///
/// This class is used to define a divider that can be displayed within a context menu.
///
/// #### Parameters:
/// - [height] - The height of the divider.
/// - [thickness] - The thickness of the divider.
/// - [indent] - The indent of the divider.
/// - [endIndent] - The end indent of the divider.
/// - [color] - The color of the divider.
///
/// see:
/// - [ContextMenuEntry]
/// - [DefaultContextMenuTextHeader]
/// - [DefaultContextMenuItem]
///
class DefaultContextMenuDivider extends ContextMenuEntry {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const DefaultContextMenuDivider({
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  })  : assert(height == null || height >= 0.0),
        assert(thickness == null || thickness >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0);

  @override
  Widget builder(BuildContext context, ContextMenuState menuState) {
    return Divider(
      height: height ?? 8.0,
      thickness: thickness ?? 0.0,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
