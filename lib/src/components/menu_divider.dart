import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/menu_divider_style.dart';
import '../widgets/provider/context_menu_state.dart';
import '../widgets/theme/context_menu_theme.dart';
import 'menu_header.dart';
import 'menu_item.dart';

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
/// - [MenuHeader]
/// - [MenuItem]
///
final class MenuDivider extends ContextMenuEntry<Never> {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const MenuDivider({
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
    final style = ContextMenuTheme.resolve(context).menuDividerStyle ??
        const MenuDividerStyle();

    // Precedence chain for each property (highest to lowest priority):
    // 1. Constructor parameter (inline override) - e.g., this.height
    // 2. Style value - e.g., style.height
    // 3. Default value - e.g., 8.0 for height
    //
    // This allows fine-grained control: a single property can be overridden
    // inline while others still use style values.
    return Divider(
      height: height ?? style.height ?? 8.0,
      thickness: thickness ?? style.thickness ?? 0.0,
      indent: indent ?? style.indent,
      endIndent: endIndent ?? style.endIndent,
      color: color ?? style.color,
    );
  }
}
