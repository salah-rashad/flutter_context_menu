import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../widgets/context_menu_state.dart';
import 'menu_divider.dart';
import 'menu_header.dart';

/// Represents a selectable item in a context menu.
///
/// This class is used to define individual items that can be displayed within
/// a context menu.
///
/// #### Parameters:
/// - [label] - The title of the context menu item
/// - [icon] - The icon of the context menu item.
/// - [constraints] - The height of the context menu item.
/// - [focusNode] - The focus node of the context menu item.
/// - [value] - The value associated with the context menu item.
/// - [items] - The list of subitems associated with the context menu item.
/// - [onSelected] - The callback that is triggered when the context menu item
///   is selected. If the item has subitems, it toggles the visibility of the
///   submenu. If not, it pops the current context menu and returns the
///   associated value.
/// - [constraints] - The constraints of the context menu item.
/// - [enabled] - Whether the context menu item is selectable or not.
/// - [color] - The text an icon foreground color
///
/// see:
/// - [ContextMenuEntry]
/// - [MenuHeader]
/// - [MenuDivider]
///
final class MenuItem<T> extends ContextMenuItem<T> {
  final String label;
  final IconData? icon;
  final BoxConstraints? constraints;
  final Color? color;

  const MenuItem({
    required this.label,
    this.icon,
    super.value,
    super.onSelected,
    super.enabled,
    this.constraints,
    this.color,
  });

  const MenuItem.submenu({
    required this.label,
    required List<ContextMenuEntry> items,
    this.icon,
    super.onSelected,
    super.enabled,
    this.constraints,
    this.color,
  }) : super.submenu(items: items);

  @override
  Widget builder(BuildContext context, ContextMenuState menuState,
      Color? surface, Color? surfaceContainer,
      [FocusNode? focusNode]) {
    bool isFocused = menuState.focusedEntry == this;

    final background = surface ?? context.colorScheme.surface;
    final focusedBackground =
        surfaceContainer ?? context.colorScheme.surfaceContainer;
    final normalTextColor = Color.alphaBlend(
      (color ?? context.colorScheme.onSurface).withValues(alpha: 0.7),
      background,
    );
    final focusedTextColor = color ?? context.colorScheme.onSurface;
    final disabledTextColor =
        context.colorScheme.onSurface.withValues(alpha: 0.2);
    final foregroundColor = !enabled
        ? disabledTextColor
        : isFocused
            ? focusedTextColor
            : normalTextColor;
    final textStyle = TextStyle(color: foregroundColor, height: 1.0);

    // ~~~~~~~~~~ //

    return ConstrainedBox(
      constraints: constraints ?? const BoxConstraints.expand(height: 32.0),
      child: Material(
        color: !enabled
            ? Colors.transparent
            : isFocused
                ? focusedBackground
                : background,
        borderRadius: BorderRadius.circular(4.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: !enabled ? null : () => handleItemSelection(context),
          canRequestFocus: false,
          child: DefaultTextStyle(
            style: textStyle,
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 32.0,
                  child: Icon(
                    icon,
                    size: 16.0,
                    color: foregroundColor,
                  ),
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox.square(
                  dimension: 32.0,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(
                      isSubmenuItem ? Icons.arrow_right : null,
                      size: 16.0,
                      color: foregroundColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get debugLabel => "[${hashCode.toString().substring(0, 5)}] $label";
}
