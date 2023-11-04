import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../widgets/context_menu_state.dart';

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
