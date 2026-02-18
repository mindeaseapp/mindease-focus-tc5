import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class UpdatePasswordStyles {
  // Título principal (Corrigido para h1)
  static TextStyle get title => AppTypography.h1.copyWith(
        color: AppColors.textPrimary,
        fontWeight: AppTypography.bold,
      );

  // Texto descritivo (Corrigido para body)
  static TextStyle get description => AppTypography.body.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // Padding padrão do card
  static const EdgeInsets cardPadding = EdgeInsets.all(AppSpacing.xl);

  // Dimensions
  static const double desktopContentWidth = AppSizes.maxContentWidth;

  // Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  // Loading
  static const double loadingIconSize = AppSizes.iconSM;
  static const double loadingStrokeWidth = AppSpacing.xxs;
  static const Color loadingColor = Colors.white;
}