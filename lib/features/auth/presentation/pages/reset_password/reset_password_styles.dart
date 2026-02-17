import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class ResetPasswordStyles {
  static const TextStyle title = AppTypography.h2;

  static final TextStyle brand = AppTypography.h1.copyWith(
    color: AppColors.textOnPrimary,
  );

  static final TextStyle subtitle = AppTypography.displaySmall.copyWith(
    color: AppColors.textOnPrimary,
  );

  static final TextStyle description = AppTypography.body.copyWith(
    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
  );

  static final TextStyle helper = AppTypography.bodySmall.copyWith(
    color: AppColors.textSecondary,
  );

  static const double cardPadding = AppSpacing.cardPadding;

  // Dimensions
  static const double mobileBreakpoint = 768; // Consistent with other auth pages if needed, or use AppSizes
  static const double desktopContentWidth = 420;

  // Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  // Loading
  static const double loadingIconSize = 20;
  static const double loadingStrokeWidth = 2;
  static const Color loadingColor = Colors.white;
}