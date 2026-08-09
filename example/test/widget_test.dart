// Smoke test for the example app.
//
// Verifies the demo page builds and that right-clicking a region opens its
// context menu.

import 'package:example/main.dart';
import 'package:example/pages/demo_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Demo page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(DemoPage), findsOneWidget);
    expect(find.text('Flutter Context Menu Demo'), findsOneWidget);
  });

  testWidgets('Right-click opens the checkable demo menu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byType(CheckableMenuDemo),
      buttons: kSecondaryButton,
    );
    await tester.pumpAndSettle();

    expect(find.text('Show grid'), findsOneWidget);
    expect(find.text('Presentation mode'), findsOneWidget);
  });
}
