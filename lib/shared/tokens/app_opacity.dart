/// =======================================================
/// 🌫️ Design Tokens — Opacity / Alpha
/// Semântico, consistente e acessível (WCAG)
/// Usado com Color.withValues(alpha: ...)
/// =======================================================
class AppOpacity {
  AppOpacity._();

  // ======================================================
  // 🔹 BACKGROUND / SURFACE OVERLAYS
  // ======================================================

  /// Overlay muito sutil (hover leve, superfícies elevadas)
  static const double subtle = 0.04;

  /// Overlay suave (cards sobre gradiente, backgrounds translúcidos)
  static const double soft = 0.15;

  /// Overlay médio (borders, separadores, ícones decorativos)
  static const double medium = 0.20;

  /// Overlay forte (scrim, overlays modais)
  static const double strong = 0.60;

  // ======================================================
  // 🔹 INTERACTION STATES (Material 3)
  // ======================================================

  static const double hover = 0.04;
  static const double pressed = 0.08;
  static const double focus = 0.12;

  // ======================================================
  // 🔹 DISABLED STATES
  // ======================================================

  static const double disabled = 0.38;
  static const double disabledContent = 0.50;
}
