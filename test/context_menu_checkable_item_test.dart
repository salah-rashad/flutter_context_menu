import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

// Minimal concrete implementation of ContextMenuCheckableItem for testing
final class _ConcreteCheckableItem extends ContextMenuCheckableItem<String> {
  const _ConcreteCheckableItem({
    super.checked,
    super.controller,
    super.onToggle,
    super.enabled,
  });

  @override
  Widget builder(BuildContext context, ContextMenuState<String> menuState,
      [FocusNode? focusNode]) {
    return const SizedBox.shrink();
  }
}

void main() {
  group('ContextMenuCheckableItem', () {
    group('checked property', () {
      test('defaults to false', () {
        const item = _ConcreteCheckableItem();
        expect(item.checked, isFalse);
      });

      test('can be set to true', () {
        const item = _ConcreteCheckableItem(checked: true);
        expect(item.checked, isTrue);
      });

      test('can be explicitly set to false', () {
        const item = _ConcreteCheckableItem(checked: false);
        expect(item.checked, isFalse);
      });
    });

    group('enabled property (inherited)', () {
      test('defaults to true', () {
        const item = _ConcreteCheckableItem();
        expect(item.enabled, isTrue);
      });

      test('can be set to false', () {
        const item = _ConcreteCheckableItem(enabled: false);
        expect(item.enabled, isFalse);
      });
    });

    group('controller property', () {
      test('defaults to null', () {
        const item = _ConcreteCheckableItem();
        expect(item.controller, isNull);
      });

      test('accepts an external CheckableController', () {
        final controller = CheckableController(initialValue: true);
        final item = _ConcreteCheckableItem(controller: controller);
        expect(item.controller, same(controller));
        controller.dispose();
      });
    });

    group('onToggle callback', () {
      test('defaults to null', () {
        const item = _ConcreteCheckableItem();
        expect(item.onToggle, isNull);
      });

      test('can be set', () {
        void callback(bool value) {}
        final item = _ConcreteCheckableItem(onToggle: callback);
        expect(item.onToggle, isNotNull);
      });
    });

    group('currentChecked getter', () {
      test('returns static checked value when no controller', () {
        const item = _ConcreteCheckableItem(checked: false);
        expect(item.currentChecked, isFalse);
      });

      test('returns static checked=true when no controller', () {
        const item = _ConcreteCheckableItem(checked: true);
        expect(item.currentChecked, isTrue);
      });

      test('returns controller value when controller is provided', () {
        final controller = CheckableController(initialValue: true);
        final item = _ConcreteCheckableItem(
          checked: false, // static value is false
          controller: controller, // controller value is true
        );
        // Should use controller value (true) not static checked (false)
        expect(item.currentChecked, isTrue);
        controller.dispose();
      });

      test('reflects controller value changes', () {
        final controller = CheckableController(initialValue: false);
        final item = _ConcreteCheckableItem(controller: controller);

        expect(item.currentChecked, isFalse);
        controller.toggle();
        expect(item.currentChecked, isTrue);
        controller.toggle();
        expect(item.currentChecked, isFalse);
        controller.dispose();
      });

      test('ignores static checked when controller is provided', () {
        final controller = CheckableController(initialValue: false);
        final item = _ConcreteCheckableItem(
          checked: true, // static is true
          controller: controller, // controller is false
        );
        // Controller takes precedence
        expect(item.currentChecked, isFalse);
        controller.dispose();
      });
    });

    group('is a subtype of ContextMenuInteractiveEntry', () {
      test('is a ContextMenuInteractiveEntry', () {
        const item = _ConcreteCheckableItem();
        expect(item, isA<ContextMenuInteractiveEntry<String>>());
      });

      test('is a ContextMenuEntry', () {
        const item = _ConcreteCheckableItem();
        expect(item, isA<ContextMenuEntry<String>>());
      });
    });

    group('createActivator()', () {
      testWidgets('returns null (activation is handled by widget layer)', (tester) async {
        const item = _ConcreteCheckableItem();

        await tester.pumpWidget(
          const MaterialApp(home: SizedBox.shrink()),
        );

        final context = tester.element(find.byType(SizedBox));
        final state = ContextMenuState<String>(
          menu: ContextMenu<String>(entries: const []),
        );
        // Checkable items inherit createActivator returning null from
        // ContextMenuInteractiveEntry. Activation is registered via widget initState.
        expect(item.createActivator(context, state), isNull);
        state.dispose();
      });
    });
  });
}