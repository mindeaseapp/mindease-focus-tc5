import 'package:flutter/material.dart';

/// =======================================================
/// 🎨 Design Tokens — Colors
/// Completo, acessível e Material 3 friendly
/// Web + Android + iOS
/// =======================================================
class AppColors {
  AppColors._();

  // ======================================================
  // 🎨 BRAND / PRIMARY
  // ======================================================
  static const Color primary = Color(0xFF3B5BFF);
  static const Color primaryDark = Color(0xFF2F49CC);
  static const Color primaryLight = Color(0xFF6C83FF);

  static const Color secondary = Color(0xFF7B2CFF);
  static const Color secondaryLight = Color(0xFF9F6BFF);
  static const Color secondaryDark = Color(0xFF5A1FCC);

  static const Color gradientStart = primary;
  static const Color gradientEnd = secondary;

  // ======================================================
  // 🌫️ BACKGROUND / SURFACE (LIGHT)
  // ======================================================
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF1F5F9);
  static const Color surfaceAlt = Color(0xFFEFF6FF);

  static const Color card = Colors.white;
  static const Color cardMuted = Color(0xFFF8FAFC);

  // ======================================================
  // 🌑 BACKGROUND / SURFACE (DARK)
  // ======================================================
  static const Color backgroundDark = Color(0xFF020617);
  static const Color surfaceDark = Color(0xFF020617);
  static const Color cardDark = Color(0xFF020617);

  // ======================================================
  // 📝 TEXT (LIGHT)
  // ======================================================
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textOnPrimary = Colors.white;

  // ======================================================
  // 📝 TEXT (DARK)
  // ======================================================
  static const Color textPrimaryDark = Color(0xFFE5E7EB);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textDisabledDark = Color(0xFF475569);

  // ======================================================
  // 🧩 BORDERS / DIVIDERS
  // ======================================================
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color borderDark = Color(0xFF334155);

  // ======================================================
  // 🎯 FEEDBACK / STATUS
  // ======================================================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color infoBg = Color(0xFFE0F2FE);

  // ======================================================
  // 🔘 BUTTONS
  // ======================================================
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryText = Colors.white;

  static const Color buttonSecondary = Color(0xFFE5E7EB);
  static const Color buttonSecondaryText = Color(0xFF0F172A);

  static const Color buttonDisabled = Color(0xFFE2E8F0);
  static const Color buttonDisabledText = Color(0xFF94A3B8);

  // ======================================================
  // 🧪 INPUTS
  // ======================================================
  static const Color inputBackground = Colors.white;
  static const Color inputBackgroundDark = Color(0xFF020617);

  static const Color inputBorder = Color(0xFFCBD5E1);
  static const Color inputFocusedBorder = primary;
  static const Color inputErrorBorder = error;
  static const Color inputHint = Color(0xFF94A3B8);

  // ======================================================
  // 🧠 FOCUS / STATES / ACCESSIBILITY
  // ======================================================
  static const Color focus = Color(0xFF38BDF8);
  static const Color focusRing = Color(0x8038BDF8); // 50%

  static const Color hover = Color(0x143B5BFF);   // 8%
  static const Color pressed = Color(0x1F3B5BFF); // 12%

  // ======================================================
  // 🪟 OVERLAY / SCRIM
  // ======================================================
  static const Color overlay = Color(0x99000000);
  static const Color scrim = Color(0x66000000);

  // ======================================================
  // 🎨 MATERIAL 3 COLOR SCHEMES
  // ======================================================
  static ColorScheme lightScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: error,
    onError: Colors.white,
    background: background,
    onBackground: textPrimary,
    surface: surface,
    onSurface: textPrimary,
  );

  static ColorScheme darkScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: Colors.black,
    secondary: secondaryLight,
    onSecondary: Colors.black,
    error: error,
    onError: Colors.black,
    background: backgroundDark,
    onBackground: textPrimaryDark,
    surface: surfaceDark,
    onSurface: textPrimaryDark,
  );
}
