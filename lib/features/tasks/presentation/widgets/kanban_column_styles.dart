import 'package:flutter/material.dart';

class KanbanColumnStyles {
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Container hover
  static const double hoverBgAlpha = 0.30;
  static const double hoverBorderWidth = 2;
  static BorderRadius columnRadius() => BorderRadius.circular(12);
  static const EdgeInsets columnPadding = EdgeInsets.all(8);

  // Header
  static const EdgeInsets headerPadding = EdgeInsets.all(16);
  static BorderRadius headerRadius() => BorderRadius.circular(12);
  static const double headerIconSize = 20;
  static const SizedBox headerGap8 = SizedBox(width: 8);

  static TextStyle headerTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleMedium ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

    return base.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
  }

  // Counter
  static const EdgeInsets counterPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  static BorderRadius counterRadius() => BorderRadius.circular(12);

  static Color counterBg(BuildContext context) {
    final theme = Theme.of(context);
    // No dark: mantém escuro (surface), no light: branco.
    return _isDark(context) ? theme.colorScheme.surface : Colors.white;
  }

  static TextStyle counterTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

    return base.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
  }

  // Spacing
  static const SizedBox gap8h = SizedBox(height: 8);

  // Drag UI
  static const double dragFeedbackElevation = 6;
  static const double dragFeedbackWidth = 280;
  static const double dragFeedbackOpacity = 0.80;
  static const double childWhenDraggingOpacity = 0.30;

  static BorderRadius dragRadius() => BorderRadius.circular(12);

  static const EdgeInsets taskBottomPadding = EdgeInsets.only(bottom: 12);

  // Empty state
  static const EdgeInsets emptyPadding = EdgeInsets.all(24);
  static BorderRadius emptyRadius() => BorderRadius.circular(12);

  static const double emptyBorderWidth = 2;

  static Color emptyBorderColor(BuildContext context) =>
      Theme.of(context).dividerColor.withValues(alpha: 0.90);

  static Color emptyBg(BuildContext context) {
    final theme = Theme.of(context);
    if (_isDark(context)) {
      return theme.colorScheme.surface.withValues(alpha: 0.75);
    }
    return Colors.grey.shade50;
  }

  static const double emptyIconSize = 48;

  static Color emptyIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);

  static Color emptyTextColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70);

  static const SizedBox emptyGap8 = SizedBox(height: 8);
}
