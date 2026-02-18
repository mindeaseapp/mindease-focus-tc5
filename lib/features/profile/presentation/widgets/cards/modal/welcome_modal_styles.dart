import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class WelcomeModalStyles {
  static const EdgeInsets dialogInsetPadding = EdgeInsets.all(AppSpacing.lg);
  static const double dialogMaxWidth = AppSizes.maxProfileWidth;
  static const double dialogRadius = AppSizes.dialogBorderRadius;

  static const EdgeInsets contentPadding = EdgeInsets.all(AppSpacing.lg);

  static const double headerIconBox = AppSizes.avatarMD + AppSpacing.xs;
  static const double headerIconSize = AppSizes.appBarIconSize - AppSpacing.xxs;

  static const double cardGap = AppSpacing.md;
  static const double cardsBreakpoint = AppSizes.breakpointTablet;

  static const EdgeInsets featureCardPadding = EdgeInsets.all(AppSpacing.md);
  static const double featureCardRadius = AppSizes.cardBorderRadiusSm;
  static const double featureCardBorderWidth = 1.0;

  static const EdgeInsets tipPadding = EdgeInsets.all(AppSpacing.md);
  static const double tipRadius = AppSizes.cardBorderRadiusSm;

  static const double ctaWidth = AppSpacing.massive * 2.5;
  static const double ctaHeight = AppSizes.buttonHeight;
  static const double ctaRadius = AppSizes.cardBorderRadiusSm;

  static TextStyle? titleStyle(ThemeData theme) =>
      theme.textTheme.titleLarge?.copyWith(fontWeight: AppTypography.bold);

  static TextStyle? subtitleStyle(ThemeData theme) =>
      theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);

  static TextStyle? featureTitleStyle(ThemeData theme) =>
      theme.textTheme.titleMedium?.copyWith(fontWeight: AppTypography.bold);

  static TextStyle? featureDescStyle(ThemeData theme) =>
      theme.textTheme.bodySmall?.copyWith(height: 1.25);

  static TextStyle? tipTextStyle(ThemeData theme) =>
      theme.textTheme.bodyMedium?.copyWith(height: 1.35);

  static ShapeBorder dialogShape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(dialogRadius));

  static BorderRadius featureCardBorderRadius() =>
      BorderRadius.circular(featureCardRadius);

  static BorderRadius tipBorderRadius() => BorderRadius.circular(tipRadius);

  static RoundedRectangleBorder ctaShape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(ctaRadius));

  static BoxDecoration headerIconDecoration(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadiusSm),
      );

  static BoxDecoration tipDecoration(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: AppOpacity.strong),
        borderRadius: tipBorderRadius(),
        border: Border.all(color: theme.dividerColor.withValues(alpha: AppOpacity.strong)),
      );

  static double featureCardWidth(double maxWidth) {
    final isNarrow = maxWidth < cardsBreakpoint;
    return isNarrow ? maxWidth : (maxWidth - cardGap) / 2;
  }
}
