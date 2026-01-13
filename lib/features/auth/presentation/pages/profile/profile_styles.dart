import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class ProfilePageStyles {
  // ===== Layout =====
  static EdgeInsets contentPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: AppSpacing.pagePadding(context),
      vertical: AppSpacing.xl,
    );
  }

  static const ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  static const TextAlign headerTextAlign = TextAlign.center;

  // ===== Text Styles (vem do Theme) =====
  static TextStyle? titleStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge;

  static TextStyle? subtitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;
}
