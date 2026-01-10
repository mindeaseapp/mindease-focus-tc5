import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  bool _highContrast = false;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  bool get highContrast => _highContrast;

  void toggleDarkMode(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (_mode == next) return; // ✅ evita notify à toa
    _mode = next;
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    if (_highContrast == value) return;
    _highContrast = value;
    notifyListeners();
  }
}
