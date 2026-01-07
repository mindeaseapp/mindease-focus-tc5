import 'package:flutter/material.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C63FF),
    ),

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
  );
}
