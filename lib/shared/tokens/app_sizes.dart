class AppSizes {
  AppSizes._();

  // ======================================================
  // 📐 Layout geral
  // ======================================================

  /// Largura máxima de conteúdo (cards, formulários)
  static const double maxContentWidth = 420;

  /// Largura máxima em telas grandes (dashboard)
  static const double maxPageWidth = 1200;

  /// Altura mínima de áreas clicáveis (acessibilidade)
  static const double minTapArea = 48;

  // ======================================================
  // 🔘 Botões
  // ======================================================

  static const double buttonHeight = 48;
  static const double buttonHeightSmall = 40;
  static const double buttonHeightLarge = 56;

  static const double buttonIconSize = 20;

  // ======================================================
  // 🧾 Inputs / formulários
  // ======================================================

  static const double inputHeight = 48;
  static const double inputIconSize = 20;
  static const double inputBorderRadius = 12;

  // ======================================================
  // 🪪 Cards
  // ======================================================

  static const double cardBorderRadius = 16;
  static const double cardElevation = 4;

  // ======================================================
  // 🧭 AppBar / Header
  // ======================================================

  static const double appBarHeight = 64;
  static const double appBarIconSize = 24;

  // ======================================================
  // 🖼 Ícones
  // ======================================================

  static const double iconXS = 12;
  static const double iconSM = 16;
  static const double iconMD = 24;
  static const double iconLG = 32;
  static const double iconXL = 40;

  // ======================================================
  // 🧠 Avatares / imagens
  // ======================================================

  static const double avatarSM = 32;
  static const double avatarMD = 40;
  static const double avatarLG = 56;

  // ======================================================
  // 📊 Grids / Layout responsivo
  // ======================================================

  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;

  static const int gridColumnsMobile = 1;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsDesktop = 4;
}
