import 'package:flutter/material.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class CognitivePanelStyles {
  // Factors
  static double spacingFactor(ElementSpacing s) {
    switch (s) {
      case ElementSpacing.low:
        return 0.90;
      case ElementSpacing.medium:
        return 1.00;
      case ElementSpacing.high:
        return 1.20;
    }
  }

  static double fontFactor(FontSizePreference f) {
    switch (f) {
      case FontSizePreference.small:
        return 0.92;
      case FontSizePreference.normal:
        return 1.00;
      case FontSizePreference.large:
        return 1.15;
    }
  }

  // Spacing
  static Widget vGap(double base, double factor) => SizedBox(height: base * factor);

  static const double fieldLabelSpacing = AppSpacing.xs;
  static const double sectionSpacing = AppSpacing.md;

  // Typography
  static TextStyle? fieldLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  static TextStyle? sliderLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  static TextStyle? sliderValueStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;

  // Slider
  static const BoxConstraints sliderConstraints =
      BoxConstraints(minHeight: AppSizes.minTapArea);
}
