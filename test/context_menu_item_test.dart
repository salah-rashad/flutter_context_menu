import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

void main() {
  group('ContextMenuItem (refactored to extend ContextMenuInteractiveEntry)', () {
    group('isSubmenuItem getter', () {
      test('returns false for regular item', () {
        final item = MenuItem<String>(
          label: const Text('Item'),
          value: 'value',
        );
        expect(item.isSubmenuItem, isFalse);
      });

      test('returns true for submenu item', () {
        final item = MenuItem<String>.submenu(
          label: const Text('Submenu'),
          items: [
            MenuItem<String>(label: const Text('Child'), value: 'child'),
          ],
        );
        expect(item.isSubmenuItem, isTrue);
      });

      test('items is null for regular item', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item.items, isNull);
      });

      test('items is non-null for submenu item', () {
        final item = MenuItem<String>.submenu(
          label: const Text('Sub'),
          items: [
            MenuItem<String>(label: const Text('Child'), value: 'child'),
          ],
        );
        expect(item.items, isNotNull);
        expect(item.items!.length, 1);
      });
    });

    group('value property', () {
      test('value is null for submenu item', () {
        final item = MenuItem<String>.submenu(
          label: const Text('Sub'),
          items: [],
        );
        expect(item.value, isNull);
      });

      test('value can be set on regular item', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'hello');
        expect(item.value, equals('hello'));
      });
    });

    group('enabled property (inherited from ContextMenuInteractiveEntry)', () {
      test('defaults to true', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item.enabled, isTrue);
      });

      test('can be set to false', () {
        final item = MenuItem<String>(
          label: const Text('Item'),
          value: 'val',
          enabled: false,
        );
        expect(item.enabled, isFalse);
      });

      test('submenu item defaults enabled to true', () {
        final item = MenuItem<String>.submenu(
          label: const Text('Sub'),
          items: [],
        );
        expect(item.enabled, isTrue);
      });

      test('submenu item can be disabled', () {
        final item = MenuItem<String>.submenu(
          label: const Text('Sub'),
          items: [],
          enabled: false,
        );
        expect(item.enabled, isFalse);
      });
    });

    group('autoHandleFocus getter', () {
      test('returns true by default', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item.autoHandleFocus, isTrue);
      });
    });

    group('createActivator()', () {
      testWidgets('returns non-null callback', (tester) async {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        final menu = ContextMenu<String>(entries: [item]);
        final state = ContextMenuState<String>(menu: menu);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              final activator = item.createActivator(context, state);
              expect(activator, isNotNull);
              return const SizedBox.shrink();
            }),
          ),
        );

        state.dispose();
      });

      testWidgets('returns a VoidCallback', (tester) async {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        final menu = ContextMenu<String>(entries: [item]);
        final state = ContextMenuState<String>(menu: menu);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              final activator = item.createActivator(context, state);
              expect(activator, isA<VoidCallback>());
              return const SizedBox.shrink();
            }),
          ),
        );

        state.dispose();
      });
    });

    group('onSelected callback', () {
      test('defaults to null', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item.onSelected, isNull);
      });

      test('can be set', () {
        void callback(String? value) {}
        final item = MenuItem<String>(
          label: const Text('Item'),
          value: 'val',
          onSelected: callback,
        );
        expect(item.onSelected, isNotNull);
      });
    });

    group('type hierarchy', () {
      test('is a ContextMenuInteractiveEntry', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item, isA<ContextMenuInteractiveEntry<String>>());
      });

      test('is a ContextMenuEntry', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item, isA<ContextMenuEntry<String>>());
      });

      test('is a ContextMenuItem', () {
        final item = MenuItem<String>(label: const Text('Item'), value: 'val');
        expect(item, isA<ContextMenuItem<String>>());
      });
    });
  });
}