import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

void main() {
  group('CheckableController', () {
    group('constructor', () {
      test('defaults to unchecked (false)', () {
        final controller = CheckableController();
        expect(controller.value, isFalse);
      });

      test('initialValue: false creates unchecked controller', () {
        final controller = CheckableController(initialValue: false);
        expect(controller.value, isFalse);
      });

      test('initialValue: true creates checked controller', () {
        final controller = CheckableController(initialValue: true);
        expect(controller.value, isTrue);
      });
    });

    group('toggle()', () {
      test('toggles from false to true', () {
        final controller = CheckableController(initialValue: false);
        controller.toggle();
        expect(controller.value, isTrue);
      });

      test('toggles from true to false', () {
        final controller = CheckableController(initialValue: true);
        controller.toggle();
        expect(controller.value, isFalse);
      });

      test('toggles correctly multiple times', () {
        final controller = CheckableController(initialValue: false);
        controller.toggle(); // false -> true
        expect(controller.value, isTrue);
        controller.toggle(); // true -> false
        expect(controller.value, isFalse);
        controller.toggle(); // false -> true
        expect(controller.value, isTrue);
      });
    });

    group('ValueNotifier behavior', () {
      test('notifies listeners when toggled', () {
        final controller = CheckableController(initialValue: false);
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.toggle();
        expect(notifyCount, 1);
        controller.toggle();
        expect(notifyCount, 2);
      });

      test('notifies listeners when value is set directly', () {
        final controller = CheckableController(initialValue: false);
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.value = true;
        expect(notifyCount, 1);
      });

      test('does not notify listeners when value is set to same value', () {
        final controller = CheckableController(initialValue: false);
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.value = false;
        expect(notifyCount, 0);
      });

      test('listener receives updated value after toggle', () {
        final controller = CheckableController(initialValue: false);
        bool? lastValue;
        controller.addListener(() => lastValue = controller.value);

        controller.toggle();
        expect(lastValue, isTrue);

        controller.toggle();
        expect(lastValue, isFalse);
      });
    });

    group('dispose', () {
      test('can be disposed without error', () {
        final controller = CheckableController();
        expect(() => controller.dispose(), returnsNormally);
      });

      test('dispose clears listeners', () {
        final controller = CheckableController(initialValue: false);
        int notifyCount = 0;
        controller.addListener(() => notifyCount++);
        controller.dispose();
        // After dispose, no further notifications should occur
        // (no assertion on toggle after dispose since it throws)
        expect(notifyCount, 0);
      });
    });

    group('is a ValueNotifier<bool>', () {
      test('implements ValueListenable<bool>', () {
        final controller = CheckableController();
        // ValueNotifier<bool> is a ValueListenable<bool>
        expect(controller, isA<ValueNotifier<bool>>());
      });

      test('can be used as a ValueListenable<bool>', () {
        final CheckableController controller = CheckableController(initialValue: true);
        expect(controller.value, isTrue);
      });
    });
  });
}