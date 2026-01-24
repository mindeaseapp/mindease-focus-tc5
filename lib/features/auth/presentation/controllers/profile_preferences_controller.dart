import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/auth/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/user_preferences/user_preferences_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel/cognitive_panel_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePreferencesController extends ChangeNotifier {
  final ProfileRepository? repository;
  
  // Debounce para evitar excesso de writes
  Timer? _debounceTimer;
  String? _currentUserId;

  ProfilePreferencesController({
    this.repository,
  });

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

  // ==========================
  // Initialization
  // ==========================
  Future<void> loadPreferences(String userId) async {
    if (repository == null) return;
    _currentUserId = userId;

    try {
      final prefs = await repository!.getPreferences(userId);
      
      hideDistractions = prefs.hideDistractions;
      highContrast = prefs.highContrast;
      darkMode = prefs.darkMode;
      breakReminder = prefs.breakReminder;
      taskTimeAlert = prefs.taskTimeAlert;
      smoothTransition = prefs.smoothTransition;
      pushNotifications = prefs.pushNotifications;
      notificationSounds = prefs.notificationSounds;
      _complexity = prefs.complexity;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  void _scheduleSave() {
    // Fallback: Se _currentUserId for nulo, tenta pegar da sessão atual
    if (_currentUserId == null) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        _currentUserId = user.id;
      }
    }

    if (repository == null || _currentUserId == null) return;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final prefs = UserPreferencesModel(
        userId: _currentUserId!,
        hideDistractions: hideDistractions,
        highContrast: highContrast,
        darkMode: darkMode,
        breakReminder: breakReminder,
        taskTimeAlert: taskTimeAlert,
        smoothTransition: smoothTransition,
        pushNotifications: pushNotifications,
        notificationSounds: notificationSounds,
        complexity: _complexity,
      );
      
      repository!.updatePreferences(prefs).catchError((e) {
        debugPrint('Error saving preferences: $e');
      });
    });
  }  

  /// ✅ Chame isso sempre que o usuário trocar a complexidade no Painel Cognitivo
  void applyComplexity(InterfaceComplexity value) {
    if (_complexity == value) return;
    _complexity = value;

    _enforceAfterComplexityChange();
    notifyListeners();
    _scheduleSave();
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
    _scheduleSave();
  }

  void setHighContrast(bool v) {
    highContrast = v;
    notifyListeners();
    _scheduleSave();
  }

  void setDarkMode(bool v) {
    darkMode = v;
    notifyListeners();
    _scheduleSave();
  }

  void setBreakReminder(bool v) {
    // ✅ trava se a complexidade não permitir (extra proteção)
    if (!_complexity.allowedCognitiveAlerts.contains(CognitiveAlertSetting.breakReminder)) return;

    breakReminder = v;
    notifyListeners();
    _scheduleSave();
  }

  void setTaskTimeAlert(bool v) {
    if (!_complexity.allowedCognitiveAlerts.contains(CognitiveAlertSetting.taskTimeAlert)) return;

    taskTimeAlert = v;
    notifyListeners();
    _scheduleSave();
  }

  void setSmoothTransition(bool v) {
    if (!_complexity.allowedCognitiveAlerts.contains(CognitiveAlertSetting.smoothTransition)) return;

    smoothTransition = v;
    notifyListeners();
    _scheduleSave();
  }

  void setPushNotifications(bool v) {
    if (!_complexity.allowedNotifications.contains(NotificationSetting.pushNotifications)) return;

    pushNotifications = v;
    _enforceDependencies();
    notifyListeners();
    _scheduleSave();
  }

  void setNotificationSounds(bool v) {
    // ✅ só pode se:
    // - for permitido na complexidade
    // - push estiver ON
    if (!_complexity.allowedNotifications.contains(NotificationSetting.notificationSounds)) return;
    if (!pushNotifications) return;

    notificationSounds = v;
    notifyListeners();
    _scheduleSave();
  }
}
