import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class PomodoroTimerStyles {
  static const double maxWidth = AppSizes.maxContentWidth;
  static const double cardRadius = AppSizes.cardBorderRadius;
  static const double padding = AppSpacing.md + AppSpacing.xxs;

  static const double headerIconSize = 18;
  static const double headerIconTop = 2;
  static const double headerRightTop = 1;

  static const double circleSize = AppSpacing.massive + AppSpacing.massive + AppSpacing.xxxl;

  static const double resetSize = AppSizes.buttonHeightSm + AppSpacing.xs;
  static const double resetIconSize = AppSizes.iconMD - AppSpacing.xxs;

  static const double actionHeight = AppSizes.buttonHeightSm + AppSpacing.xs;
  static const double actionIconSize = AppSizes.iconMD - AppSpacing.xxs;

  static const BoxConstraints segConstraints = BoxConstraints(
    minWidth: AppSpacing.xxxl,
    minHeight: AppSpacing.lg + AppSpacing.xs,
  );

  static const EdgeInsets segItemPadding = EdgeInsets.symmetric(horizontal: AppSpacing.sm + AppSpacing.xxs);
  static const EdgeInsets segOuterPadding = EdgeInsets.all(AppSpacing.xxs + 1);

  static BorderRadius segRadius() => BorderRadius.circular(AppSizes.cardBorderRadiusSm);
  static BorderRadius segItemRadius() => BorderRadius.circular(AppSpacing.sm + AppSpacing.xxs);


  final BuildContext context;
  PomodoroTimerStyles(this.context);

  ThemeData get _theme => Theme.of(context);
  ColorScheme get _cs => _theme.colorScheme;

  bool get _isDark => _theme.brightness == Brightness.dark;

  Color get primary => _cs.primary;

  Color borderColor({bool highContrast = false}) {
    if (highContrast) {
      return _cs.onSurface;
    }
    return _cs.primary.withValues(alpha: _isDark ? AppOpacity.disabled : AppOpacity.strong);
  }

  Color get outline =>
      _theme.dividerColor.withValues(alpha: _isDark ? AppOpacity.strong + AppOpacity.soft : AppOpacity.strong);

  Color get iconMuted =>
      _cs.onSurface.withValues(alpha: _isDark ? AppOpacity.strong + AppOpacity.soft : AppOpacity.strong);

  Color chipBg({bool highContrast = false}) {
    if (highContrast) {
      return _isDark ? Colors.black : Colors.white;
    }
    return _cs.surface.withValues(alpha: _isDark ? 0.92 : 0.95);
  }

  Color ringBg({bool highContrast = false}) {
    if (highContrast) {
      return _cs.onSurface.withValues(alpha: AppOpacity.soft);
    }
    return _cs.onSurface.withValues(alpha: _isDark ? AppOpacity.medium : AppOpacity.soft + AppOpacity.subtle);
  }

  List<Color> gradientColors({bool highContrast = false}) {
    final surface = _cs.surface;

    if (highContrast) {
      return [surface, surface];
    }

    if (_isDark) {
      final top = Color.alphaBlend(primary.withValues(alpha: AppOpacity.soft), surface);
      final bottom = Color.alphaBlend(_cs.secondary.withValues(alpha: AppOpacity.soft - AppOpacity.subtle), surface);
      return [top, bottom];
    }

    final top = Color.alphaBlend(primary.withValues(alpha: AppOpacity.soft - AppOpacity.subtle), surface);
    final bottom = Color.alphaBlend(_cs.secondary.withValues(alpha: AppOpacity.soft - AppOpacity.subtle), surface);
    return [top, bottom];
  }

  TextStyle get headerTitle {
    final base = _theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
    return base.copyWith(
      fontWeight: AppTypography.bold,
      color: _cs.onSurface.withValues(alpha: AppOpacity.strong + AppOpacity.soft),
    );
  }

  TextStyle get timeText {
    final base = _theme.textTheme.displaySmall ??
        AppTypography.displayLarge.copyWith(fontWeight: AppTypography.bold);
    return base.copyWith(
      fontSize: AppTypography.displayLarge.fontSize,
      fontWeight: AppTypography.bold,
      color: _cs.onSurface,
      height: 1.05,
    );
  }

  TextStyle subLabel({bool highContrast = false}) {
    final base = _theme.textTheme.bodySmall ??
        AppTypography.labelSmall.copyWith(fontWeight: AppTypography.medium);
    return base.copyWith(
      fontSize: AppTypography.labelSmall.fontSize,
      color: highContrast
          ? _cs.onSurface
          : _cs.onSurface.withValues(alpha: AppOpacity.strong),
      height: 1.2,
    );
  }

  TextStyle info({bool highContrast = false}) {
    final base = _theme.textTheme.bodySmall ??
        AppTypography.labelSmall.copyWith(fontWeight: AppTypography.medium);
    return base.copyWith(
      fontSize: AppTypography.labelSmall.fontSize,
      color: highContrast
          ? _cs.onSurface
          : _cs.onSurface.withValues(alpha: AppOpacity.strong),
      height: 1.35,
      fontWeight: AppTypography.semiBold,
    );
  }

  TextStyle segText({required bool selected}) {
    final base = _theme.textTheme.labelMedium ??
        AppTypography.labelSmall.copyWith(fontWeight: AppTypography.bold);

    return base.copyWith(
      fontSize: AppTypography.labelSmall.fontSize,
      fontWeight: AppTypography.bold,
      color: selected
          ? _cs.onPrimary
          : _cs.onSurface.withValues(alpha: AppOpacity.strong + AppOpacity.soft),
    );
  }

  ButtonStyle actionButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: _cs.onPrimary,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + AppSpacing.xxs),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: AppTypography.bold,
        ),
        elevation: 0,
      );

  // Dialog
  static final ShapeBorder dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cardRadius),
  );

  TextStyle get dialogTitle =>
      _theme.textTheme.titleMedium?.copyWith(
        fontWeight: AppTypography.bold,
        color: _cs.onSurface,
      ) ??
      const TextStyle();

  TextStyle get dialogContent =>
      _theme.textTheme.bodyMedium?.copyWith(
        color: _cs.onSurface.withValues(alpha: AppOpacity.strong),
      ) ??
      const TextStyle();
}
