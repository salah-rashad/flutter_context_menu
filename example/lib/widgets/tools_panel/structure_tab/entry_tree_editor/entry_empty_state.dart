import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Displayed in the tree area when no menu entries exist.
class EntryEmptyState extends StatelessWidget {
  const EntryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.list).muted(),
            const SizedBox(height: 8),
            const Text('No menu entries').xSmall().muted(),
            const SizedBox(height: 4),
            const Text('Click + to add entries').xSmall().muted(),
          ],
        ),
      ),
    );
  }
}
