// This is a basic Flutter widget test.
//
// Smoke test for the Context Menu Playground app.
// Verifies that the app loads and displays the expected placeholder content.

import 'package:example/app.dart';
import 'package:example/state/playground_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App loads and displays playground screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<PlaygroundState>(
        create: (_) => PlaygroundState(),
        child: const PlaygroundApp(),
      ),
    );

    // Verify that the placeholder text is displayed.
    expect(find.text('Tools Panel (Phase 2)'), findsOneWidget);
    expect(find.text('Playground Area (Phase 2)'), findsOneWidget);
  });
}
