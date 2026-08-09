import 'package:example/entries/custom_checkable_menu_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openMenu(WidgetTester tester, ContextMenu<String> menu) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ContextMenuRegion(
            contextMenu: menu,
            child: const SizedBox.expand(child: ColoredBox(color: Colors.grey)),
          ),
        ),
      ),
    ));
    await tester.tap(find.byType(SizedBox).first, buttons: kSecondaryButton);
    await tester.pumpAndSettle();
  }

  testWidgets('Space toggles a CheckableMenuItem and keeps the menu open',
      (tester) async {
    final controller = CheckableController();
    addTearDown(controller.dispose);
    final toggles = <bool>[];

    await openMenu(
      tester,
      ContextMenu<String>(entries: [
        CheckableMenuItem(
          label: const Text('Show grid'),
          controller: controller,
          onToggle: toggles.add,
        ),
        const CheckableMenuItem(
          label: Text('Disabled'),
          enabled: false,
        ),
      ]),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(controller.value, isTrue);
    expect(toggles, [true]);
    expect(find.text('Show grid'), findsOneWidget, reason: 'menu stays open');
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(controller.value, isFalse);
    expect(toggles, [true, false]);
    expect(find.text('Show grid'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('disabled checkable entry ignores keyboard activation',
      (tester) async {
    final toggles = <bool>[];

    await openMenu(
      tester,
      ContextMenu<String>(entries: [
        CheckableMenuItem(
          label: const Text('Disabled'),
          enabled: false,
          onToggle: toggles.add,
        ),
      ]),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(toggles, isEmpty);
  });

  testWidgets('custom ContextMenuCheckableItem subclass toggles via keyboard',
      (tester) async {
    final controller = CheckableController();
    addTearDown(controller.dispose);
    final toggles = <bool>[];

    await openMenu(
      tester,
      ContextMenu<String>(entries: [
        SwitchMenuItem(
          label: 'Presentation mode',
          controller: controller,
          onToggle: toggles.add,
        ),
      ]),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(controller.value, isTrue);
    expect(toggles, [true]);
    expect(find.text('Presentation mode'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('tapping a checkable entry toggles without closing the menu',
      (tester) async {
    final controller = CheckableController();
    addTearDown(controller.dispose);

    await openMenu(
      tester,
      ContextMenu<String>(entries: [
        CheckableMenuItem(label: const Text('Snap'), controller: controller),
      ]),
    );

    await tester.tap(find.text('Snap'));
    await tester.pumpAndSettle();

    expect(controller.value, isTrue);
    expect(find.text('Snap'), findsOneWidget);

    await tester.tap(find.text('Snap'));
    await tester.pumpAndSettle();

    expect(controller.value, isFalse);
    expect(find.text('Snap'), findsOneWidget);
  });
}
