import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
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
    colorScheme: AppColors.lightScheme,
    scaffoldBackgroundColor: AppColors.background,
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
        borderSide:
            const BorderSide(color: AppColors.inputFocusedBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.inputErrorBorder),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide:
            const BorderSide(color: AppColors.inputErrorBorder, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.inputHint),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      errorStyle: AppTypography.error,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: AppSpacing.md,
    ),
    focusColor: AppColors.focus,
    hoverColor: AppColors.primary.withValues(alpha: AppOpacity.medium),
    splashColor: AppColors.primary.withValues(alpha: AppOpacity.pressed),
    highlightColor: Colors.transparent,
  );

  // ✅ DARK COMPLETO
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkScheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,
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
    ).apply(
      bodyColor: AppColors.textPrimaryDark,
      displayColor: AppColors.textPrimaryDark,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackgroundDark,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputPadding,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
      labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
      helperStyle: const TextStyle(color: AppColors.textSecondaryDark),
      errorStyle: AppTypography.error,
    ),

    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: AppSpacing.md,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.textOnPrimary;
        }
        return AppColors.textSecondaryDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight.withValues(alpha: 0.55);
        }
        return AppColors.borderDark;
      }),
    ),

    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.never,
    ),

    iconTheme: const IconThemeData(
      size: AppSizes.iconMD,
      color: AppColors.textSecondaryDark,
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textPrimaryDark),
      iconTheme: const IconThemeData(
        size: AppSizes.appBarIconSize,
        color: AppColors.textPrimaryDark,
      ),
    ),

    focusColor: AppColors.focus,
    hoverColor: AppColors.primaryLight.withValues(alpha: AppOpacity.medium),
    splashColor: AppColors.primaryLight.withValues(alpha: AppOpacity.pressed),
    highlightColor: Colors.transparent,
  );

  // ======================================================
  // ✅ HIGH CONTRAST (Hacka - Acessibilidade Cognitiva)
  // ======================================================

  static ThemeData get lightHighContrast => _applyHighContrast(light);
  static ThemeData get darkHighContrast => _applyHighContrast(dark);

  /// ✅ reforço de contraste sem depender de token extra
  static ThemeData _applyHighContrast(ThemeData base) {
    final isDark = base.brightness == Brightness.dark;

    // ✅ fallback garantido (não depende de AppColors.borderStrong)
    final strongBorderColor = isDark ? Colors.white : Colors.black;

    final strongBorder = BorderSide(
      color: strongBorderColor,
      width: 1.8,
    );

    final focusedBorder = BorderSide(
      color: base.colorScheme.primary,
      width: 3.0,
    );

    final textColor = isDark ? Colors.white : Colors.black;

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),

      dividerTheme: base.dividerTheme.copyWith(
        thickness: 1.6,
        color: strongBorderColor,
      ),

      cardTheme: base.cardTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          side: strongBorder,
        ),
      ),

      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: strongBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: strongBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputBorderRadius),
          borderSide: focusedBorder,
        ),
      ),

      // ✅ deixa o switch com contorno mais evidente (contraste perceptível)
      switchTheme: base.switchTheme.copyWith(
        trackOutlineColor: WidgetStatePropertyAll(strongBorderColor),
        trackOutlineWidth: const WidgetStatePropertyAll(1.6),
      ),
    );
  }
}
