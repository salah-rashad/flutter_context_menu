import 'package:flutter/material.dart';

import '../core/models/context_menu_checkable_item.dart';
import '../core/utils/extensions/build_context_ext.dart';
import '../core/utils/extensions/single_activator_ext.dart';
import '../widgets/context_menu_state.dart';
import 'menu_item.dart';

/// A concrete checkable menu entry with check indicator, label, and styling.
///
/// Displays a checkmark (or custom icon) when [checked] is true.
/// The menu remains open after toggling.
///
/// Example:
/// ```dart
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   checked: showGrid,
///   onToggle: (value) => setState(() => showGrid = value),
/// )
/// ```
///
/// For reactive updates while the menu is open, use [checkedNotifier]:
/// ```dart
/// final showGridNotifier = ValueNotifier<bool>(false);
/// // ...
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   checkedNotifier: showGridNotifier,
///   onToggle: (value) => showGridNotifier.value = value,
/// )
/// ```
///
/// #### Parameters:
/// - [label] - The title of the checkable menu item (required)
/// - [checked] - Whether the item is currently checked (defaults to `false`)
/// - [checkedNotifier] - Optional notifier for reactive updates while menu is open
/// - [onToggle] - Callback when the checked state changes
/// - [icon] - Optional custom check indicator (defaults to `Icons.check`)
/// - [shortcut] - Keyboard shortcut to display
/// - [trailing] - Optional trailing widget
/// - [constraints] - Optional size constraints
/// - [enabled] - Whether the item is interactive (defaults to `true`)
/// - [textColor] - Optional text and icon foreground color
///
/// see:
/// - [ContextMenuCheckableItem]
/// - [MenuItem]
///
final class CheckableMenuItem<T> extends ContextMenuCheckableItem<T> {
  /// Optional custom check indicator widget.
  ///
  /// When [checked] is `true`, this widget is displayed in the leading
  /// icon area. If `null`, a default checkmark icon (`Icons.check`) is shown.
  final Widget? icon;

  /// The label widget displayed for this menu item.
  final Widget label;

  /// Optional keyboard shortcut to display alongside the label.
  final SingleActivator? shortcut;

  /// Optional widget displayed at the trailing edge of the menu item.
  final Widget? trailing;

  /// Optional constraints for the menu item size.
  final BoxConstraints? constraints;

  /// Optional color for the text and icons.
  final Color? textColor;

  /// Creates a checkable menu item.
  ///
  /// The [label] parameter is required.
  /// The [checked] parameter defaults to `false`.
  /// The [enabled] parameter defaults to `true`.
  /// For reactive updates, provide [checkedNotifier] instead of [checked].
  const CheckableMenuItem({
    this.icon,
    required this.label,
    this.shortcut,
    this.trailing,
    super.checked,
    super.checkedNotifier,
    super.onToggle,
    super.enabled,
    this.constraints,
    this.textColor,
  });

  @override
  String get debugLabel => "${super.debugLabel} - $label";

  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]) {
    // If a notifier is provided, use ValueListenableBuilder for reactive updates
    if (checkedNotifier != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: checkedNotifier!,
        builder: (context, value, child) {
          return _buildContent(context, menuState, value);
        },
      );
    }

    return _buildContent(context, menuState, checked);
  }

  Widget _buildContent(
      BuildContext context, ContextMenuState<T> menuState, bool isChecked) {
    final isFocused = menuState.focusedEntry == this;

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
        IconThemeData(size: 16.0, color: foregroundColor);

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
                child: isChecked
                    ? IconTheme(
                        data: leadingIconThemeData,
                        child: icon ?? const Icon(Icons.check),
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
              trailing ?? const SizedBox.square(dimension: kMenuItemIconSize)
            ],
          ),
        ),
      ),
    );
  }
}
