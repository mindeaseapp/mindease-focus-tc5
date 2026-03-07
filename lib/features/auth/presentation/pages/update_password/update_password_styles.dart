import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class UpdatePasswordStyles {
  static TextStyle get title => AppTypography.h1.copyWith(
        color: AppColors.textPrimary,
        fontWeight: AppTypography.bold,
      );

  static TextStyle get description => AppTypography.body.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static const EdgeInsets cardPadding = EdgeInsets.all(AppSpacing.xl);

  static const double desktopContentWidth = AppSizes.maxContentWidth;

  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  static const double loadingIconSize = AppSizes.iconSM;
  static const double loadingStrokeWidth = AppSpacing.xxs;
  static const Color loadingColor = Colors.white;
}