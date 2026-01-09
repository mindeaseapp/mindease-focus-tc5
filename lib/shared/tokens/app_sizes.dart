import 'package:flutter/material.dart';

/// =======================================================
/// 📏 Design Tokens — Sizes
/// Completo, acessível e responsivo
/// Web + Android + iOS
/// =======================================================
class AppSizes {
  AppSizes._();

  // ======================================================
  // 📐 PAGE / LAYOUT WIDTHS
  // ======================================================

  /// Conteúdo central (forms, login, auth)
  static const double maxContentWidth = 420;

  /// Páginas padrão
  static const double maxPageWidth = 1200;

  /// Dashboards / telas grandes
  static const double maxWidePageWidth = 1440;

  // ======================================================
  // 🧍 ACCESSIBILITY (WCAG)
  // ======================================================

  /// Área mínima clicável
  static const double minTapArea = 48;

  // ======================================================
  // 🔘 BUTTONS
  // ======================================================

  static const double buttonHeightXs = 36;
  static const double buttonHeightSm = 40;
  static const double buttonHeight = 48;
  static const double buttonHeightLg = 56;

  static const double buttonIconSize = 20;

  // ======================================================
  // 🧾 INPUTS / FORMS
  // ======================================================

  static const double inputHeightSm = 40;
  static const double inputHeight = 48;
  static const double inputHeightLg = 56;

  static const double inputIconSize = 20;
  static const double inputBorderRadius = 12;

  // ======================================================
  // 🪪 CARDS
  // ======================================================

  static const double cardBorderRadiusSm = 12;
  static const double cardBorderRadius = 16;
  static const double cardBorderRadiusLg = 20;

  static const double cardElevationNone = 0;
  static const double cardElevationSm = 2;
  static const double cardElevation = 4;
  static const double cardElevationLg = 8;

  // ======================================================
  // 🧭 APP BAR / HEADER / NAV
  // ======================================================

  static const double appBarHeightMobile = 56;
  static const double appBarHeight = 64;
  static const double appBarHeightDesktop = 72;

  static const double appBarIconSize = 24;

  static const double bottomNavHeight = 64;
  static const double drawerWidth = 280;
  static const double railWidth = 80;

  // ======================================================
  // 🖼 ICON SIZES
  // ======================================================

  static const double iconXXS = 12;
  static const double iconXS = 16;
  static const double iconSM = 20;
  static const double iconMD = 24;
  static const double iconLG = 32;
  static const double iconXL = 40;
  static const double iconXXL = 48;

  // ======================================================
  // 🧠 AVATARS / IMAGES
  // ======================================================

  static const double avatarXS = 24;
  static const double avatarSM = 32;
  static const double avatarMD = 40;
  static const double avatarLG = 56;
  static const double avatarXL = 72;

  // ======================================================
  // 🪟 MODALS / DIALOGS
  // ======================================================

  static const double dialogWidthMobile = 320;
  static const double dialogWidthTablet = 420;
  static const double dialogWidthDesktop = 520;

  static const double dialogBorderRadius = 20;

  // ======================================================
  // 📊 RESPONSIVE BREAKPOINTS
  // ======================================================

  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;
  static const double breakpointWide = 1600;

  // ======================================================
  // 📊 GRID SYSTEM
  // ======================================================

  static const int gridColumnsMobile = 1;
  static const int gridColumnsTablet = 2;
  static const int gridColumnsDesktop = 4;
  static const int gridColumnsWide = 6;

  // ======================================================
  // 🧠 RESPONSIVE HELPERS
  // ======================================================

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < breakpointTablet;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointTablet &&
      MediaQuery.of(context).size.width < breakpointDesktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointDesktop;

// ======================================================
// 🪪 FEATURE CARDS
// ======================================================

  /// Largura padrão do FeatureCard em layouts desktop
  static const double featureCardWidth = 140;

  /// Altura mínima do FeatureCard (garante cards iguais)
  static const double featureCardMinHeight = 140;
  // ======================================================
  // 📐 RESPONSIVE VALUES
  // ======================================================

  static double appBarHeightFor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= breakpointDesktop) return appBarHeightDesktop;
    if (width >= breakpointTablet) return appBarHeight;
    return appBarHeightMobile;
  }

  static int gridColumnsFor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= breakpointWide) return gridColumnsWide;
    if (width >= breakpointDesktop) return gridColumnsDesktop;
    if (width >= breakpointTablet) return gridColumnsTablet;
    return gridColumnsMobile;
  }

  static double dialogWidthFor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= breakpointDesktop) return dialogWidthDesktop;
    if (width >= breakpointTablet) return dialogWidthTablet;
    return dialogWidthMobile;
  }
}
