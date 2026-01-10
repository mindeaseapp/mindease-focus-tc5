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
// ✅ Regras (NOVO)
// =======================
extension CognitiveRules on InterfaceComplexity {
  // Modo resumo / balanceado / detalhado (briefing)
  List<DisplayMode> get allowedDisplayModes => switch (this) {
        InterfaceComplexity.simple => const [DisplayMode.summary],
        InterfaceComplexity.medium =>
          const [DisplayMode.summary, DisplayMode.balanced],
        InterfaceComplexity.advanced => DisplayMode.values,
      };

  // Espaçamento (briefing)
  List<ElementSpacing> get allowedSpacings => switch (this) {
        InterfaceComplexity.simple =>
          const [ElementSpacing.medium, ElementSpacing.high],
        _ => ElementSpacing.values,
      };

  // Tamanho de fonte (briefing)
  List<FontSizePreference> get allowedFontSizes => switch (this) {
        InterfaceComplexity.simple =>
          const [FontSizePreference.normal, FontSizePreference.large],
        _ => FontSizePreference.values,
      };

  // Defaults coerentes ao trocar complexidade (previsibilidade)
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
