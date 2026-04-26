import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

// Access to the internal shortcut function via the library
// We need to import the internal utility directly
import 'package:flutter_context_menu/src/core/utils/shortcuts/menu_item_shortcuts.dart';

ContextMenuState<String> _makeState({List<ContextMenuEntry<String>>? entries}) {
  return ContextMenuState<String>(
    menu: ContextMenu<String>(entries: entries ?? const []),
  );
}

void main() {
  group('defaultMenuItemShortcuts()', () {
    group('returns correct keys', () {
      test('contains arrowRight, space, enter, numpadEnter', () {
        final state = _makeState();
        final shortcuts = defaultMenuItemShortcuts(state);

        expect(shortcuts.containsKey(const SingleActivator(LogicalKeyboardKey.arrowRight)), isTrue);
        expect(shortcuts.containsKey(const SingleActivator(LogicalKeyboardKey.space)), isTrue);
        expect(shortcuts.containsKey(const SingleActivator(LogicalKeyboardKey.enter)), isTrue);
        expect(shortcuts.containsKey(const SingleActivator(LogicalKeyboardKey.numpadEnter)), isTrue);

        state.dispose();
      });

      test('returns exactly 4 shortcuts', () {
        final state = _makeState();
        final shortcuts = defaultMenuItemShortcuts(state);
        expect(shortcuts.length, 4);
        state.dispose();
      });
    });

    group('space shortcut', () {
      test('calls activateFocusedEntry()', () {
        final state = _makeState();
        int callCount = 0;

        // Register a test entry with an activator
        final entry = MenuItem<String>(label: const Text('Item'), value: 'val');
        state.registerActivator(entry, () => callCount++);
        state.setFocusedEntry(entry);

        final shortcuts = defaultMenuItemShortcuts(state);
        final spaceCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.space)]!;
        spaceCallback();

        expect(callCount, 1);
        state.dispose();
      });

      test('does nothing when no focused entry', () {
        final state = _makeState();
        final shortcuts = defaultMenuItemShortcuts(state);
        final spaceCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.space)]!;

        // Should not throw when no focused entry
        expect(() => spaceCallback(), returnsNormally);
        state.dispose();
      });
    });

    group('enter shortcut', () {
      test('calls activateFocusedEntry()', () {
        final state = _makeState();
        int callCount = 0;

        final entry = MenuItem<String>(label: const Text('Item'), value: 'val');
        state.registerActivator(entry, () => callCount++);
        state.setFocusedEntry(entry);

        final shortcuts = defaultMenuItemShortcuts(state);
        final enterCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.enter)]!;
        enterCallback();

        expect(callCount, 1);
        state.dispose();
      });

      test('does nothing when no focused entry', () {
        final state = _makeState();
        final shortcuts = defaultMenuItemShortcuts(state);
        final enterCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.enter)]!;

        expect(() => enterCallback(), returnsNormally);
        state.dispose();
      });
    });

    group('numpadEnter shortcut', () {
      test('calls activateFocusedEntry()', () {
        final state = _makeState();
        int callCount = 0;

        final entry = MenuItem<String>(label: const Text('Item'), value: 'val');
        state.registerActivator(entry, () => callCount++);
        state.setFocusedEntry(entry);

        final shortcuts = defaultMenuItemShortcuts(state);
        final numpadEnterCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.numpadEnter)]!;
        numpadEnterCallback();

        expect(callCount, 1);
        state.dispose();
      });
    });

    group('arrowRight shortcut', () {
      test('is a no-op when no entry is focused', () {
        final state = _makeState();
        final shortcuts = defaultMenuItemShortcuts(state);
        final arrowRightCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.arrowRight)]!;

        // Should not throw
        expect(() => arrowRightCallback(), returnsNormally);
        state.dispose();
      });

      test('is a no-op when focused entry is not a ContextMenuItem', () {
        final state = _makeState();
        // Create a checkable item (not a ContextMenuItem)
        final checkableItem = CheckableMenuItem<String>(
          label: const Text('Check'),
          checked: false,
        );
        int activationCount = 0;
        state.registerActivator(checkableItem, () => activationCount++);
        state.setFocusedEntry(checkableItem);

        final shortcuts = defaultMenuItemShortcuts(state);
        final arrowRightCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.arrowRight)]!;
        arrowRightCallback();

        // Checkable item is not ContextMenuItem, so arrow right does nothing
        expect(activationCount, 0);
        state.dispose();
      });

      test('is a no-op when focused ContextMenuItem is not a submenu item', () {
        final state = _makeState();
        final regularItem = MenuItem<String>(label: const Text('Item'), value: 'val');
        int activationCount = 0;
        state.registerActivator(regularItem, () => activationCount++);
        state.setFocusedEntry(regularItem);

        final shortcuts = defaultMenuItemShortcuts(state);
        final arrowRightCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.arrowRight)]!;
        arrowRightCallback();

        // Regular item (not submenu), so arrow right does nothing
        expect(activationCount, 0);
        state.dispose();
      });

      test('activates focused submenu item when submenu is not open', () {
        final childItem = MenuItem<String>(label: const Text('Child'), value: 'child');
        final submenuItem = MenuItem<String>.submenu(
          label: const Text('Submenu'),
          items: [childItem],
        );

        final state = _makeState(entries: [submenuItem]);
        int activationCount = 0;
        state.registerActivator(submenuItem, () => activationCount++);
        state.setFocusedEntry(submenuItem);

        // Ensure submenu is NOT open (it shouldn't be by default)
        expect(state.isSubmenuOpen, isFalse);

        final shortcuts = defaultMenuItemShortcuts(state);
        final arrowRightCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.arrowRight)]!;
        arrowRightCallback();

        // Should activate the submenu item
        expect(activationCount, 1);
        state.dispose();
      });

      test('is a no-op when focused entry is already the selected (open) item', () {
        final childItem = MenuItem<String>(label: const Text('Child'), value: 'child');
        final submenuItem = MenuItem<String>.submenu(
          label: const Text('Submenu'),
          items: [childItem],
        );

        final state = _makeState(entries: [submenuItem]);
        int activationCount = 0;
        state.registerActivator(submenuItem, () => activationCount++);
        state.setFocusedEntry(submenuItem);

        // Simulate: submenu is the "selected item" (but not actually open via overlay)
        // When focusedEntry == selectedItem, arrowRight should not activate again
        // We simulate by setting selectedItem directly via setSelectedItem
        state.setSelectedItem(submenuItem);

        final shortcuts = defaultMenuItemShortcuts(state);
        final arrowRightCallback = shortcuts[const SingleActivator(LogicalKeyboardKey.arrowRight)]!;
        arrowRightCallback();

        // focusedEntry == selectedItem, so should NOT activate
        expect(activationCount, 0);
        state.dispose();
      });
    });

    group('callbacks are independent per state instance', () {
      test('shortcuts from different states call correct activators', () {
        final state1 = _makeState();
        final state2 = _makeState();

        final entry1 = MenuItem<String>(label: const Text('Item 1'), value: 'v1');
        final entry2 = MenuItem<String>(label: const Text('Item 2'), value: 'v2');
        int calls1 = 0;
        int calls2 = 0;

        state1.registerActivator(entry1, () => calls1++);
        state1.setFocusedEntry(entry1);

        state2.registerActivator(entry2, () => calls2++);
        state2.setFocusedEntry(entry2);

        final shortcuts1 = defaultMenuItemShortcuts(state1);
        final shortcuts2 = defaultMenuItemShortcuts(state2);

        shortcuts1[const SingleActivator(LogicalKeyboardKey.space)]!();
        expect(calls1, 1);
        expect(calls2, 0);

        shortcuts2[const SingleActivator(LogicalKeyboardKey.enter)]!();
        expect(calls1, 1);
        expect(calls2, 1);

        state1.dispose();
        state2.dispose();
      });
    });
  });
}
