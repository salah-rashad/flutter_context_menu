import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions/build_context_ext.dart';
import '../core/utils/extensions/single_activator_ext.dart';
import '../widgets/context_menu_state.dart';
import 'menu_divider.dart';
import 'menu_header.dart';

const double kMenuItemHeight = 32.0;
const double kMenuItemIconSize = 32.0;

/// Represents a selectable item in a context menu.
///
/// This class is used to define individual items that can be displayed within
/// a context menu.
///
/// #### Parameters:
/// - [label] - The title of the context menu item
/// - [icon] - The leading icon of the context menu item.
/// - [shortcut] - The shortcut of the context menu item.
/// - [trailing] - The trailing icon of the context menu item.
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
/// - [textColor] - The text an icon foreground color
///
/// see:
/// - [ContextMenuEntry]
/// - [MenuHeader]
/// - [MenuDivider]
///
final class MenuItem<T> extends ContextMenuItem<T> {
  final Widget? icon;
  final Widget label;
  final SingleActivator? shortcut;
  final Widget? trailing;
  final BoxConstraints? constraints;
  final Color? textColor;

  const MenuItem({
    this.icon,
    required this.label,
    this.shortcut,
    this.trailing,
    super.value,
    super.onSelected,
    super.enabled,
    this.constraints,
    this.textColor,
  });

  const MenuItem.submenu({
    this.icon,
    required this.label,
    required List<ContextMenuEntry<T>> items,
    this.shortcut,
    this.trailing,
    super.onSelected,
    super.enabled,
    this.constraints,
    this.textColor,
  }) : super.submenu(items: items);

  @override
  String get debugLabel => "${super.debugLabel} - $label";

  @override
  Widget builder(BuildContext context, ContextMenuState menuState,
      [FocusNode? focusNode]) {
    bool isFocused = menuState.focusedEntry == this;

    final background = context.colorScheme.surface;
    final focusedBackground = context.colorScheme.surfaceContainer;
    final adjustedTextColor = Color.alphaBlend(
      context.colorScheme.onSurface.withValues(alpha: 0.7),
      background,
    );
    final normalTextColor = textColor ?? adjustedTextColor;
    final focusedTextColor = textColor ?? context.colorScheme.onSurface;
    final disabledTextColor =
        context.colorScheme.onSurface.withValues(alpha: 0.2);
    final foregroundColor = !enabled
        ? disabledTextColor
        : isFocused
            ? focusedTextColor
            : normalTextColor;
    final textStyle = TextStyle(color: foregroundColor, height: 1.0);
    final leadingIconThemeData =
        IconThemeData(size: 16.0, color: normalTextColor);
    final trailingIconThemeData =
        IconThemeData(size: 16.0, color: normalTextColor);

    // ~~~~~~~~~~ //

    return ConstrainedBox(
      constraints:
          constraints ?? const BoxConstraints.expand(height: kMenuItemHeight),
      child: Material(
        color: !enabled
            ? Colors.transparent
            : isFocused
                ? focusedBackground
                : background,
        borderRadius: BorderRadius.circular(4.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap:
              !enabled ? null : () => handleItemSelection(context, menuState),
          canRequestFocus: false,
          hoverColor: Colors.transparent,
          child: Row(
            children: [
              SizedBox.square(
                dimension: kMenuItemIconSize,
                child: icon != null
                    ? IconTheme(
                        data: leadingIconThemeData,
                        child: icon!,
                      )
                    : null,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DefaultTextStyle(
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: label,
                ),
              ),
              if (shortcut != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 32.0),
                  child: DefaultTextStyle(
                      style: textStyle.apply(
                        color: adjustedTextColor.withValues(alpha: 0.6),
                      ),
                      child: Text(shortcut!.toKeyString())),
                ),
              const SizedBox(width: 8.0),
              trailing ??
                  SizedBox.square(
                    dimension: kMenuItemIconSize,
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: IconTheme(
                        data: trailingIconThemeData,
                        child: Icon(
                          isSubmenuItem ? Icons.arrow_right : null,
                        ),
                      ),
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
