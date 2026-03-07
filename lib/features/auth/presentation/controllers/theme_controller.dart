import 'package:flutter/material.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  bool _highContrast = false;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  bool get highContrast => _highContrast;

  void toggleDarkMode(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (_mode == next) return; 
    _mode = next;
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    if (_highContrast == value) return;
    _highContrast = value;
    notifyListeners();
  }

  void updateFromPreferences(ProfilePreferencesController? prefs) {
    if (prefs == null) return;
    
    final shouldBeDark = prefs.darkMode;
    final targetMode = shouldBeDark ? ThemeMode.dark : ThemeMode.light;
    if (_mode != targetMode) {
      _mode = targetMode;
      notifyListeners();
    }
    
    if (_highContrast != prefs.highContrast) {
      _highContrast = prefs.highContrast;
      notifyListeners();
    }
  }
}
