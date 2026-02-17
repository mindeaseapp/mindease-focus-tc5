import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class RegisterStyles {
  static final TextStyle title = AppTypography.h2.copyWith(
    fontWeight: AppTypography.bold,
  );

  static final TextStyle brand = AppTypography.h1.copyWith(
    color: AppColors.textOnPrimary,
  );

  static final TextStyle subtitle = AppTypography.displaySmall.copyWith(
    color: AppColors.textOnPrimary,
  );

  static final TextStyle description = AppTypography.body.copyWith(
    // 🔧 substitui withOpacity (deprecated) sem alterar visual
    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
  );

  static const double cardPadding = AppSpacing.xl;

  // Dimensions
  static const double mobileBreakpoint = 768; // Or use AppSizes.breakpointTablet if appropriate, but 768 is specific here.
  static const double desktopContentWidth = 420; // AppSizes.maxContentWidth

  // Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  // Loading
  static const double loadingIconSize = 24;
  static const double loadingStrokeWidth = 2;
  static const Color loadingColor = Colors.white;
}
