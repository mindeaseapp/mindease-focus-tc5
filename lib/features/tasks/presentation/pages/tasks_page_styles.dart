import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class TasksPageStyles {
  // TabBar
  static const int tabCount = 2;
  static const double tabIndicatorWeight = 3;
  static const double tabIconSize = AppSizes.iconMD;
  
  static Color tabBarBackgroundColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white;
  }

  static Color tabSelectedItemColor(BuildContext context, {bool isDarkMode = false}) {
     if (isDarkMode) return Colors.white;
     return Theme.of(context).colorScheme.primary;
  }

  static Color tabUnselectedItemColor(BuildContext context, {bool isDarkMode = false}) {
     if (isDarkMode) return Colors.white60;
     return Theme.of(context).colorScheme.onSurface.withValues(alpha: AppOpacity.strong);
  }

  // Pomodoro Tab
  static const EdgeInsets pomodoroPadding = EdgeInsets.all(AppSpacing.lg);
  static const double pomodoroMaxWidth = AppSizes.breakpointMobile;
  static const double pomodoroTitleSpacing = AppSpacing.lg;

  static final TextStyle pomodoroTitleText = AppTypography.titleMedium.copyWith(
    color: AppColors.textSecondary,
    fontWeight: AppTypography.semiBold,
  );

  // Kanban Tab
  static const double mobileBreakpoint = AppSizes.breakpointMobile;

  static EdgeInsets kanbanPadding({required bool isMobile}) =>
      EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.xl);

  static Color kanbanBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.transparent
        : Colors.grey.shade50;
  }

  // Error State
  static const EdgeInsets errorPadding = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets errorMargin = EdgeInsets.only(bottom: AppSpacing.md);
  static const double errorIconGap = AppSpacing.sm;

  static BorderRadius errorRadius() => BorderRadius.circular(AppSpacing.radiusSm);

  static Color errorBackground() => Colors.red.shade100;

  static const Icon errorIcon = Icon(Icons.error_outline, color: Colors.red);

  static const TextStyle errorText = TextStyle(color: Colors.red);
}
