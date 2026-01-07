import 'package:flutter/material.dart';

/// Design Tokens — Colors
/// Paleta pensada para acessibilidade cognitiva,
/// contraste adequado e reutilização global
class AppColors {

  /* ───────────────────────────
   * 🎨 BRAND / PRIMARY
   * ─────────────────────────── */

  static const Color primary = Color(0xFF3B5BFF);
  static const Color primaryDark = Color(0xFF2F49CC);
  static const Color primaryLight = Color(0xFF6C83FF);

  static const Color gradientStart = Color(0xFF3B5BFF);
  static const Color gradientEnd   = Color(0xFF7B2CFF);

  /* ───────────────────────────
   * 🌫️ BACKGROUND / SURFACE
   * ─────────────────────────── */

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF1F5F9);

  static const Color card = Colors.white;
  static const Color cardMuted = Color(0xFFF8FAFC);

  /* ───────────────────────────
   * 📝 TEXT
   * ─────────────────────────── */

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textOnPrimary = Colors.white;

  /* ───────────────────────────
   * 🧩 BORDERS / DIVIDERS
   * ─────────────────────────── */

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFE5E7EB);

  /* ───────────────────────────
   * 🎯 ACTIONS / STATES
   * ─────────────────────────── */

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color infoBg = Color(0xFFE0F2FE);

  /* ───────────────────────────
   * 🖱️ BUTTONS
   * ─────────────────────────── */

  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryText = Colors.white;

  static const Color buttonSecondary = Color(0xFFE5E7EB);
  static const Color buttonSecondaryText = Color(0xFF0F172A);

  static const Color buttonDisabled = Color(0xFFE2E8F0);
  static const Color buttonDisabledText = Color(0xFF94A3B8);

  /* ───────────────────────────
   * 🧠 FOCUS / ACCESSIBILITY
   * ─────────────────────────── */

  static const Color focus = Color(0xFF38BDF8);
  static const Color focusRing = Color(0x8038BDF8); // 50% opacity

  static const Color overlay = Color(0x99000000); // dialogs / modals

  /* ───────────────────────────
   * 🧪 INPUTS
   * ─────────────────────────── */

  static const Color inputBackground = Colors.white;
  static const Color inputBorder = Color(0xFFCBD5E1);
  static const Color inputFocusedBorder = primary;
  static const Color inputErrorBorder = error;
  static const Color inputHint = Color(0xFF94A3B8);
}
