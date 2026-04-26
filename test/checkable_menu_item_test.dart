import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// Creates a [ContextMenuState] backed by an empty [ContextMenu].
ContextMenuState<String> makeState() {
  return ContextMenuState<String>(
    menu: ContextMenu<String>(entries: const []),
  );
}

void main() {
  group('CheckableMenuItem', () {
    group('constructor', () {
      test('label is required', () {
        const item = CheckableMenuItem<String>(label: Text('Hello'));
        expect(item.label, isA<Text>());
      });

      test('checked defaults to false', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.checked, isFalse);
      });

      test('enabled defaults to true', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.enabled, isTrue);
      });

      test('icon defaults to null', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.icon, isNull);
      });

      test('controller defaults to null', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.controller, isNull);
      });

      test('shortcut defaults to null', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.shortcut, isNull);
      });

      test('trailing defaults to null', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.trailing, isNull);
      });

      test('textColor defaults to null', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.textColor, isNull);
      });

      test('constraints defaults to null', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item.constraints, isNull);
      });
    });

    group('debugLabel', () {
      test('includes the label text', () {
        const item = CheckableMenuItem<String>(label: Text('Show grid'));
        expect(item.debugLabel, contains('Show grid'));
      });
    });

    group('type hierarchy', () {
      test('is a ContextMenuCheckableItem', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item, isA<ContextMenuCheckableItem<String>>());
      });

      test('is a ContextMenuInteractiveEntry', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item, isA<ContextMenuInteractiveEntry<String>>());
      });

      test('is a ContextMenuEntry', () {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        expect(item, isA<ContextMenuEntry<String>>());
      });
    });

    group('builder renders label', () {
      testWidgets('displays the label text', (tester) async {
        const item = CheckableMenuItem<String>(label: Text('Show grid'));
        final state = makeState();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(find.text('Show grid'), findsOneWidget);
        state.dispose();
      });

      testWidgets('renders without error', (tester) async {
        const item = CheckableMenuItem<String>(label: Text('Item'));
        final state = makeState();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
        state.dispose();
      });
    });

    group('check indicator visibility', () {
      testWidgets('shows check icon when checked=true', (tester) async {
        const item = CheckableMenuItem<String>(
          label: Text('Item'),
          checked: true,
        );
        final state = makeState();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        // Default check icon is Icons.check
        expect(find.byIcon(Icons.check), findsOneWidget);
        state.dispose();
      });

      testWidgets('does not show check icon when checked=false', (tester) async {
        const item = CheckableMenuItem<String>(
          label: Text('Item'),
          checked: false,
        );
        final state = makeState();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.check), findsNothing);
        state.dispose();
      });

      testWidgets('shows custom icon when checked=true and icon provided', (tester) async {
        const customIcon = Icon(Icons.star);
        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          checked: true,
          icon: customIcon,
        );
        final state = makeState();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);
        state.dispose();
      });

      testWidgets('does not show custom icon when checked=false', (tester) async {
        const customIcon = Icon(Icons.star);
        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          checked: false,
          icon: customIcon,
        );
        final state = makeState();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.star), findsNothing);
        state.dispose();
      });
    });

    group('toggle behavior', () {
      testWidgets('registers activator on init', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(label: Text('Item'));

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(state.hasActivator(item), isTrue);
        state.dispose();
      });

      testWidgets('toggling via activateEntry updates checked state', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(
          label: Text('Item'),
          checked: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        // Initially not checked
        expect(find.byIcon(Icons.check), findsNothing);

        // Activate the entry (simulates keyboard or tap)
        state.activateEntry(item);
        await tester.pump();

        // Now should show check
        expect(find.byIcon(Icons.check), findsOneWidget);
        state.dispose();
      });

      testWidgets('toggling twice returns to original state', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(
          label: Text('Item'),
          checked: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        state.activateEntry(item);
        await tester.pump();
        expect(find.byIcon(Icons.check), findsOneWidget);

        state.activateEntry(item);
        await tester.pump();
        expect(find.byIcon(Icons.check), findsNothing);

        state.dispose();
      });

      testWidgets('onToggle callback is called with new value', (tester) async {
        final state = makeState();
        final List<bool> toggledValues = [];

        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          checked: false,
          onToggle: (value) => toggledValues.add(value),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        state.activateEntry(item);
        await tester.pump();

        expect(toggledValues, [true]); // toggled from false to true

        state.activateEntry(item);
        await tester.pump();

        expect(toggledValues, [true, false]); // toggled back to false
        state.dispose();
      });

      testWidgets('disabled item does not toggle', (tester) async {
        final state = makeState();
        final List<bool> toggledValues = [];

        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          checked: false,
          enabled: false,
          onToggle: (value) => toggledValues.add(value),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        state.activateEntry(item);
        await tester.pump();

        expect(toggledValues, isEmpty);
        expect(find.byIcon(Icons.check), findsNothing);
        state.dispose();
      });
    });

    group('external CheckableController', () {
      testWidgets('uses controller value instead of static checked', (tester) async {
        final controller = CheckableController(initialValue: true);
        final state = makeState();

        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          checked: false, // static is false
          controller: controller, // controller is true
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        // Should show check because controller.value = true
        expect(find.byIcon(Icons.check), findsOneWidget);
        controller.dispose();
        state.dispose();
      });

      testWidgets('controller value reflects toggle via activateEntry', (tester) async {
        final controller = CheckableController(initialValue: false);
        final state = makeState();

        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          controller: controller,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(controller.value, isFalse);

        state.activateEntry(item);
        await tester.pump();

        expect(controller.value, isTrue);
        controller.dispose();
        state.dispose();
      });

      testWidgets('external controller change updates widget display', (tester) async {
        final controller = CheckableController(initialValue: false);
        final state = makeState();

        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          controller: controller,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.check), findsNothing);

        // Programmatically set controller value from outside
        controller.value = true;
        await tester.pump();

        expect(find.byIcon(Icons.check), findsOneWidget);
        controller.dispose();
        state.dispose();
      });
    });

    group('trailing widget', () {
      testWidgets('renders trailing widget when provided', (tester) async {
        final state = makeState();
        final item = CheckableMenuItem<String>(
          label: const Text('Item'),
          trailing: const Icon(Icons.arrow_forward),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
        state.dispose();
      });
    });

    group('keyboard shortcut display', () {
      testWidgets('renders shortcut text when provided', (tester) async {
        final state = makeState();
        final item = CheckableMenuItem<String>(
          label: const Text('Auto-save'),
          shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        // The shortcut text should be rendered (e.g., "Ctrl+S")
        // Find a text widget that's not "Auto-save"
        final texts = tester.widgetList<Text>(find.byType(Text)).toList();
        expect(texts.length, greaterThan(1)); // label + shortcut
        state.dispose();
      });

      testWidgets('no shortcut text when shortcut is null', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(
          label: Text('Auto-save'),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        // Only the label text should be present
        expect(find.text('Auto-save'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
        state.dispose();
      });
    });

    group('disabled state', () {
      testWidgets('InkWell onTap is null when disabled', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(
          label: Text('Item'),
          enabled: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.onTap, isNull);
        state.dispose();
      });

      testWidgets('InkWell onTap is non-null when enabled', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(
          label: Text('Item'),
          enabled: true,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.onTap, isNotNull);
        state.dispose();
      });
    });

    group('activator lifecycle', () {
      testWidgets('activator is unregistered when widget is disposed', (tester) async {
        final state = makeState();
        const item = CheckableMenuItem<String>(label: Text('Item'));

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return Scaffold(
                body: SizedBox(
                  width: 300,
                  child: item.builder(context, state),
                ),
              );
            }),
          ),
        );
        await tester.pump();

        expect(state.hasActivator(item), isTrue);

        // Replace widget tree to trigger disposal
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: SizedBox()),
          ),
        );
        await tester.pump();

        expect(state.hasActivator(item), isFalse);
        state.dispose();
      });
    });
  });
}