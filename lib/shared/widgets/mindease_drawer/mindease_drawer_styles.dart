import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class MindEaseDrawerStyles {
  // ===== Drawer =====
  static double drawerWidth = AppSizes.drawerWidth;

  // ===== Topo (header do drawer) =====
  static const EdgeInsets topPadding = EdgeInsets.fromLTRB(
    AppSpacing.md,
    AppSpacing.md,
    AppSpacing.sm,
    AppSpacing.sm,
  );

  static const double logoBox = AppSizes.iconXL;

  static TextStyle brandTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return AppTypography.titleLarge.copyWith(
      color: theme.colorScheme.onSurface,
    );
  }

  static Color brandIconColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary;
  }

  // ===== Dividers =====
  static Color dividerColor(BuildContext context) =>
      Theme.of(context).dividerColor;

  // ===== "Sair" =====
  static const EdgeInsets logoutPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );

  static TextStyle logoutTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return AppTypography.navItem.copyWith(
      color: theme.colorScheme.error,
    );
  }

  // ===== Itens =====
  static const EdgeInsets itemOuterPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );

  static BorderRadius itemRadius =
      BorderRadius.circular(AppSizes.cardBorderRadiusSm);

  static const BoxConstraints itemConstraints = BoxConstraints(
    minHeight: AppSizes.minTapArea,
  );

  static const EdgeInsets itemInnerPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );

  static const double itemIconSize = AppSizes.iconSM;

  static Color itemBg(BuildContext context, {required bool selected}) {
    final theme = Theme.of(context);
    return selected
        ? theme.colorScheme.primary.withValues(alpha: AppOpacity.soft)
        : Colors.transparent;
  }

  static Color itemFg(BuildContext context, {required bool selected}) {
    final theme = Theme.of(context);
    return selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
  }

  static TextStyle itemTextStyle(BuildContext context, {required bool selected}) {
    final base = selected ? AppTypography.navItemActive : AppTypography.navItem;
    final fg = itemFg(context, selected: selected);
    return base.copyWith(color: fg);
  }
}
