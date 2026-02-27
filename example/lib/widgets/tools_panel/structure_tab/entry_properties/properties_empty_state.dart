import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Shown when no entry is selected in the properties panel.
class PropertiesEmptyState extends StatelessWidget {
  const PropertiesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.hand).muted(),
            const SizedBox(height: 8),
            const Text('Select an entry to edit').xSmall().muted(),
          ],
        ),
      ),
    );
  }
}
