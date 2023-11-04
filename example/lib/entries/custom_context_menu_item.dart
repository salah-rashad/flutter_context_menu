import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

class CustomContextMenuItem extends ContextMenuItem<String> {
  final String label;

  CustomContextMenuItem({
    required this.label,
    super.value,
    super.onSelected,
  });

  CustomContextMenuItem.submenu({
    required this.label,
    required super.items,
  }) : super.submenu();

  @override
  Widget builder(BuildContext context, ContextMenuState menuState) {
    return ListTile(
      title: Text(label),
      onTap: () => handleItemSelection(context),
      trailing: Icon(isSubmenuItem ? Icons.arrow_right : null),
      dense: false,
    );
  }
}
