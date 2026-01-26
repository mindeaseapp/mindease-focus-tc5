import 'package:flutter/material.dart';

class PomodoroTimerStyles {
  // Layout
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

  // Segmented control
  static const BoxConstraints segConstraints = BoxConstraints(
    minWidth: 48,
    minHeight: 28,
  );

  static const EdgeInsets segItemPadding = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets segOuterPadding = EdgeInsets.all(3);

  static BorderRadius segRadius() => BorderRadius.circular(12);
  static BorderRadius segItemRadius() => BorderRadius.circular(10);

  // ===== Instance (depende do Theme) =====

  final BuildContext context;
  PomodoroTimerStyles(this.context);

  ThemeData get _theme => Theme.of(context);
  ColorScheme get _cs => _theme.colorScheme;

  bool get _isDark => _theme.brightness == Brightness.dark;

  Color get primary => _cs.primary;

  /// Borda do card
  Color get borderColor =>
      _cs.primary.withValues(alpha: _isDark ? 0.28 : 0.30);

  /// Borda/outline padrão (substitui black12)
  Color get outline =>
      _theme.dividerColor.withValues(alpha: _isDark ? 0.85 : 0.65);

  /// Ícone “muted”
  Color get iconMuted =>
      _cs.onSurface.withValues(alpha: _isDark ? 0.70 : 0.65);

  /// Fundo do “chip” (reset/segmented) — escuro no dark
  Color get chipBg =>
      _cs.surface.withValues(alpha: _isDark ? 0.92 : 0.95);

  /// Fundo do anel
  Color get ringBg =>
      _cs.onSurface.withValues(alpha: _isDark ? 0.22 : 0.18);

  /// Gradiente do container do card:
  /// - Light: azul/roxo bem clarinho
  /// - Dark: surface escura com tint leve (sem clarear o card)
  List<Color> get gradientColors {
    final surface = _cs.surface;

    if (_isDark) {
      final top = Color.alphaBlend(primary.withValues(alpha: 0.10), surface);
      final bottom = Color.alphaBlend(_cs.secondary.withValues(alpha: 0.08), surface);
      return [top, bottom];
    }

    final top = Color.alphaBlend(primary.withValues(alpha: 0.08), surface);
    final bottom = Color.alphaBlend(_cs.secondary.withValues(alpha: 0.08), surface);
    return [top, bottom];
  }

  // Text styles
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

  TextStyle get subLabel {
    final base = _theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    return base.copyWith(
      fontSize: 12,
      color: _cs.onSurface.withValues(alpha: 0.70),
      height: 1.2,
    );
  }

  TextStyle get info {
    final base = _theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
    return base.copyWith(
      fontSize: 12,
      color: _cs.onSurface.withValues(alpha: 0.70),
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

  // Buttons
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
}
