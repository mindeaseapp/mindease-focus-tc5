import 'package:flutter/foundation.dart';

class ProfileSettingsController extends ChangeNotifier {
  bool hideDistractions;
  bool highContrast;
  bool darkMode;

  bool breakReminder;
  bool timeOnTaskAlert;
  bool smoothTransition;

  bool pushNotifications;
  bool notificationSounds;

  ProfileSettingsController({
    this.hideDistractions = false,
    this.highContrast = false,
    this.darkMode = false,
    this.breakReminder = true,
    this.timeOnTaskAlert = true,
    this.smoothTransition = true,
    this.pushNotifications = true,
    this.notificationSounds = false,
  });

  void setHideDistractions(bool v) {
    hideDistractions = v;
    notifyListeners();
  }

  void setHighContrast(bool v) {
    highContrast = v;
    notifyListeners();
  }

  void setDarkMode(bool v) {
    darkMode = v;
    notifyListeners();
  }

  void setBreakReminder(bool v) {
    breakReminder = v;
    notifyListeners();
  }

  void setTimeOnTaskAlert(bool v) {
    timeOnTaskAlert = v;
    notifyListeners();
  }

  void setSmoothTransition(bool v) {
    smoothTransition = v;
    notifyListeners();
  }

  void setPushNotifications(bool v) {
    pushNotifications = v;
    notifyListeners();
  }

  void setNotificationSounds(bool v) {
    notificationSounds = v;
    notifyListeners();
  }
}
