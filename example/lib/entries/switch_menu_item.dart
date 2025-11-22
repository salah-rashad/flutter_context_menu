import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// A custom menu item that includes a switch widget
///
/// This demonstrates how to create a custom menu item by extending [ContextMenuItem]
final class SwitchMenuItem extends ContextMenuItem<bool> {
  final String label;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? textColor;
  late final ValueNotifier<bool> _value;

  @override
  bool get value => _value.value;

  updateValue(bool value) {
    _value.value = value;
  }

  SwitchMenuItem({
    required this.label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    this.icon,
    this.textStyle,
    this.textColor,
    super.enabled = true,
  }) : super(onSelected: onChanged, value: value) {
    _value = ValueNotifier(value);
  }

  @override
  Widget builder(BuildContext context, ContextMenuState state,
      [FocusNode? focusNode]) {
    final theme = Theme.of(context);
    final textColor = this.textColor ?? theme.colorScheme.onSurface;
    final textStyle = this.textStyle ?? theme.textTheme.titleMedium;

    return InkWell(
      onTap: () {
        updateValue(!value);
        handleItemSelection(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (icon != null) ...[
              IconTheme.merge(
                data: IconThemeData(
                  color: enabled ? textColor : textColor.withValues(alpha: 0.5),
                  size: 20,
                ),
                child: icon!,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: textStyle?.copyWith(
                  color: enabled ? textColor : textColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(
              value: value,
              onChanged: enabled
                  ? (newValue) {
                      updateValue(newValue);
                      handleItemSelection(context);
                    }
                  : null,
              activeThumbColor: theme.colorScheme.primary,
              activeTrackColor:
                  theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
