import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
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
    color: AppColors.textOnPrimary.withValues(alpha: AppOpacity.strong),
  );

  static const double cardPadding = AppSpacing.xl;

  // Dimensions
  static const double mobileBreakpoint = AppSizes.breakpointTablet;
  static const double desktopContentWidth = AppSizes.maxContentWidth;

  // Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  // Loading
  static const double loadingIconSize = AppSizes.iconXS + AppSpacing.sm;
  static const double loadingStrokeWidth = AppSpacing.xxs;
  static const Color loadingColor = Colors.white;
}
