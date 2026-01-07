import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  // ======================================================
  // 🌞 LIGHT THEME
  // ======================================================
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // ======================================================
    // 🔤 Typography
    // ======================================================
    fontFamily: AppTypography.fontFamily,
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,

      headlineLarge: AppTypography.h1,
      headlineMedium: AppTypography.h2,
      headlineSmall: AppTypography.h3,

      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.bodySmall,

      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.label,
      labelSmall: AppTypography.labelSmall,
    ),

    // ======================================================
    // 🎨 Color Scheme (Material 3)
    // ======================================================
    colorScheme: AppColors.lightScheme,
    scaffoldBackgroundColor: AppColors.background,

    // ======================================================
    // 🧾 Inputs (TextField, Form)
    // ======================================================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputPadding,
        vertical: AppSpacing.sm,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.inputFocusedBorder,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.inputErrorBorder),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.inputErrorBorder,
          width: 2,
        ),
      ),

      hintStyle: TextStyle(color: AppColors.inputHint),
      labelStyle: TextStyle(color: AppColors.textSecondary),
      errorStyle: AppTypography.error,
    ),

    // ======================================================
    // 🔘 Buttons
    // ======================================================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.buttonPrimaryText,
        textStyle: AppTypography.labelLarge,
        shape: RoundedRectangleBorder(
          // 🔧 CORREÇÃO: era borderRadiusMd (não existe)
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
        textStyle: AppTypography.labelLarge,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppTypography.label,
        foregroundColor: AppColors.primary,
      ),
    ),

    // ======================================================
    // 🪪 Cards
    // ======================================================
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
      ),
    ),

    // ======================================================
    // 🧭 AppBar / Navigation
    // ======================================================
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      toolbarHeight: AppSizes.appBarHeight,
      titleTextStyle: AppTypography.h3.copyWith(
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(
        size: AppSizes.appBarIconSize,
        color: AppColors.textPrimary,
      ),
    ),

    // ======================================================
    // 🧭 NavigationBar (Mobile / Tablet)
    // ======================================================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.card,
      indicatorColor: AppColors.primary.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.all(
        AppTypography.labelSmall,
      ),
    ),

    // ======================================================
    // 🧭 Drawer
    // ======================================================
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        // 🔧 CORREÇÃO: era borderRadiusLg (não existe)
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
    ),

    // ======================================================
    // 🖱️ Icons
    // ======================================================
    iconTheme: const IconThemeData(
      size: AppSizes.iconMD,
      color: AppColors.textSecondary,
    ),

    // ======================================================
    // 🧠 Focus / Accessibility
    // ======================================================
    focusColor: AppColors.focus,
    hoverColor: AppColors.primary.withOpacity(0.04),
    splashColor: AppColors.primary.withOpacity(0.08),
    highlightColor: Colors.transparent,

    // ======================================================
    // 🧱 Dividers
    // ======================================================
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: AppSpacing.md,
    ),
  );

  // ======================================================
  // 🌙 DARK THEME
  // ======================================================
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: AppColors.darkScheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    fontFamily: AppTypography.fontFamily,
    textTheme: const TextTheme(
      bodyMedium: AppTypography.body,
      headlineMedium: AppTypography.h2,
    ),

    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: AppTypography.h3.copyWith(
        color: AppColors.textPrimaryDark,
      ),
    ),

    iconTheme: const IconThemeData(
      size: AppSizes.iconMD,
      color: AppColors.textSecondaryDark,
    ),
  );
}
