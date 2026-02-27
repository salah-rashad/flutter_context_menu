import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';
import '../../../../state/playground_state.dart';

/// Shows a dropdown for adding a new menu entry.
///
/// [context] should be a [Builder] context near the anchor button so the
/// dropdown aligns correctly.
void showAddEntryDropdown(
  BuildContext context,
  PlaygroundState playgroundState,
  ValueChanged<EntryNode?>? onEntrySelected,
) {
  showDropdown(
    context: context,
    alignment: Alignment.topRight,
    anchorAlignment: Alignment.bottomRight,
    builder: (dropdownContext) {
      return DropdownMenu(
        children: [
          MenuButton(
            leading: const Icon(LucideIcons.circle, size: 14),
            child: const Text('Menu Item'),
            onPressed: (_) {
              playgroundState.addEntry(EntryType.item);
              if (playgroundState.entries.isNotEmpty) {
                onEntrySelected?.call(playgroundState.entries.last);
              }
            },
          ),
          MenuButton(
            leading: const Icon(LucideIcons.tag, size: 14),
            child: const Text('Menu Header'),
            onPressed: (_) {
              playgroundState.addEntry(EntryType.header);
              if (playgroundState.entries.isNotEmpty) {
                onEntrySelected?.call(playgroundState.entries.last);
              }
            },
          ),
          MenuButton(
            leading: const Icon(LucideIcons.minus, size: 14),
            child: const Text('Menu Divider'),
            onPressed: (_) {
              playgroundState.addEntry(EntryType.divider);
              if (playgroundState.entries.isNotEmpty) {
                onEntrySelected?.call(playgroundState.entries.last);
              }
            },
          ),
        ],
      );
    },
  );
}
