import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class KanbanColumnStyles {
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Container hover
  static const double hoverBgAlpha = AppOpacity.disabled;
  static const double hoverBorderWidth = AppSpacing.xxs;
  static BorderRadius columnRadius() => BorderRadius.circular(AppSizes.cardBorderRadiusSm);
  static const EdgeInsets columnPadding = EdgeInsets.all(AppSpacing.sm);

  // Header
  static const EdgeInsets headerPadding = EdgeInsets.all(AppSpacing.md);
  static BorderRadius headerRadius() => BorderRadius.circular(AppSizes.cardBorderRadiusSm);
  static const double headerIconSize = AppSizes.iconSM;
  static const SizedBox headerGap8 = AppSpacing.hGapSm;

  static TextStyle headerTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleMedium ??
        AppTypography.titleMedium.copyWith(fontWeight: AppTypography.bold);

    return base.copyWith(
      fontWeight: AppTypography.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  // Counter
  static const EdgeInsets counterPadding =
      EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs);

  static BorderRadius counterRadius() => BorderRadius.circular(AppSizes.cardBorderRadiusSm);

  static Color counterBg(BuildContext context) {
    final theme = Theme.of(context);
    // No dark: mantém escuro (surface), no light: branco.
    return _isDark(context) ? theme.colorScheme.surface : Colors.white;
  }

  static TextStyle counterTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.labelLarge ??
        AppTypography.label.copyWith(fontWeight: AppTypography.bold);

    return base.copyWith(
      fontWeight: AppTypography.bold,
      color: theme.colorScheme.onSurface,
    );
  }

  // Spacing
  static const SizedBox gap8h = AppSpacing.gapSm;

  // Drag UI
  static const double dragFeedbackElevation = AppSizes.cardElevationLg;
  static const double dragFeedbackWidth = AppSizes.drawerWidth;
  static const double dragFeedbackOpacity = AppOpacity.strong + AppOpacity.soft;
  static const double childWhenDraggingOpacity = AppOpacity.disabled;

  static BorderRadius dragRadius() => BorderRadius.circular(AppSizes.cardBorderRadiusSm);

  static const EdgeInsets taskBottomPadding = EdgeInsets.only(bottom: AppSpacing.md - AppSpacing.xs);

  // Empty state
  static const EdgeInsets emptyPadding = EdgeInsets.all(AppSpacing.lg);
  static BorderRadius emptyRadius() => BorderRadius.circular(AppSizes.cardBorderRadiusSm);

  static const double emptyBorderWidth = 2;

  static Color emptyBorderColor(BuildContext context) =>
      Theme.of(context).dividerColor.withValues(alpha: AppOpacity.strong + AppOpacity.soft);

  static Color emptyBg(BuildContext context) {
    final theme = Theme.of(context);
    if (_isDark(context)) {
      return theme.colorScheme.surface.withValues(alpha: AppOpacity.strong);
    }
    return Colors.grey.shade50;
  }

  static const double emptyIconSize = AppSizes.iconXXL;

  static Color emptyIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: AppOpacity.disabled);

  static Color emptyTextColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: AppOpacity.strong);

  static const SizedBox emptyGap8 = AppSpacing.gapSm;
}
