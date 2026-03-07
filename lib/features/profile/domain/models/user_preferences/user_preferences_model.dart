import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class UserPreferencesModel {
  final String userId;
  final bool hideDistractions;
  final bool highContrast;
  final bool darkMode;
  final bool breakReminder;
  final bool taskTimeAlert;
  final bool smoothTransition;
  final bool pushNotifications;
  final bool notificationSounds;
  final InterfaceComplexity complexity;
  final DisplayMode displayMode;
  final FontSizePreference fontSize;
  final ElementSpacing elementSpacing;

  UserPreferencesModel({
    required this.userId,
    required this.hideDistractions,
    required this.highContrast,
    required this.darkMode,
    required this.breakReminder,
    required this.taskTimeAlert,
    required this.smoothTransition,
    required this.pushNotifications,
    required this.notificationSounds,
    required this.complexity,
    required this.displayMode,
    required this.fontSize,
    required this.elementSpacing,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      userId: json['user_id'] ?? '',
      hideDistractions: json['hide_distractions'] ?? false,
      highContrast: json['high_contrast'] ?? false,
      darkMode: json['dark_mode'] ?? false,
      breakReminder: json['break_reminder'] ?? true,
      taskTimeAlert: json['task_time_alert'] ?? true,
      smoothTransition: json['smooth_transition'] ?? true,
      pushNotifications: json['push_notifications'] ?? true,
      notificationSounds: json['notification_sounds'] ?? false,
      complexity: InterfaceComplexity.values.firstWhere(
        (e) => e.name == (json['complexity'] as String?),
        orElse: () => InterfaceComplexity.medium,
      ),
      displayMode: DisplayMode.values.firstWhere(
        (e) => e.name == (json['display_mode'] as String?),
        orElse: () => DisplayMode.balanced,
      ),
      fontSize: FontSizePreference.values.firstWhere(
        (e) => e.name == (json['font_size'] as String?),
        orElse: () => FontSizePreference.normal,
      ),
      elementSpacing: ElementSpacing.values.firstWhere(
        (e) => e.name == (json['element_spacing'] as String?),
        orElse: () => ElementSpacing.medium,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'hide_distractions': hideDistractions,
      'high_contrast': highContrast,
      'dark_mode': darkMode,
      'break_reminder': breakReminder,
      'task_time_alert': taskTimeAlert, 
      'smooth_transition': smoothTransition,
      'push_notifications': pushNotifications,
      'notification_sounds': notificationSounds,
      'complexity': complexity.name,
      'display_mode': displayMode.name,
      'font_size': fontSize.name,
      'element_spacing': elementSpacing.name,
    };
  }
  
  // Factory para valores padrão
  factory UserPreferencesModel.defaults(String userId) {
    return UserPreferencesModel(
      userId: userId,
      hideDistractions: false,
      highContrast: false,
      darkMode: false,
      breakReminder: true,
      taskTimeAlert: true,
      smoothTransition: true,
      pushNotifications: true,
      notificationSounds: false,
      complexity: InterfaceComplexity.medium,
      displayMode: DisplayMode.balanced,
      fontSize: FontSizePreference.normal,
      elementSpacing: ElementSpacing.medium,
    );
  }
}
