import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';

/// Displays a badge showing the type of the currently selected entry.
class PropertyTypeHeader extends StatelessWidget {
  final EntryNode entry;

  const PropertyTypeHeader({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final typeLabel = switch (entry.type) {
      EntryType.item => 'Menu Item',
      EntryType.header => 'Menu Header',
      EntryType.divider => 'Menu Divider',
    };

    final typeIcon = switch (entry.type) {
      EntryType.item => LucideIcons.circleCheck,
      EntryType.header => LucideIcons.tag,
      EntryType.divider => LucideIcons.minus,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(typeIcon, size: 14),
          const SizedBox(width: 6),
          Text(typeLabel).xSmall().semiBold(),
        ],
      ),
    );
  }
}
