
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_settings_controller.dart';

void main() {
  late ProfileSettingsController controller;

  setUp(() {
    controller = ProfileSettingsController();
  });

  group('ProfileSettingsController', () {
    test('initial state should be correct', () {
      expect(controller.hideDistractions, false);
      expect(controller.highContrast, false);
      expect(controller.darkMode, false);
      expect(controller.breakReminder, true);
    });

    test('setters should update state', () {
      controller.setHideDistractions(true);
      expect(controller.hideDistractions, true);

      controller.setHighContrast(true);
      expect(controller.highContrast, true);

      controller.setDarkMode(true);
      expect(controller.darkMode, true);
      
      controller.setBreakReminder(false);
      expect(controller.breakReminder, false);

      controller.setTimeOnTaskAlert(false);
      expect(controller.timeOnTaskAlert, false);

      controller.setSmoothTransition(false);
      expect(controller.smoothTransition, false);

      controller.setPushNotifications(false);
      expect(controller.pushNotifications, false);

      controller.setNotificationSounds(true);
      expect(controller.notificationSounds, true);
    });
  });
}
