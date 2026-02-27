import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../state/entry_node.dart';
import '../../../state/playground_state.dart';
import 'entry_properties.dart';
import 'entry_tree_editor.dart';

/// Structure tab combining the entry tree editor and property editor.
///
/// Layout:
/// - Top: Entry tree editor (takes most space)
/// - Bottom: Property editor for selected entry (flexible height)
class StructureTab extends StatefulWidget {
  const StructureTab({super.key});

  @override
  State<StructureTab> createState() => _StructureTabState();
}

class _StructureTabState extends State<StructureTab> {
  /// The currently selected entry.
  EntryNode? _selectedEntry;

  /// The ID of the selected entry (used to track selection across rebuilds).
  String? _selectedEntryId;

  @override
  Widget build(BuildContext context) {
    final playgroundState = context.watch<PlaygroundState>();
    final colorScheme = ColorScheme.of(context);

    // Re-find selected entry if the entries list changed
    if (_selectedEntryId != null) {
      _selectedEntry =
          _findEntryById(playgroundState.entries, _selectedEntryId!);
      if (_selectedEntry == null) {
        _selectedEntryId = null;
      }
    }

    return Column(
      children: [
        // Entry tree editor (flexible)
        Expanded(
          flex: 3,
          child: EntryTreeEditor(
            selectedEntryId: _selectedEntryId,
            onEntrySelected: (entry) {
              setState(() {
                _selectedEntry = entry;
                _selectedEntryId = entry?.id;
              });
            },
          ),
        ),
        const Divider(),
        // Property editor (flexible height with constraints)
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 150,
            maxHeight: 280,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.background.withValues(alpha: 0.3),
            ),
            child: EntryProperties(
              entry: _selectedEntry,
              onUpdate: (updated) {
                if (_selectedEntryId != null) {
                  playgroundState.updateEntry(_selectedEntryId!, updated);
                  setState(() {
                    _selectedEntry = updated;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Finds an entry by ID recursively.
  EntryNode? _findEntryById(List<EntryNode> entries, String id) {
    for (final entry in entries) {
      if (entry.id == id) return entry;
      if (entry.children.isNotEmpty) {
        final found = _findEntryById(entry.children, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}
