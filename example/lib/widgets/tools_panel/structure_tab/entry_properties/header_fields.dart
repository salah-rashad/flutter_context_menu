import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';
import 'property_field_widgets.dart';

/// Property fields for a [EntryType.header] entry.
class HeaderFields extends StatelessWidget {
  final EntryNode entry;
  final TextEditingController labelController;
  final ValueChanged<String> onLabelSubmit;
  final ValueChanged<bool> onDisableUppercaseChanged;

  const HeaderFields({
    super.key,
    required this.entry,
    required this.labelController,
    required this.onLabelSubmit,
    required this.onDisableUppercaseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyTextField(
          label: 'Text',
          controller: labelController,
          hint: 'Header text',
          onSubmit: onLabelSubmit,
        ),
        const SizedBox(height: 8),
        PropertySwitchField(
          label: 'Disable Uppercase',
          value: entry.disableUppercase,
          onChanged: onDisableUppercaseChanged,
        ),
      ],
    );
  }
}
