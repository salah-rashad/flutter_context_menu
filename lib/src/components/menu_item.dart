import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/models/menu_item_style.dart';
import '../core/utils/extensions/build_context_ext.dart';
import '../core/utils/extensions/single_activator_ext.dart';
import '../widgets/provider/context_menu_state.dart';
import '../widgets/theme/context_menu_theme.dart';
import 'menu_divider.dart';
import 'menu_header.dart';

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
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]) {
    final bool isFocused = menuState.focusedEntry == this;

    // Resolve effective theme using ContextMenuTheme.resolve()
    // Precedence: fallback -> ThemeExtension -> ContextMenuTheme widget
    final effectiveStyle = ContextMenuTheme.resolve(context);
    final MenuItemStyle? itemStyle = effectiveStyle.menuItemStyle;

    // Resolve colors with theme values and ColorScheme fallbacks
    final colorScheme = context.colorScheme;

    // Background colors
    final background = itemStyle?.backgroundColor ?? Colors.transparent;

    final adjustedFocusedBackgroundColor = Color.alphaBlend(
      colorScheme.surfaceContainer.withValues(alpha: 0.7),
      background,
    );

    final focusedBackground =
        itemStyle?.focusedBackgroundColor ?? adjustedFocusedBackgroundColor;

    // Text colors - compute adjusted text color by blending with background
    final adjustedTextColor = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: 0.7),
      background,
    );

    // Apply precedence: inline textColor > theme textColor > computed default
    final resolvedTextColor =
        textColor ?? itemStyle?.textColor ?? adjustedTextColor;
    final resolvedFocusedTextColor =
        textColor ?? itemStyle?.focusedTextColor ?? colorScheme.onSurface;
    final resolvedDisabledTextColor = itemStyle?.disabledTextColor ??
        colorScheme.onSurface.withValues(alpha: 0.2);

    // Determine effective foreground color based on state
    final foregroundColor = !enabled
        ? resolvedDisabledTextColor
        : isFocused
            ? resolvedFocusedTextColor
            : resolvedTextColor;

    // Icon styling
    final iconColor = itemStyle?.iconColor ?? foregroundColor;
    final iconSize = itemStyle?.iconSize ?? 16.0;

    // Shortcut text opacity
    // Shortcut text color: explicit shortcutTextColor > resolvedTextColor with opacity
    final shortcutOpacity = itemStyle?.shortcutTextOpacity ?? 0.4;
    final resolvedShortcutTextColor = itemStyle?.shortcutTextColor ??
        resolvedTextColor.withValues(alpha: shortcutOpacity);

    // Item dimensions
    final itemHeight = itemStyle?.height ?? kMenuItemHeight;
    final itemBorderRadius =
        itemStyle?.borderRadius ?? BorderRadius.circular(4.0);

    final textStyle = TextStyle(color: foregroundColor, height: 1.0);
    final leadingIconThemeData =
        IconThemeData(size: iconSize, color: iconColor);
    final trailingIconThemeData =
        IconThemeData(size: iconSize, color: iconColor);

    // ~~~~~~~~~~ //

    return ConstrainedBox(
      constraints: constraints ?? BoxConstraints.expand(height: itemHeight),
      child: Material(
        animateColor: true,
        color: !enabled
            ? Colors.transparent
            : isFocused
                ? focusedBackground
                : background,
        borderRadius: itemBorderRadius,
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
                        color: resolvedShortcutTextColor,
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
