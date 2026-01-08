import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class ResetPasswordStyles {
  // Use 'static const' apenas para o que for puro (sem copyWith)
  static const TextStyle title = AppTypography.h2;

  // Use 'static final' para o que usa copyWith ou withValues
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

  // ✅ CORREÇÃO: Garante que o padding seja uma constante absoluta
  static const double cardPadding = AppSpacing.cardPadding;
}