// cognitive_panel_models.dart

// =======================
// Enums (seus atuais)
// =======================
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

// =======================
// Labels (seus atuais)
// =======================
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

// =======================
// ✅ Regras do Painel Cognitivo (seu atual)
// =======================
extension CognitiveRules on InterfaceComplexity {
  // Modo resumo / balanceado / detalhado
  List<DisplayMode> get allowedDisplayModes => switch (this) {
        InterfaceComplexity.simple => const [DisplayMode.summary],
        InterfaceComplexity.medium =>
          const [DisplayMode.summary, DisplayMode.balanced],
        InterfaceComplexity.advanced => DisplayMode.values,
      };

  // Espaçamento
  List<ElementSpacing> get allowedSpacings => switch (this) {
        InterfaceComplexity.simple =>
          const [ElementSpacing.medium, ElementSpacing.high],
        _ => ElementSpacing.values,
      };

  // Tamanho de fonte
  List<FontSizePreference> get allowedFontSizes => switch (this) {
        InterfaceComplexity.simple =>
          const [FontSizePreference.normal, FontSizePreference.large],
        _ => FontSizePreference.values,
      };

  // Defaults coerentes ao trocar complexidade
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

// =======================
// ✅ NOVO: Regras dos Cards
// Alertas Cognitivos + Notificações
// =======================

// Quais opções existem no card de Alertas Cognitivos
enum CognitiveAlertSetting {
  breakReminder,
  taskTimeAlert,
  smoothTransition,
}

// Quais opções existem no card de Notificações
enum NotificationSetting {
  pushNotifications,
  notificationSounds,
}

extension PreferencesRules on InterfaceComplexity {
  // ✅ o que é permitido por complexidade (Alertas Cognitivos)
  Set<CognitiveAlertSetting> get allowedCognitiveAlerts => switch (this) {
        // Simple: menos opções / menos ruído
        InterfaceComplexity.simple => {
            CognitiveAlertSetting.breakReminder,
            CognitiveAlertSetting.smoothTransition,
          },
        // Medium/Advanced: tudo liberado
        _ => CognitiveAlertSetting.values.toSet(),
      };

  // ✅ o que é permitido por complexidade (Notificações)
  Set<NotificationSetting> get allowedNotifications => switch (this) {
        // Simple: só push (som fica travado)
        InterfaceComplexity.simple => {NotificationSetting.pushNotifications},
        // Medium/Advanced: tudo liberado
        _ => NotificationSetting.values.toSet(),
      };

  // ✅ Defaults (aplicados quando TROCA complexidade, igual seu painel)
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

// =======================
// (Opcional, mas útil)
// Escalas (para UI)
// =======================
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
