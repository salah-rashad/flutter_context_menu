import 'package:flutter/material.dart';

class ExampleModel {
  final String id;
  final String title;
  final String description;
  final String route;
  final IconData icon;
  final ExampleCategory category;
  final Widget exampleWidget;

  const ExampleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
    required this.category,
    required this.exampleWidget,
  });
}

enum ExampleCategory {
  basic('Basic Examples', Icons.list_alt_rounded),
  advanced('Advanced Features', Icons.auto_awesome_motion_rounded),
  realWorld('Real-world Use Cases', Icons.apps_rounded);

  final String title;
  final IconData icon;

  const ExampleCategory(this.title, this.icon);
}
