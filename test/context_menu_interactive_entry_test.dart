import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

// Minimal concrete implementation for testing the abstract base class
final class _ConcreteInteractiveEntry extends ContextMenuInteractiveEntry<String> {
  const _ConcreteInteractiveEntry({super.enabled});

  @override
  Widget builder(BuildContext context, ContextMenuState<String> menuState,
      [FocusNode? focusNode]) {
    return const SizedBox.shrink();
  }
}

// Concrete implementation that overrides autoHandleFocus
final class _NoAutoFocusEntry extends ContextMenuInteractiveEntry<String> {
  const _NoAutoFocusEntry({super.enabled});

  @override
  bool get autoHandleFocus => false;

  @override
  Widget builder(BuildContext context, ContextMenuState<String> menuState,
      [FocusNode? focusNode]) {
    return const SizedBox.shrink();
  }
}

void main() {
  group('ContextMenuInteractiveEntry', () {
    group('enabled property', () {
      test('defaults to true', () {
        const entry = _ConcreteInteractiveEntry();
        expect(entry.enabled, isTrue);
      });

      test('can be set to false', () {
        const entry = _ConcreteInteractiveEntry(enabled: false);
        expect(entry.enabled, isFalse);
      });

      test('can be explicitly set to true', () {
        const entry = _ConcreteInteractiveEntry(enabled: true);
        expect(entry.enabled, isTrue);
      });
    });

    group('autoHandleFocus getter', () {
      test('returns true by default', () {
        const entry = _ConcreteInteractiveEntry();
        expect(entry.autoHandleFocus, isTrue);
      });

      test('can be overridden to return false', () {
        const entry = _NoAutoFocusEntry();
        expect(entry.autoHandleFocus, isFalse);
      });
    });

    group('createActivator()', () {
      testWidgets('returns null by default', (tester) async {
        const entry = _ConcreteInteractiveEntry();

        await tester.pumpWidget(
          const MaterialApp(
            home: SizedBox.shrink(),
          ),
        );

        final context = tester.element(find.byType(SizedBox));
        final menu = ContextMenu<String>(entries: const []);
        final state = ContextMenuState<String>(menu: menu);
        expect(entry.createActivator(context, state), isNull);
        state.dispose();
      });
    });

    group('is a subtype of ContextMenuEntry', () {
      test('is a ContextMenuEntry', () {
        const entry = _ConcreteInteractiveEntry();
        expect(entry, isA<ContextMenuEntry<String>>());
      });
    });

    group('debugLabel', () {
      test('returns a non-empty string', () {
        const entry = _ConcreteInteractiveEntry();
        expect(entry.debugLabel, isNotEmpty);
      });
    });
  });
}