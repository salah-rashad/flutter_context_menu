import 'package:flutter/material.dart';

import '../core/enums/menu_item_state.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/style/menu_item_style.dart';
import '../core/utils/extensions/build_context_ext.dart';
import '../core/utils/extensions/color_ext.dart';
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
/// - [foregroundColor] - The text an icon foreground color
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
  final MenuItemStyle? style;

  const MenuItem({
    this.icon,
    required this.label,
    this.shortcut,
    this.trailing,
    super.value,
    super.onSelected,
    super.enabled,
    this.constraints,
    this.style,
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
    this.style,
  }) : super.submenu(items: items);

  @override
  String get debugLabel => "${super.debugLabel} - $label";

  @override
  bool get autoHandleFocus => false;

  @override
  Widget builder(BuildContext context, ContextMenuState menuState,
      [FocusNode? focusNode]) {
    // bool isFocused = menuState.focusedEntry == this;
    //
    // final normalBackgroundColor = context.colorScheme.surface;
    //
    // final fallbackTextColor = Color.alphaBlend(
    //   context.colorScheme.onSurface.withValues(alpha: 0.7),
    //   normalBackgroundColor,
    // );
    // final normalForegroundColor = this.foregroundColor ?? fallbackTextColor;
    // final focusedForegroundColor =
    //     this.focusedForegroundColor ?? normalForegroundColor;
    // final disabledForegroundColor =
    //     context.colorScheme.onSurface.withValues(alpha: 0.2);
    //
    // final focusedBackground = Color.alphaBlend(
    //   focusedForegroundColor.withValues(alpha: 0.02),
    //   context.colorScheme.surfaceContainer,
    // );
    //
    // final foregroundColor = !enabled
    //     ? disabledForegroundColor
    //     : isFocused
    //         ? focusedForegroundColor
    //         : normalForegroundColor;
    //
    // final backgroundColor = !enabled
    //     ? Colors.transparent
    //     : isFocused
    //         ? focusedBackground
    //         : normalBackgroundColor;
    //
    // final highlightColor = normalForegroundColor.withValues(alpha: 0.1);
    // final splashColor = normalForegroundColor.withValues(alpha: 0.1);

    bool isFocused = menuState.focusedEntry == this;

    final state = !enabled
        ? MenuItemState.disabled
        : isFocused
            ? MenuItemState.focused
            : MenuItemState.normal;

    final colors = _buildMenuItemColors(
      context,
      menuState: menuState,
      customStyle: style,
    );

    final foreground = colors.foreground(state);
    final background = colors.background(state);

    final textStyle = TextStyle(color: foreground, height: 1.0);
    final leadingIconThemeData = IconThemeData(size: 16.0, color: foreground);
    final trailingIconThemeData = IconThemeData(size: 16.0, color: foreground);

    // ~~~~~~~~~~ //

    return ConstrainedBox(
      constraints:
          constraints ?? const BoxConstraints.expand(height: kMenuItemHeight),
      child: Material(
        color: menuState.isOpened(this) ? colors.focusColor : background,
        borderRadius: BorderRadius.circular(4.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          enableFeedback: true,
          focusNode: focusNode,
          onTap: !enabled ? null : () => handleItemSelection(context),
          canRequestFocus: true,
          hoverColor: colors.hoverColor,
          highlightColor: colors.highlightColor,
          splashColor: colors.splashColor,
          focusColor: colors.focusColor,
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
                        color: colors.shortcutTextColor,
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

  MenuItemStyle _buildMenuItemColors(
    BuildContext context, {
    required ContextMenuState menuState,
    required MenuItemStyle? customStyle,
  }) {
    final scheme = context.colorScheme;

    final menuBg = menuState.menu.boxDecoration?.color ?? scheme.surface;

    final defaultFgColor = scheme.onSurface;
    final fgNormal = defaultFgColor.blendOn(menuBg, 0.7);

    final baseStyle = MenuItemStyle(
      fgColor: fgNormal,
      fgFocusedColor: defaultFgColor,
      fgDisabledColor: defaultFgColor.applyOpacity(0.2),
      bgColor: null,
      bgDisabledColor: null,
      hoverColor: fgNormal.applyOpacity(0.08),
      focusColor: fgNormal.applyOpacity(0.1),
      splashColor: fgNormal.applyOpacity(0.1),
      highlightColor: fgNormal.applyOpacity(0.1),
      shortcutTextColor: fgNormal.applyOpacity(0.6),
    );

    final tint = (customStyle?.bgColor ??
        customStyle?.fgNormalColor ??
        baseStyle.fgNormalColor);

    final customOverlayStyle = MenuItemStyle(
      fgFocusedColor: customStyle?.fgNormalColor ?? baseStyle.fgFocusedColor,
      splashColor: tint?.applyOpacity(0.08),
      highlightColor: tint?.applyOpacity(0.06),
      hoverColor: tint?.blendOn(scheme.surfaceContainer, 0.04),
      focusColor: tint?.blendOn(scheme.surfaceContainer, 0.05),
    );

    return baseStyle.merge(customOverlayStyle).merge(customStyle);
  }
}
