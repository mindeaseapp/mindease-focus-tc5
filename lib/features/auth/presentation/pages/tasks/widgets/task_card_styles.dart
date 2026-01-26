import 'package:flutter/material.dart';

class TaskCardStyles {
  static const double elevation = 2;
  static const double radius = 12;
  static const EdgeInsets padding = EdgeInsets.all(16);

  static const SizedBox gap8 = SizedBox(width: 8);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox w4 = SizedBox(width: 4);

  static const double dragIconSize = 20;
  static const double editIconSize = 20;
  static const double deleteIconSize = 20;
  static const double timeIconSize = 14;

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
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w800);

    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
    );
  }

  static TextStyle descriptionText(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

    return base.copyWith(
      color: descColor(context),
      height: 1.35,
    );
  }

  static TextStyle timeText(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

    return base.copyWith(
      color: timeColor(context),
      fontWeight: FontWeight.w600,
    );
  }
}
