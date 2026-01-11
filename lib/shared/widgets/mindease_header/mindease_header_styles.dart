import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class MindEaseHeaderStyles {
  // ===== AppBar =====
  static const double elevation = 0;
  static const bool centerTitle = false;
  static const Color surfaceTintColor = Colors.transparent;

  static double toolbarHeight(BuildContext context) =>
      AppSizes.appBarHeightFor(context);

  static double preferredHeight = AppSizes.appBarHeight;

  static double titleSpacing = AppSpacing.md;

  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  // ===== Brand =====
  static const double brandLogoBox = AppSizes.iconXL;
  static const SizedBox brandGap = SizedBox(width: AppSpacing.sm);

  static Color brandIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static TextStyle brandTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return AppTypography.titleLarge.copyWith(
      color: theme.colorScheme.onSurface,
    );
  }

  // ===== Web title row =====
  static const SizedBox rightGap = SizedBox(width: AppSpacing.md);

  // ===== Overlay / Ink =====
  static BorderRadius inkRadius =
      BorderRadius.circular(AppSizes.cardBorderRadiusSm);

  static WidgetStateProperty<Color?> overlayColor(BuildContext context) {
    final theme = Theme.of(context);

    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return theme.colorScheme.primary.withValues(alpha: AppOpacity.pressed);
      }
      if (states.contains(WidgetState.hovered)) {
        return theme.colorScheme.primary.withValues(alpha: AppOpacity.hover);
      }
      if (states.contains(WidgetState.focused)) {
        return theme.colorScheme.primary.withValues(alpha: AppOpacity.focus);
      }
      return null;
    });
  }

  // ===== Web Nav Item =====
  static const BoxConstraints navItemConstraints = BoxConstraints(
    minHeight: AppSizes.minTapArea,
  );

  static const EdgeInsets navItemPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );

  static const double navIconSize = AppSizes.iconSM;
  static const SizedBox navLabelGap = SizedBox(width: AppSpacing.sm);

  static Color navBg(BuildContext context, {required bool selected}) {
    final theme = Theme.of(context);
    return selected
        ? theme.colorScheme.primary.withValues(alpha: AppOpacity.soft)
        : Colors.transparent;
  }

  static Color navFg(BuildContext context, {required bool selected}) {
    final theme = Theme.of(context);
    return selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
  }

  static TextStyle navTextStyle(BuildContext context, {required bool selected}) {
    final fg = navFg(context, selected: selected);
    final base = selected ? AppTypography.navItemActive : AppTypography.navItem;
    return base.copyWith(color: fg);
  }

  // ===== User menu =====
  static const EdgeInsets userPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );

  static const double userIconSize = AppSizes.iconMD;

  static Color userIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static TextStyle userLabelStyle(BuildContext context) {
    final theme = Theme.of(context);
    return AppTypography.navItem.copyWith(
      color: theme.colorScheme.onSurface,
    );
  }

  // ===== Mobile actions =====
  static const SizedBox mobileActionsGap = SizedBox(width: AppSpacing.sm);
}
