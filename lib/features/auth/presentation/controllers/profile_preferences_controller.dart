import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel_models.dart';

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

  // ==========================
  // ✅ Complexidade atual (sincroniza com CognitivePanelController)
  // ==========================
  InterfaceComplexity _complexity = InterfaceComplexity.medium;
  InterfaceComplexity get complexity => _complexity;

  /// ✅ Chame isso sempre que o usuário trocar a complexidade no Painel Cognitivo
  void applyComplexity(InterfaceComplexity value) {
    if (_complexity == value) return;
    _complexity = value;

    _enforceAfterComplexityChange();
    notifyListeners();
  }

  void _enforceAfterComplexityChange() {
    // ---- Alertas Cognitivos
    final allowedAlerts = _complexity.allowedCognitiveAlerts;

    if (!allowedAlerts.contains(CognitiveAlertSetting.breakReminder)) {
      breakReminder =
          _complexity.defaultCognitiveAlertValue(CognitiveAlertSetting.breakReminder);
    }
    if (!allowedAlerts.contains(CognitiveAlertSetting.taskTimeAlert)) {
      taskTimeAlert =
          _complexity.defaultCognitiveAlertValue(CognitiveAlertSetting.taskTimeAlert);
    }
    if (!allowedAlerts.contains(CognitiveAlertSetting.smoothTransition)) {
      smoothTransition =
          _complexity.defaultCognitiveAlertValue(CognitiveAlertSetting.smoothTransition);
    }

    // ---- Notificações
    final allowedNotifs = _complexity.allowedNotifications;

    if (!allowedNotifs.contains(NotificationSetting.pushNotifications)) {
      pushNotifications = _complexity.defaultNotificationValue(
        NotificationSetting.pushNotifications,
      );
    }
    if (!allowedNotifs.contains(NotificationSetting.notificationSounds)) {
      notificationSounds = _complexity.defaultNotificationValue(
        NotificationSetting.notificationSounds,
      );
    }

    // ---- Dependência: sem push => sem som
    if (!pushNotifications && notificationSounds) {
      notificationSounds = false;
    }
  }

  void _enforceDependencies() {
    // Dependência: sem push => sem som
    if (!pushNotifications && notificationSounds) {
      notificationSounds = false;
    }
  }

  // ==========================
  // Setters (mantive seu padrão)
  // ==========================
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
    // ✅ trava se a complexidade não permitir (extra proteção)
    if (!_complexity.allowedCognitiveAlerts.contains(CognitiveAlertSetting.breakReminder)) return;

    breakReminder = v;
    notifyListeners();
  }

  void setTaskTimeAlert(bool v) {
    if (!_complexity.allowedCognitiveAlerts.contains(CognitiveAlertSetting.taskTimeAlert)) return;

    taskTimeAlert = v;
    notifyListeners();
  }

  void setSmoothTransition(bool v) {
    if (!_complexity.allowedCognitiveAlerts.contains(CognitiveAlertSetting.smoothTransition)) return;

    smoothTransition = v;
    notifyListeners();
  }

  void setPushNotifications(bool v) {
    if (!_complexity.allowedNotifications.contains(NotificationSetting.pushNotifications)) return;

    pushNotifications = v;
    _enforceDependencies();
    notifyListeners();
  }

  void setNotificationSounds(bool v) {
    // ✅ só pode se:
    // - for permitido na complexidade
    // - push estiver ON
    if (!_complexity.allowedNotifications.contains(NotificationSetting.notificationSounds)) return;
    if (!pushNotifications) return;

    notificationSounds = v;
    notifyListeners();
  }
}
