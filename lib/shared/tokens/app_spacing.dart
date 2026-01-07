import 'package:flutter/material.dart';

/// =======================================================
/// 📐 Design Tokens — Spacing
/// Completo, previsível e responsivo
/// Web + Android + iOS
/// Baseado no sistema 8px (Material Design)
/// =======================================================
class AppSpacing {
  AppSpacing._();

  // ======================================================
  // 🔹 BASE UNIT (8px system)
  // ======================================================
  static const double base = 8.0;

  // ======================================================
  // 🔹 SPACING SCALE (RAW VALUES)
  // ======================================================
  static const double xxs = 2.0;
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;
  static const double massive = 80.0;

  // ======================================================
  // 🔹 PAGE / LAYOUT
  // ======================================================
  static const double pagePaddingMobile = 16.0;
  static const double pagePaddingTablet = 24.0;
  static const double pagePaddingDesktop = 32.0;

  static const double sectionGapSm = 16.0;
  static const double sectionGapMd = 24.0;
  static const double sectionGapLg = 32.0;

  // ======================================================
  // 🔹 COMPONENT SPACING
  // ======================================================
  static const double cardPaddingSm = 16.0;
  static const double cardPadding = 24.0;
  static const double cardPaddingLg = 32.0;

  static const double inputPadding = 16.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightLarge = 56.0;

  // ======================================================
  // 🔹 BORDER RADIUS
  // ======================================================
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;

  // ======================================================
  // 🔹 RESPONSIVE BREAKPOINTS
  // ======================================================
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;

  // ======================================================
  // 🔹 RESPONSIVE HELPERS
  // ======================================================

  /// Padding horizontal responsivo (páginas)
  static double pagePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= breakpointDesktop) {
      return pagePaddingDesktop;
    } else if (width >= breakpointTablet) {
      return pagePaddingTablet;
    }
    return pagePaddingMobile;
  }

  /// Espaçamento entre seções (vertical)
  static double sectionGap(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= breakpointDesktop) {
      return sectionGapLg;
    } else if (width >= breakpointTablet) {
      return sectionGapMd;
    }
    return sectionGapSm;
  }

  // ======================================================
  // 🔹 EDGEINSETS HELPERS (MUITO USADO)
  // ======================================================
  static EdgeInsets all(double value) =>
      EdgeInsets.all(value);

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  static EdgeInsets page(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: pagePadding(context),
        vertical: md,
      );

  static EdgeInsets card(BuildContext context) =>
      EdgeInsets.all(
        MediaQuery.of(context).size.width >= breakpointDesktop
            ? cardPaddingLg
            : cardPadding,
      );

  // ======================================================
  // 🔹 SIZEDBOX HELPERS (GAPS)
  // ======================================================
  static SizedBox gap(double value) =>
      SizedBox(height: value, width: value);

  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);

  static const SizedBox hGapSm = SizedBox(width: sm);
  static const SizedBox hGapMd = SizedBox(width: md);
  static const SizedBox hGapLg = SizedBox(width: lg);
}
