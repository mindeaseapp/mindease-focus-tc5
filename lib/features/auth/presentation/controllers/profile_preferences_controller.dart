import 'package:flutter/foundation.dart';

class ProfilePreferencesController extends ChangeNotifier {
  // ==========================
  // Modo Foco
  // ==========================
  bool hideDistractions = false;
  bool highContrast = false;
  bool darkMode = false;

  // ==========================
  // Alertas Cognitivos
  // ==========================
  bool breakReminder = true;
  bool taskTimeAlert = true;
  bool smoothTransition = true;

  // ==========================
  // Notificações
  // ==========================
  bool pushNotifications = true;
  bool notificationSounds = false;

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

  void setTaskTimeAlert(bool v) {
    taskTimeAlert = v;
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
