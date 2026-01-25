import 'package:flutter/material.dart';

class MindEaseAccessibilityFabStyles {
  static const Offset popoverOffset = Offset(0, -10);
  static const double popoverMaxWidth = 320;

  static const double cardElevation = 6;
  static BorderRadius cardRadius() => BorderRadius.circular(14);

  static EdgeInsets cardPadding() => const EdgeInsets.all(14);

  static BorderRadius tileRadius() => BorderRadius.circular(12);
  static EdgeInsets tilePadding() =>
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12);

  static TextStyle titleFallback() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w800);

  static TextStyle tileTitleFallback() =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

  static TextStyle tileBodyFallback() =>
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  static Color fabBg(BuildContext context) => Theme.of(context).colorScheme.surface;

  static Color fabFg(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85);

  static Color tileBg(BuildContext context, {required bool enabled}) {
    final cs = Theme.of(context).colorScheme;
    return enabled
        ? cs.primary.withValues(alpha: 0.06)
        : cs.surfaceContainerHighest.withValues(alpha: 0.6);
  }

  static Color tileBorder(BuildContext context, {required bool enabled}) {
    final cs = Theme.of(context).colorScheme;
    return enabled ? cs.primary : Colors.transparent;
  }

  static Color tileTitleColor(BuildContext context, {required bool enabled}) {
    final cs = Theme.of(context).colorScheme;
    return enabled ? cs.primary : cs.onSurface;
  }

  static Color checkColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);

  static Color shadowColor() => Colors.black.withValues(alpha: 0.15);

  static TextStyle popoverTitle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleMedium ?? titleFallback();
    return base.copyWith(fontWeight: FontWeight.w800);
  }

  static TextStyle tileTitle(BuildContext context, {required bool enabled}) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleSmall ?? tileTitleFallback();
    return base.copyWith(
      fontWeight: FontWeight.w700,
      color: tileTitleColor(context, enabled: enabled),
    );
  }

  static TextStyle tileBody(BuildContext context, {double alpha = 0.7}) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall ?? tileBodyFallback();
    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: alpha),
    );
  }

  static double popoverMaxWidthFor(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return (w - 24).clamp(0, popoverMaxWidth).toDouble();
  }
}
