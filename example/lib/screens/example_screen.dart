import 'package:flutter/material.dart';

import '../data/models/example_model.dart';

class ExampleScreen extends StatelessWidget {
  final ExampleModel example;

  const ExampleScreen({
    super.key,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(example.title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: example.exampleWidget,
        ),
      ),
    );
  }
}
