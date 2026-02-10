import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

enum DashboardMetricKind { done, focus, productivity }
enum DashboardTaskPillKind { done, inProgress, pending }

class DashboardPageStyles {
  static const double maxWidth = 1200;
  static const double mobileBreakpoint = 600;
  static const double metricsWideBreakpoint = 900;

  static bool isMobileByWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static EdgeInsets contentPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: AppSpacing.pagePadding(context),
      vertical: AppSpacing.xl,
    );
  }

  static const ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  static BorderRadius cardRadius =
      BorderRadius.circular(AppSizes.cardBorderRadiusSm + 4);

  static ShapeBorder cardShape(BuildContext context, {bool highContrast = false}) {
    final theme = Theme.of(context);
    
    if (highContrast) {
      return RoundedRectangleBorder(
        borderRadius: cardRadius,
        side: BorderSide(
          color: theme.colorScheme.onSurface,
          width: 2,
        ),
      );
    }

    return RoundedRectangleBorder(
      borderRadius: cardRadius,
      side: BorderSide(
        color: theme.dividerColor.withValues(alpha: AppOpacity.soft),
        width: 1,
      ),
    );
  }

  static const double cardElevation = 0;

  static EdgeInsets cardPadding(BuildContext context) {
    return const EdgeInsets.all(AppSpacing.lg);
  }

  static Color? cardBg(BuildContext context, {bool highContrast = false}) {
    if (highContrast) {
      return Theme.of(context).colorScheme.surface;
    }
    return null; 
  }

  static Color pageBg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color sectionBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static TextStyle pageTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.headlineLarge ??
        const TextStyle(fontSize: 32, fontWeight: FontWeight.w800);
    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
      height: 1.05,
    );
  }

  static TextStyle pageSubtitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
      height: 1.4,
    );
  }

  static TextStyle metricTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    return base.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
    );
  }

  static TextStyle metricValueStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.headlineMedium ??
        const TextStyle(fontSize: 32, fontWeight: FontWeight.w800);
    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
      height: 1.05,
    );
  }

  static TextStyle metricSubtitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }

  static TextStyle sectionTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleMedium ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w800);
    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle sectionLinkStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
    return base.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.primary,
    );
  }

  static TextStyle taskTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleSmall ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle taskMetaStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle tipBodyStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
      height: 1.45,
    );
  }

  static Color metricAccent(DashboardMetricKind kind, BuildContext context, {bool highContrast = false}) {
    if (highContrast) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      if (isDark) {
        switch (kind) {
          case DashboardMetricKind.done:
            return Colors.greenAccent.shade200;
          case DashboardMetricKind.focus:
            return Colors.lightBlueAccent.shade200;
          case DashboardMetricKind.productivity:
            return Colors.purpleAccent.shade200;
        }
      } else {
        switch (kind) {
          case DashboardMetricKind.done:
            return Colors.green.shade900;
          case DashboardMetricKind.focus:
            return Colors.blue.shade900;
          case DashboardMetricKind.productivity:
            return Colors.purple.shade900;
        }
      }
    }

    switch (kind) {
      case DashboardMetricKind.done:
        return Colors.green.shade600;
      case DashboardMetricKind.focus:
        return Colors.blue.shade600;
      case DashboardMetricKind.productivity:
        return Colors.purple.shade600;
    }
  }

  static Color metricIconFg(BuildContext context, {bool highContrast = false}) {
    if (highContrast) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return isDark ? Colors.black : Colors.white;
    }
    return Colors.white;
  }

  static BorderRadius metricIconRadius() =>
      BorderRadius.circular(AppSizes.cardBorderRadiusSm);

  static const double metricIconBox = 34;

  static BorderRadius focusBannerRadius() => cardRadius;

  static Color focusBannerBg(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(alpha: 0.08);
  }

  static Color focusBannerBorder(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(alpha: 0.25);
  }

  static TextStyle focusBannerTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleMedium ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w900);
    return base.copyWith(
      fontWeight: FontWeight.w900,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle focusBannerSubtitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
      height: 1.35,
    );
  }

  static const double focusBannerIconSize = 22;

  static Color focusBannerIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static EdgeInsets focusBannerPadding(BuildContext context) =>
      const EdgeInsets.all(AppSpacing.lg);

  static EdgeInsets focusBannerButtonPadding() =>
      const EdgeInsets.symmetric(horizontal: 22, vertical: 16);

  static Color taskTileBg(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface.withValues(alpha: 0.55);
  }

  static BorderRadius taskTileRadius() =>
      BorderRadius.circular(AppSizes.cardBorderRadiusSm + 6);

  static EdgeInsets taskTilePadding() => const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      );

  static Color pillBg(DashboardTaskPillKind kind, {bool highContrast = false}) {
    if (highContrast) {
      return Colors.transparent;
    }
    switch (kind) {
      case DashboardTaskPillKind.done:
        return Colors.green.shade100;
      case DashboardTaskPillKind.inProgress:
        return Colors.blue.shade100;
      case DashboardTaskPillKind.pending:
        return Colors.grey.shade200;
    }
  }

  static Color pillFg(DashboardTaskPillKind kind, {bool highContrast = false}) {
    if (highContrast) {
      switch (kind) {
        case DashboardTaskPillKind.done:
          return Colors.green.shade900;
        case DashboardTaskPillKind.inProgress:
          return Colors.blue.shade900;
        case DashboardTaskPillKind.pending:
          return Colors.black; 
      }
    }
    switch (kind) {
      case DashboardTaskPillKind.done:
        return Colors.green.shade800;
      case DashboardTaskPillKind.inProgress:
        return Colors.blue.shade800;
      case DashboardTaskPillKind.pending:
        return Colors.grey.shade800;
    }
  }

  static TextStyle pillTextStyle(BuildContext context, DashboardTaskPillKind kind,
      {bool highContrast = false}) {
    final theme = Theme.of(context);
    final base = theme.textTheme.labelMedium ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w700);

    final color = highContrast
        ? theme.colorScheme.onSurface
        : pillFg(kind, highContrast: false);

    return base.copyWith(
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static EdgeInsets pillPadding() =>
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

  static BorderRadius pillRadius() => BorderRadius.circular(999);
  
  static Border? pillBorder(BuildContext context, {bool highContrast = false}) {
    if (!highContrast) return null;
    return Border.all(
      color: Theme.of(context).colorScheme.onSurface,
      width: 2,
    );
  }

  static Color tipBg(BuildContext context, {bool highContrast = false}) {
    final theme = Theme.of(context);
    
    if (highContrast) {
      return theme.colorScheme.surface;
    }

    final base = theme.colorScheme.surface;
    final tint = theme.colorScheme.secondary;

    final alpha = theme.brightness == Brightness.dark ? 0.18 : 0.08;
    return Color.alphaBlend(tint.withValues(alpha: alpha), base);
  }

  static Color tipBorder(BuildContext context, {bool highContrast = false}) {
    final theme = Theme.of(context);
    
    if (highContrast) {
      return theme.colorScheme.onSurface;
    }

    final tint = theme.colorScheme.secondary;
    final alpha = theme.brightness == Brightness.dark ? 0.40 : 0.25;
    return tint.withValues(alpha: alpha);
  }

  static TextStyle tipTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleMedium ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w900);
    return base.copyWith(
      fontWeight: FontWeight.w900,
      color: theme.colorScheme.onSurface,
    );
  }

  static const double tipIconSize = 18;

  static const double tipBodyMaxWidthWide = 760;

  static double tipBodyMaxWidthFor(double availableWidth) {
    if (availableWidth >= metricsWideBreakpoint) return tipBodyMaxWidthWide;
    return availableWidth;
  }

  static Color fabBg(BuildContext context) => Colors.white;

  static Color fabFg(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85);
}
