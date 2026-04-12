import 'package:flutter/material.dart';

import '../core/models/checkable_controller.dart';
import '../core/models/context_menu_checkable_item.dart';
import '../core/utils/extensions/build_context_ext.dart';
import '../core/utils/extensions/single_activator_ext.dart';
import '../widgets/context_menu_state.dart';
import 'menu_item.dart';

/// A concrete checkable menu entry with check indicator, label, and styling.
///
/// Displays a checkmark (or custom icon) when checked.
/// The menu remains open after toggling.
///
/// **Simple usage** — state managed internally:
/// ```dart
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   checked: false,
///   onToggle: (value) => print('Grid: $value'),
/// )
/// ```
///
/// **Advanced usage** — external state access via [CheckableController]:
/// ```dart
/// final gridController = CheckableController(initialValue: false);
/// // ...
/// CheckableMenuItem(
///   label: const Text('Show grid'),
///   controller: gridController,
/// )
/// // Listen from outside:
/// ValueListenableBuilder<bool>(
///   valueListenable: gridController,
///   builder: (context, isChecked, child) => ...,
/// )
/// ```
///
/// #### Parameters:
/// - [label] - The title of the checkable menu item (required)
/// - [checked] - Initial checked state when no [controller] is provided
/// - [controller] - Optional controller for external state access/listening
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
/// - [CheckableController]
/// - [MenuItem]
///
final class CheckableMenuItem<T> extends ContextMenuCheckableItem<T> {
  /// Optional custom check indicator widget.
  ///
  /// When checked, this widget is displayed in the leading icon area.
  /// If `null`, a default checkmark icon (`Icons.check`) is shown.
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
  /// For external state access, provide a [controller].
  const CheckableMenuItem({
    this.icon,
    required this.label,
    this.shortcut,
    this.trailing,
    super.checked,
    super.controller,
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
    return _CheckableMenuItemWidget<T>(
      entry: this,
      menuState: menuState,
    );
  }
}

/// Internal StatefulWidget that manages the effective [CheckableController].
///
/// If the entry provides a [CheckableController], it is used directly.
/// Otherwise, an internal controller is created from the entry's [checked]
/// value and disposed when the widget is removed from the tree.
class _CheckableMenuItemWidget<T> extends StatefulWidget {
  final CheckableMenuItem<T> entry;
  final ContextMenuState<T> menuState;

  const _CheckableMenuItemWidget({
    required this.entry,
    required this.menuState,
  });

  @override
  State<_CheckableMenuItemWidget<T>> createState() =>
      _CheckableMenuItemWidgetState<T>();
}

class _CheckableMenuItemWidgetState<T>
    extends State<_CheckableMenuItemWidget<T>> {
  CheckableController? _internalController;

  CheckableController get _effectiveController =>
      widget.entry.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.entry.controller == null) {
      _internalController =
          CheckableController(initialValue: widget.entry.checked);
    }
    widget.menuState.registerActivator(widget.entry, _handleToggle);
  }

  @override
  void didUpdateWidget(covariant _CheckableMenuItemWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entry != oldWidget.entry) {
      oldWidget.menuState.unregisterActivator(oldWidget.entry);
      widget.menuState.registerActivator(widget.entry, _handleToggle);
    }
  }

  @override
  void dispose() {
    widget.menuState.unregisterActivator(widget.entry);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleToggle() {
    if (!widget.entry.enabled) return;
    _effectiveController.toggle();
    widget.entry.onToggle?.call(_effectiveController.value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _effectiveController,
      builder: (context, isChecked, child) {
        return _buildContent(context, isChecked);
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isChecked) {
    final entry = widget.entry;
    final menuState = widget.menuState;
    final isFocused = menuState.focusedEntry == entry;

    final background = context.colorScheme.surface;
    final focusedBackground = context.colorScheme.surfaceContainer;
    final adjustedTextColor = Color.alphaBlend(
      context.colorScheme.onSurface.withValues(alpha: 0.7),
      background,
    );
    final normalTextColor = entry.textColor ?? adjustedTextColor;
    final focusedTextColor = entry.textColor ?? context.colorScheme.onSurface;
    final disabledTextColor =
        context.colorScheme.onSurface.withValues(alpha: 0.2);
    final foregroundColor = !entry.enabled
        ? disabledTextColor
        : isFocused
            ? focusedTextColor
            : normalTextColor;
    final textStyle = TextStyle(color: foregroundColor, height: 1.0);
    final leadingIconThemeData =
        IconThemeData(size: 16.0, color: foregroundColor);

    // ~~~~~~~~~~ //

    return ConstrainedBox(
      constraints: entry.constraints ??
          const BoxConstraints.expand(height: kMenuItemHeight),
      child: Material(
        color: !entry.enabled
            ? Colors.transparent
            : isFocused
                ? focusedBackground
                : background,
        borderRadius: BorderRadius.circular(4.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: !entry.enabled
              ? null
              : () => widget.menuState.activateEntry(entry),
          canRequestFocus: false,
          hoverColor: Colors.transparent,
          child: Row(
            children: [
              SizedBox.square(
                dimension: kMenuItemIconSize,
                child: isChecked
                    ? IconTheme(
                        data: leadingIconThemeData,
                        child: entry.icon ?? const Icon(Icons.check),
                      )
                    : null,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DefaultTextStyle(
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: entry.label,
                ),
              ),
              if (entry.shortcut != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 32.0),
                  child: DefaultTextStyle(
                      style: textStyle.apply(
                        color: adjustedTextColor.withValues(alpha: 0.6),
                      ),
                      child: Text(entry.shortcut!.toKeyString())),
                ),
              const SizedBox(width: 8.0),
              entry.trailing ??
                  const SizedBox.square(dimension: kMenuItemIconSize)
            ],
          ),
        ),
      ),
    );
  }
}
