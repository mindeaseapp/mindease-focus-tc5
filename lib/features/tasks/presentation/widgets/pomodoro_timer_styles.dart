import 'package:flutter/material.dart';

class PomodoroTimerStyles {
  static const double maxWidth = 420;
  static const double cardRadius = 16;
  static const double padding = 18;

  static const double headerIconSize = 18;
  static const double headerIconTop = 2;
  static const double headerRightTop = 1;

  static const double circleSize = 210;

  static const double resetSize = 44;
  static const double resetIconSize = 22;

  static const double actionHeight = 44;
  static const double actionIconSize = 22;

  static const BoxConstraints segConstraints = BoxConstraints(
    minWidth: 48,
    minHeight: 28,
  );

  static const EdgeInsets segItemPadding = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets segOuterPadding = EdgeInsets.all(3);

  static BorderRadius segRadius() => BorderRadius.circular(12);
  static BorderRadius segItemRadius() => BorderRadius.circular(10);


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
    return _cs.primary.withValues(alpha: _isDark ? 0.28 : 0.30);
  }

  Color get outline =>
      _theme.dividerColor.withValues(alpha: _isDark ? 0.85 : 0.65);

  Color get iconMuted =>
      _cs.onSurface.withValues(alpha: _isDark ? 0.70 : 0.65);

  Color chipBg({bool highContrast = false}) {
    if (highContrast) {
      return _isDark ? Colors.black : Colors.white;
    }
    return _cs.surface.withValues(alpha: _isDark ? 0.92 : 0.95);
  }

  Color ringBg({bool highContrast = false}) {
    if (highContrast) {
      return _cs.onSurface.withValues(alpha: 0.1);
    }
    return _cs.onSurface.withValues(alpha: _isDark ? 0.22 : 0.18);
  }

  List<Color> gradientColors({bool highContrast = false}) {
    final surface = _cs.surface;

    if (highContrast) {
      return [surface, surface];
    }

    if (_isDark) {
      final top = Color.alphaBlend(primary.withValues(alpha: 0.10), surface);
      final bottom = Color.alphaBlend(_cs.secondary.withValues(alpha: 0.08), surface);
      return [top, bottom];
    }

    final top = Color.alphaBlend(primary.withValues(alpha: 0.08), surface);
    final bottom = Color.alphaBlend(_cs.secondary.withValues(alpha: 0.08), surface);
    return [top, bottom];
  }

  TextStyle get headerTitle {
    final base = _theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: _cs.onSurface.withValues(alpha: 0.90),
    );
  }

  TextStyle get timeText {
    final base = _theme.textTheme.displaySmall ??
        const TextStyle(fontSize: 44, fontWeight: FontWeight.w800);
    return base.copyWith(
      fontSize: 44,
      fontWeight: FontWeight.w900,
      color: _cs.onSurface,
      height: 1.05,
    );
  }

  TextStyle subLabel({bool highContrast = false}) {
    final base = _theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    return base.copyWith(
      fontSize: 12,
      color: highContrast
          ? _cs.onSurface
          : _cs.onSurface.withValues(alpha: 0.70),
      height: 1.2,
    );
  }

  TextStyle info({bool highContrast = false}) {
    final base = _theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    return base.copyWith(
      fontSize: 12,
      color: highContrast
          ? _cs.onSurface
          : _cs.onSurface.withValues(alpha: 0.70),
      height: 1.35,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle segText({required bool selected}) {
    final base = _theme.textTheme.labelMedium ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w700);

    return base.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: selected
          ? _cs.onPrimary
          : _cs.onSurface.withValues(alpha: 0.90),
    );
  }

  ButtonStyle actionButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: _cs.onPrimary,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        elevation: 0,
      );

  // Dialog
  static final ShapeBorder dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cardRadius),
  );

  TextStyle get dialogTitle =>
      _theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: _cs.onSurface,
      ) ??
      const TextStyle();

  TextStyle get dialogContent =>
      _theme.textTheme.bodyMedium?.copyWith(
        color: _cs.onSurface.withValues(alpha: 0.80),
      ) ??
      const TextStyle();
}
