import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

class KanbanBoardStyles {
  // Breakpoints
  static const double headerMobileBreakpoint = 600;
  static const double columnsMobileBreakpoint = 900;

  // Spacing
  static const SizedBox gap24 = SizedBox(height: 24);
  static const SizedBox gap16 = SizedBox(height: 16);
  static const SizedBox gap12w = SizedBox(width: 12);
  static const SizedBox gap4h = SizedBox(height: 4);

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Tinta a surface com uma cor (mantém escuro no dark)
  static Color _tintedSurface(
    BuildContext context, {
    required Color tint,
    double alpha = 0.12,
  }) {
    final theme = Theme.of(context);
    return Color.alphaBlend(
      tint.withValues(alpha: alpha),
      theme.colorScheme.surface,
    );
  }

  // Header text
  static TextStyle headerTitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.headlineSmall ??
        const TextStyle(fontSize: 24, fontWeight: FontWeight.w800);

    return base.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurface,
      height: 1.1,
    );
  }

  static TextStyle headerSubtitleStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

    return base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
      height: 1.35,
    );
  }

  // Button
  static ButtonStyle addTaskButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 0,
      shape: const StadiumBorder(),
    );
  }

  // Desktop column padding
  static const EdgeInsets desktopColumnPadding =
      EdgeInsets.symmetric(horizontal: 12);

  // Desktop divider
  static double dividerWidth = 1;
  static double dividerThickness = 1;

  static Color dividerColor(BuildContext context) =>
      Theme.of(context).dividerColor;

  static const double dividerIndent = 16;
  static const double dividerEndIndent = 16;

  // Mobile column
  static const EdgeInsets mobileColumnBottomPadding =
      EdgeInsets.only(bottom: 16);

  static const double mobileColumnHeight = 300;

  // Tip box
  static const EdgeInsets tipPadding = EdgeInsets.all(16);
  static const EdgeInsets tipMargin = EdgeInsets.only(top: 8);

  static BorderRadius tipRadius() => BorderRadius.circular(12);

  static Color tipBg(BuildContext context) {
    final theme = Theme.of(context);
    if (_isDark(context)) {
      return _tintedSurface(context, tint: theme.colorScheme.primary, alpha: 0.10);
    }
    return theme.colorScheme.primary.withValues(alpha: 0.08);
  }

  static Color tipBorder(BuildContext context) {
    final theme = Theme.of(context);
    if (_isDark(context)) {
      return theme.colorScheme.primary.withValues(alpha: 0.35);
    }
    return theme.colorScheme.primary.withValues(alpha: 0.25);
  }

  static Color tipIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color tipTextColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85);

  static TextStyle tipTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w500);

    return base.copyWith(
      color: tipTextColor(context),
      height: 1.35,
      fontWeight: FontWeight.w600,
    );
  }

  // Snackbars
  static const Duration snackDuration = Duration(seconds: 1);

  static Color savingSnackBg(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color deleteSnackBg(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  /// ✅ Colunas com bg responsivo ao tema
  static List<Map<String, dynamic>> columns(BuildContext context) {
    final theme = Theme.of(context);
    final dark = _isDark(context);

    final todoAccent = dark ? Colors.grey.shade300 : Colors.grey.shade600;
    final inProgressAccent = dark ? theme.colorScheme.primary : Colors.blue.shade600;
    final doneAccent = dark ? Colors.green.shade400 : Colors.green.shade600;

    final todoBg = dark
        ? _tintedSurface(context, tint: Colors.white, alpha: 0.05)
        : Colors.grey.shade50;

    final inProgressBg = dark
        ? _tintedSurface(context, tint: inProgressAccent, alpha: 0.12)
        : Colors.blue.shade50;

    final doneBg = dark
        ? _tintedSurface(context, tint: doneAccent, alpha: 0.12)
        : Colors.green.shade50;

    return [
      {
        'id': TaskStatus.todo,
        'title': 'A Fazer',
        'icon': Icons.circle_outlined,
        'color': todoAccent,
        'bgColor': todoBg,
      },
      {
        'id': TaskStatus.inProgress,
        'title': 'Em Andamento',
        'icon': Icons.pending_outlined,
        'color': inProgressAccent,
        'bgColor': inProgressBg,
      },
      {
        'id': TaskStatus.done,
        'title': 'Concluído',
        'icon': Icons.check_circle_outline,
        'color': doneAccent,
        'bgColor': doneBg,
      },
    ];
  }
}
