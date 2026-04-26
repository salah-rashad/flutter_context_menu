import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

// Minimal concrete entry for testing the activator registry.
// Has a distinguishing [id] field so two entries with different ids are
// distinct objects and distinct map keys.
final class _TestEntry extends ContextMenuEntry<String> {
  final int id;
  const _TestEntry({this.id = 0});

  @override
  Widget builder(BuildContext context, ContextMenuState<String> menuState) {
    return const SizedBox.shrink();
  }
}

ContextMenuState<String> _makeState() {
  return ContextMenuState<String>(
    menu: ContextMenu<String>(entries: const []),
  );
}

void main() {
  group('ContextMenuState — activator registry', () {
    group('registerActivator / hasActivator', () {
      test('hasActivator returns false for unregistered entry', () {
        final state = _makeState();
        const entry = _TestEntry();
        expect(state.hasActivator(entry), isFalse);
        state.dispose();
      });

      test('hasActivator returns true after registering', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.registerActivator(entry, () {});
        expect(state.hasActivator(entry), isTrue);
        state.dispose();
      });

      test('registering same entry twice overwrites previous callback', () {
        final state = _makeState();
        const entry = _TestEntry();
        int call1 = 0;
        int call2 = 0;

        state.registerActivator(entry, () => call1++);
        state.registerActivator(entry, () => call2++);
        state.activateEntry(entry);

        expect(call1, 0); // first callback overwritten
        expect(call2, 1); // second callback called
        state.dispose();
      });
    });

    group('unregisterActivator', () {
      test('hasActivator returns false after unregistering', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.registerActivator(entry, () {});
        state.unregisterActivator(entry);
        expect(state.hasActivator(entry), isFalse);
        state.dispose();
      });

      test('unregistering a non-existent entry is a no-op', () {
        final state = _makeState();
        const entry = _TestEntry();
        // Should not throw
        expect(() => state.unregisterActivator(entry), returnsNormally);
        state.dispose();
      });
    });

    group('activateEntry()', () {
      test('returns false when no activator registered', () {
        final state = _makeState();
        const entry = _TestEntry();
        final result = state.activateEntry(entry);
        expect(result, isFalse);
        state.dispose();
      });

      test('returns true and calls callback when activator registered', () {
        final state = _makeState();
        const entry = _TestEntry();
        int callCount = 0;
        state.registerActivator(entry, () => callCount++);

        final result = state.activateEntry(entry);
        expect(result, isTrue);
        expect(callCount, 1);
        state.dispose();
      });

      test('calls activator callback exactly once per call', () {
        final state = _makeState();
        const entry = _TestEntry();
        int callCount = 0;
        state.registerActivator(entry, () => callCount++);

        state.activateEntry(entry);
        state.activateEntry(entry);
        state.activateEntry(entry);
        expect(callCount, 3);
        state.dispose();
      });

      test('returns false after activator is unregistered', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.registerActivator(entry, () {});
        state.unregisterActivator(entry);

        final result = state.activateEntry(entry);
        expect(result, isFalse);
        state.dispose();
      });
    });

    group('activateFocusedEntry()', () {
      test('returns false when no entry is focused', () {
        final state = _makeState();
        final result = state.activateFocusedEntry();
        expect(result, isFalse);
        state.dispose();
      });

      test('returns false when focused entry has no registered activator', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.setFocusedEntry(entry);
        // No activator registered
        final result = state.activateFocusedEntry();
        expect(result, isFalse);
        state.dispose();
      });

      test('returns true and calls activator when focused entry has activator', () {
        final state = _makeState();
        const entry = _TestEntry();
        int callCount = 0;
        state.registerActivator(entry, () => callCount++);
        state.setFocusedEntry(entry);

        final result = state.activateFocusedEntry();
        expect(result, isTrue);
        expect(callCount, 1);
        state.dispose();
      });

      test('activates the currently focused entry, not a different one', () {
        final state = _makeState();
        const entry1 = _TestEntry(id: 1);
        const entry2 = _TestEntry(id: 2);
        int calls1 = 0;
        int calls2 = 0;
        state.registerActivator(entry1, () => calls1++);
        state.registerActivator(entry2, () => calls2++);
        state.setFocusedEntry(entry2);

        state.activateFocusedEntry();
        expect(calls1, 0);
        expect(calls2, 1);
        state.dispose();
      });
    });

    group('close() clears activators', () {
      test('hasActivator returns false after close()', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.registerActivator(entry, () {});
        expect(state.hasActivator(entry), isTrue);

        state.close();
        expect(state.hasActivator(entry), isFalse);
      });

      test('activateEntry returns false after close()', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.registerActivator(entry, () {});
        state.close();

        final result = state.activateEntry(entry);
        expect(result, isFalse);
      });
    });

    group('setFocusedEntry()', () {
      test('updates focusedEntry', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.setFocusedEntry(entry);
        expect(state.focusedEntry, same(entry));
        state.dispose();
      });

      test('can clear focusedEntry with null', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.setFocusedEntry(entry);
        state.setFocusedEntry(null);
        expect(state.focusedEntry, isNull);
        state.dispose();
      });

      test('notifies listeners when focusedEntry changes', () {
        final state = _makeState();
        const entry = _TestEntry();
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.setFocusedEntry(entry);
        expect(notifyCount, 1);
        state.dispose();
      });

      test('does not notify when same entry is set again', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.setFocusedEntry(entry);
        int notifyCount = 0;
        state.addListener(() => notifyCount++);

        state.setFocusedEntry(entry); // same value
        expect(notifyCount, 0);
        state.dispose();
      });
    });

    group('activateMenuItem()', () {
      testWidgets('does nothing when item is disabled', (tester) async {
        final state = _makeState();
        int onSelectedCalled = 0;
        final item = MenuItem<String>(
          label: const Text('Item'),
          value: 'val',
          enabled: false,
          onSelected: (_) => onSelectedCalled++,
        );
        state.registerActivator(item, () {});

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              // activateMenuItem with disabled item should be a no-op
              state.activateMenuItem(context, item);
              return const SizedBox.shrink();
            }),
          ),
        );

        expect(onSelectedCalled, 0);
        state.dispose();
      });

      testWidgets('calls selectAndClose for non-submenu enabled item', (tester) async {
        String? onSelectedValue;
        String? onItemSelectedValue;

        final state = ContextMenuState<String>(
          menu: ContextMenu<String>(entries: const []),
          onItemSelected: (v) => onItemSelectedValue = v,
        );

        final item = MenuItem<String>(
          label: const Text('Item'),
          value: 'hello',
          onSelected: (v) => onSelectedValue = v,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  state.activateMenuItem(context, item);
                },
                child: const Text('Activate'),
              );
            }),
          ),
        );

        // Can't pop on a simple MaterialApp without a pushed route
        // but we can verify the callbacks are called
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // onSelected and onItemSelected should be called even if navigation fails
        expect(onSelectedValue, equals('hello'));
        expect(onItemSelectedValue, equals('hello'));
        state.dispose();
      });
    });

    group('isFocused() helper', () {
      test('returns false for unfocused entry', () {
        final state = _makeState();
        const entry = _TestEntry();
        expect(state.isFocused(entry), isFalse);
        state.dispose();
      });

      test('returns true for focused entry', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.setFocusedEntry(entry);
        expect(state.isFocused(entry), isTrue);
        state.dispose();
      });

      test('returns false after focus is cleared', () {
        final state = _makeState();
        const entry = _TestEntry();
        state.setFocusedEntry(entry);
        state.setFocusedEntry(null);
        expect(state.isFocused(entry), isFalse);
        state.dispose();
      });
    });

    group('multiple activators', () {
      test('can register activators for multiple different entries', () {
        final state = _makeState();
        const entry1 = _TestEntry(id: 10);
        const entry2 = _TestEntry(id: 20);
        int calls1 = 0;
        int calls2 = 0;

        state.registerActivator(entry1, () => calls1++);
        state.registerActivator(entry2, () => calls2++);

        expect(state.hasActivator(entry1), isTrue);
        expect(state.hasActivator(entry2), isTrue);

        state.activateEntry(entry1);
        expect(calls1, 1);
        expect(calls2, 0);

        state.activateEntry(entry2);
        expect(calls1, 1);
        expect(calls2, 1);
        state.dispose();
      });

      test('unregistering one entry does not affect others', () {
        final state = _makeState();
        const entry1 = _TestEntry(id: 10);
        const entry2 = _TestEntry(id: 20);
        state.registerActivator(entry1, () {});
        state.registerActivator(entry2, () {});

        state.unregisterActivator(entry1);

        expect(state.hasActivator(entry1), isFalse);
        expect(state.hasActivator(entry2), isTrue);
        state.dispose();
      });
    });
  });
}