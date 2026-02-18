import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class TaskCardStyles {
  static const double elevation = AppSizes.cardElevationSm;
  static const double radius = AppSizes.cardBorderRadiusSm;
  static const EdgeInsets padding = EdgeInsets.all(AppSpacing.md);

  static ShapeBorder cardShape(BuildContext context, {bool highContrast = false}) {
    if (highContrast) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface,
          width: 2,
        ),
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.65),
        width: 1,
      ),
    );
  }

  static Color? cardBg(BuildContext context, {bool highContrast = false}) {
    if (highContrast) {
      return Theme.of(context).colorScheme.surface;
    }
    return null;
  }

  static const SizedBox gap8 = AppSpacing.hGapSm;
  static const SizedBox h8 = AppSpacing.gapSm;
  static const SizedBox h12 = SizedBox(height: AppSpacing.md - AppSpacing.xs);
  static const SizedBox w4 = SizedBox(width: AppSpacing.xs);

  static const double dragIconSize = AppSizes.iconSM;
  static const double editIconSize = AppSizes.iconSM;
  static const double deleteIconSize = AppSizes.iconSM;
  static double get timeIconSize => AppTypography.bodySmall.fontSize ?? 14;

  static Color dragIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);

  static Color editColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.85);

  static Color deleteColor(BuildContext context) =>
      Theme.of(context).colorScheme.error.withValues(alpha: 0.85);

  static Color timeColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60);

  static Color descColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75);

  static TextStyle titleText(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleSmall ??
        AppTypography.titleMedium.copyWith(fontWeight: AppTypography.bold);
 
    return base.copyWith(
      fontWeight: AppTypography.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle descriptionText(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium ??
        AppTypography.bodySmall.copyWith(fontWeight: AppTypography.regular);

    return base.copyWith(
      color: descColor(context),
      height: 1.35,
    );
  }

  static TextStyle timeText(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall ??
        AppTypography.labelSmall.copyWith(fontWeight: AppTypography.semiBold);

    return base.copyWith(
      color: timeColor(context),
      fontWeight: AppTypography.semiBold,
    );
  }
}
