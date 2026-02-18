
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';

void main() {
  late ThemeController controller;

  setUp(() {
    controller = ThemeController();
  });

  group('ThemeController', () {
    test('initial state should be light mode', () {
      expect(controller.mode, ThemeMode.light);
      expect(controller.isDark, false);
      expect(controller.highContrast, false);
    });

    test('toggleDarkMode should switch modes', () {
      controller.toggleDarkMode(true);
      expect(controller.mode, ThemeMode.dark);
      expect(controller.isDark, true);

      controller.toggleDarkMode(false);
      expect(controller.mode, ThemeMode.light);
      expect(controller.isDark, false);
    });

    test('toggleHighContrast should update state', () {
      controller.toggleHighContrast(true);
      expect(controller.highContrast, true);

      controller.toggleHighContrast(false);
      expect(controller.highContrast, false);
    });
  });
}
