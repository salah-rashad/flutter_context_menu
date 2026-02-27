import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A labeled text input that fires [onSubmit] on Enter or focus loss.
class PropertyTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String> onSubmit;

  const PropertyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label).xSmall().semiBold(),
        const SizedBox(height: 2),
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) onSubmit(controller.text);
          },
          child: TextField(
            controller: controller,
            placeholder: hint != null ? Text(hint!) : null,
            onSubmitted: onSubmit,
          ),
        ),
      ],
    );
  }
}

/// A labeled number input with an optional clear button.
/// Fires [onSubmit] with a parsed [double?] on Enter or focus loss.
class PropertyNumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<double?> onSubmit;
  final VoidCallback onClear;

  const PropertyNumberField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    required this.onSubmit,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label).xSmall().semiBold(),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) onSubmit(double.tryParse(controller.text));
                },
                child: TextField(
                  controller: controller,
                  placeholder: hint != null ? Text(hint!) : null,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onSubmitted: (text) => onSubmit(double.tryParse(text)),
                ),
              ),
            ),
            if (hasValue)
              GhostButton(
                onPressed: () {
                  controller.clear();
                  onClear();
                },
                density: ButtonDensity.icon,
                child: const Icon(LucideIcons.x, size: 14),
              ),
          ],
        ),
      ],
    );
  }
}

/// A labeled toggle switch.
class PropertySwitchField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PropertySwitchField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label).xSmall()),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
