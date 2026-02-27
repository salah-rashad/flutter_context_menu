import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';
import 'property_field_widgets.dart';

/// Property fields for a [EntryType.item] entry.
class ItemFields extends StatelessWidget {
  final EntryNode entry;
  final TextEditingController labelController;
  final TextEditingController valueController;
  final ValueChanged<String> onLabelSubmit;
  final ValueChanged<String?> onValueSubmit;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onIsSubmenuChanged;

  const ItemFields({
    super.key,
    required this.entry,
    required this.labelController,
    required this.valueController,
    required this.onLabelSubmit,
    required this.onValueSubmit,
    required this.onEnabledChanged,
    required this.onIsSubmenuChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyTextField(
          label: 'Label',
          controller: labelController,
          hint: 'Menu item label',
          onSubmit: onLabelSubmit,
        ),
        const SizedBox(height: 8),
        PropertyTextField(
          label: 'Value',
          controller: valueController,
          hint: 'Selection value',
          onSubmit: (v) => onValueSubmit(v.isEmpty ? null : v),
        ),
        const SizedBox(height: 8),
        PropertySwitchField(
          label: 'Enabled',
          value: entry.enabled,
          onChanged: onEnabledChanged,
        ),
        const SizedBox(height: 8),
        PropertySwitchField(
          label: 'Is Submenu',
          value: entry.isSubmenu,
          onChanged: onIsSubmenuChanged,
        ),
        if (entry.isSubmenu) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('${entry.children.length} child entries')
                .xSmall()
                .muted(),
          ),
        ],
      ],
    );
  }
}
