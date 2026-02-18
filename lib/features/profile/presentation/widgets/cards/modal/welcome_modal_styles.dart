import 'package:flutter/material.dart';

class WelcomeModalStyles {
  static const EdgeInsets dialogInsetPadding = EdgeInsets.all(24);
  static const double dialogMaxWidth = 860;
  static const double dialogRadius = 20;

  static const EdgeInsets contentPadding = EdgeInsets.all(24);

  static const double headerIconBox = 44;
  static const double headerIconSize = 22;

  static const double cardGap = 16;
  static const double cardsBreakpoint = 720;

  static const EdgeInsets featureCardPadding = EdgeInsets.all(16);
  static const double featureCardRadius = 14;
  static const double featureCardBorderWidth = 1.2;

  static const EdgeInsets tipPadding = EdgeInsets.all(16);
  static const double tipRadius = 14;

  static const double ctaWidth = 220;
  static const double ctaHeight = 44;
  static const double ctaRadius = 12;

  static TextStyle? titleStyle(ThemeData theme) =>
      theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800);

  static TextStyle? subtitleStyle(ThemeData theme) =>
      theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);

  static TextStyle? featureTitleStyle(ThemeData theme) =>
      theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800);

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
        borderRadius: BorderRadius.circular(12),
      );

  static BoxDecoration tipDecoration(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: tipBorderRadius(),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      );

  static double featureCardWidth(double maxWidth) {
    final isNarrow = maxWidth < cardsBreakpoint;
    return isNarrow ? maxWidth : (maxWidth - cardGap) / 2;
  }
}
