import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class ProfilePageStyles {
  static EdgeInsets contentPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: AppSpacing.pagePadding(context),
      vertical: AppSpacing.xl,
    );
  }

  static const ScrollPhysics scrollPhysics = AlwaysScrollableScrollPhysics();

  static bool _isMobileByWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static TextAlign headerTextAlign(BuildContext context) =>
      _isMobileByWidth(context) ? TextAlign.start : TextAlign.center;

  static CrossAxisAlignment headerCrossAxisAlignment(BuildContext context) =>
      _isMobileByWidth(context)
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center;

  static Alignment headerAlignment(BuildContext context) =>
      _isMobileByWidth(context) ? Alignment.centerLeft : Alignment.center;

  static TextStyle? titleStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge;

  static TextStyle? subtitleStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;
}
