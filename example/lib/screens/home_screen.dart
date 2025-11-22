import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/models/example_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = AppRoutes.getExamples();
    const categories = ExampleCategory.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Context Menu Examples'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryExamples = examples
              .where((example) => example.category == category)
              .toList();

          return _buildCategorySection(context, category, categoryExamples);
        },
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    ExampleCategory category,
    List<ExampleModel> examples,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(category.icon,
                  size: 24, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                category.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: examples.length,
          itemBuilder: (context, index) {
            final example = examples[index];
            return _ExampleCard(example: example);
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final ExampleModel example;

  const _ExampleCard({required this.example});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            example.route,
            arguments: example,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(example.icon,
                  size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
