
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';

void main() {
  late FocusModeController controller;

  setUp(() {
    controller = FocusModeController();
  });

  group('FocusModeController', () {
    test('initial state should be disabled', () {
      expect(controller.enabled, false);
    });

    test('toggle should switch state', () {
      controller.toggle();
      expect(controller.enabled, true);

      controller.toggle();
      expect(controller.enabled, false);
    });

    test('setEnabled should set specific state', () {
      controller.setEnabled(true);
      expect(controller.enabled, true);

      controller.setEnabled(false);
      expect(controller.enabled, false);

      // Should not notify if value is same
      bool notified = false;
      controller.addListener(() => notified = true);
      controller.setEnabled(false);
      expect(notified, false);
    });
  });
}
