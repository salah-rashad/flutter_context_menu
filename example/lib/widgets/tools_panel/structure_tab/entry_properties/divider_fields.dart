import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'property_field_widgets.dart';

/// Property fields for a [EntryType.divider] entry.
class DividerFields extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController thicknessController;
  final TextEditingController indentController;
  final TextEditingController endIndentController;
  final ValueChanged<double?> onHeightSubmit;
  final ValueChanged<double?> onThicknessSubmit;
  final ValueChanged<double?> onIndentSubmit;
  final ValueChanged<double?> onEndIndentSubmit;

  const DividerFields({
    super.key,
    required this.heightController,
    required this.thicknessController,
    required this.indentController,
    required this.endIndentController,
    required this.onHeightSubmit,
    required this.onThicknessSubmit,
    required this.onIndentSubmit,
    required this.onEndIndentSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyNumberField(
          label: 'Height',
          controller: heightController,
          hint: 'Auto',
          onSubmit: onHeightSubmit,
          onClear: () => onHeightSubmit(null),
        ),
        const SizedBox(height: 8),
        PropertyNumberField(
          label: 'Thickness',
          controller: thicknessController,
          hint: 'Default',
          onSubmit: onThicknessSubmit,
          onClear: () => onThicknessSubmit(null),
        ),
        const SizedBox(height: 8),
        PropertyNumberField(
          label: 'Indent',
          controller: indentController,
          hint: '0',
          onSubmit: onIndentSubmit,
          onClear: () => onIndentSubmit(null),
        ),
        const SizedBox(height: 8),
        PropertyNumberField(
          label: 'End Indent',
          controller: endIndentController,
          hint: '0',
          onSubmit: onEndIndentSubmit,
          onClear: () => onEndIndentSubmit(null),
        ),
      ],
    );
  }
}
