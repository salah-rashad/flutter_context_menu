import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

final class CustomContextMenuItem<T> extends ContextMenuItem<T> {
  final String label;
  final String? subtitle;
  final IconData? icon;

  const CustomContextMenuItem({
    required this.label,
    super.value,
    super.onSelected,
    this.subtitle,
    this.icon,
  });

  const CustomContextMenuItem.submenu({
    required this.label,
    required super.items,
    this.subtitle,
    this.icon,
  }) : super.submenu();

  @override
  bool get autoHandleFocus => false;

  @override
  String get debugLabel => "${super.debugLabel} - $label";

  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]) {
    return ListTile(
      // important for highlighting item on focus
      focusNode: focusNode,
      title: SizedBox(width: double.maxFinite, child: Text(label)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: () => handleItemSelection(context, menuState),
      trailing: Icon(isSubmenuItem ? Icons.arrow_right : null),
      leading: Icon(icon),
      dense: false,
      selected: menuState.isOpened(this),
      selectedColor: Colors.white,
      selectedTileColor: Colors.blue,
    );
  }
}
