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
    color: AppColors.textOnPrimary.withOpacity(0.85),
  );

  static const double cardPadding = AppSpacing.xl;
}
