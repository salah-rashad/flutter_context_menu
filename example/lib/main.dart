import 'package:flutter/material.dart' show runApp;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'app.dart';
import 'state/playground_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider<PlaygroundState>(
      create: (_) => PlaygroundState(),
      child: const PlaygroundApp(),
    ),
  );
}
