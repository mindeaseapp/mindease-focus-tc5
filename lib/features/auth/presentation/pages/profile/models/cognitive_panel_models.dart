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
