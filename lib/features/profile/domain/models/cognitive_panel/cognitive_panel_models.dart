enum InterfaceComplexity {
  simple,
  medium,
  advanced,
}

enum DisplayMode {
  summary,
  balanced,
  detailed,
}

enum ElementSpacing {
  low,
  medium,
  high,
}

enum FontSizePreference {
  small,
  normal,
  large,
}

extension InterfaceComplexityLabel on InterfaceComplexity {
  String get label => switch (this) {
        InterfaceComplexity.simple => 'Simples - Menos opções e distrações',
        InterfaceComplexity.medium => 'Médio - Balanceado',
        InterfaceComplexity.advanced => 'Avançado - Todas as funcionalidades',
      };
}

extension DisplayModeLabel on DisplayMode {
  String get label => switch (this) {
        DisplayMode.summary => 'Resumo - Informações essenciais',
        DisplayMode.balanced => 'Balanceado',
        DisplayMode.detailed => 'Detalhado - Todas as informações',
      };
}

extension ElementSpacingLabel on ElementSpacing {
  String get label => switch (this) {
        ElementSpacing.low => 'Baixo',
        ElementSpacing.medium => 'Médio',
        ElementSpacing.high => 'Alto',
      };
}

extension FontSizePreferenceLabel on FontSizePreference {
  String get label => switch (this) {
        FontSizePreference.small => 'Pequena',
        FontSizePreference.normal => 'Normal',
        FontSizePreference.large => 'Grande',
      };
}

extension CognitiveRules on InterfaceComplexity {
  List<DisplayMode> get allowedDisplayModes => switch (this) {
        InterfaceComplexity.simple => const [DisplayMode.summary],
        InterfaceComplexity.medium =>
          const [DisplayMode.summary, DisplayMode.balanced],
        InterfaceComplexity.advanced => DisplayMode.values,
      };

  List<ElementSpacing> get allowedSpacings => switch (this) {
        InterfaceComplexity.simple =>
          const [ElementSpacing.medium, ElementSpacing.high],
        _ => ElementSpacing.values,
      };

  List<FontSizePreference> get allowedFontSizes => switch (this) {
        InterfaceComplexity.simple =>
          const [FontSizePreference.normal, FontSizePreference.large],
        _ => FontSizePreference.values,
      };

  DisplayMode get defaultDisplayMode => switch (this) {
        InterfaceComplexity.simple => DisplayMode.summary,
        InterfaceComplexity.medium => DisplayMode.balanced,
        InterfaceComplexity.advanced => DisplayMode.detailed,
      };

  ElementSpacing get defaultSpacing => switch (this) {
        InterfaceComplexity.simple => ElementSpacing.high,
        InterfaceComplexity.medium => ElementSpacing.medium,
        InterfaceComplexity.advanced => ElementSpacing.low,
      };

  FontSizePreference get defaultFontSize => switch (this) {
        InterfaceComplexity.simple => FontSizePreference.normal,
        InterfaceComplexity.medium => FontSizePreference.normal,
        InterfaceComplexity.advanced => FontSizePreference.small,
      };
}

enum CognitiveAlertSetting {
  breakReminder,
  taskTimeAlert,
  smoothTransition,
}

enum NotificationSetting {
  pushNotifications,
  notificationSounds,
}

extension PreferencesRules on InterfaceComplexity {
  Set<CognitiveAlertSetting> get allowedCognitiveAlerts => switch (this) {
        InterfaceComplexity.simple => {
            CognitiveAlertSetting.breakReminder,
            CognitiveAlertSetting.smoothTransition,
          },
        _ => CognitiveAlertSetting.values.toSet(),
      };

  Set<NotificationSetting> get allowedNotifications => switch (this) {
        InterfaceComplexity.simple => {NotificationSetting.pushNotifications},
        _ => NotificationSetting.values.toSet(),
      };

  bool defaultCognitiveAlertValue(CognitiveAlertSetting s) => switch (this) {
        InterfaceComplexity.simple => switch (s) {
            CognitiveAlertSetting.breakReminder => true,
            CognitiveAlertSetting.smoothTransition => true,
            CognitiveAlertSetting.taskTimeAlert => false,
          },
        InterfaceComplexity.medium => switch (s) {
            CognitiveAlertSetting.breakReminder => true,
            CognitiveAlertSetting.smoothTransition => true,
            CognitiveAlertSetting.taskTimeAlert => true,
          },
        InterfaceComplexity.advanced => switch (s) {
            CognitiveAlertSetting.breakReminder => true,
            CognitiveAlertSetting.smoothTransition => true,
            CognitiveAlertSetting.taskTimeAlert => true,
          },
      };

  bool defaultNotificationValue(NotificationSetting s) => switch (this) {
        InterfaceComplexity.simple => switch (s) {
            NotificationSetting.pushNotifications => true,
            NotificationSetting.notificationSounds => false,
          },
        _ => switch (s) {
            NotificationSetting.pushNotifications => true,
            NotificationSetting.notificationSounds => false,
          },
      };
}

extension SpacingScale on ElementSpacing {
  double get scale => switch (this) {
        ElementSpacing.low => 0.90,
        ElementSpacing.medium => 1.00,
        ElementSpacing.high => 1.15,
      };
}

extension FontScale on FontSizePreference {
  double get scale => switch (this) {
        FontSizePreference.small => 0.92,
        FontSizePreference.normal => 1.00,
        FontSizePreference.large => 1.15,
      };
}
