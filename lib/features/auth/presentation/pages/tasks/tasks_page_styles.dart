import 'package:flutter/material.dart';

class TasksPageStyles {
  static const int tabCount = 2;
  static const double tabIndicatorWeight = 3;

  static const EdgeInsets pomodoroPadding = EdgeInsets.all(24);
  static const double pomodoroMaxWidth = 600;

  static const TextStyle pomodoroTitleText = TextStyle(
    fontSize: 18,
    color: Colors.grey,
  );

  static const double mobileBreakpoint = 600;

  static EdgeInsets kanbanPadding({required bool isMobile}) =>
      EdgeInsets.all(isMobile ? 12 : 24);

  static Color kanbanBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.transparent
        : Colors.grey.shade50;
  }

  static const EdgeInsets errorPadding = EdgeInsets.all(12);
  static const EdgeInsets errorMargin = EdgeInsets.only(bottom: 16);

  static BorderRadius errorRadius() => BorderRadius.circular(8);

  static Color errorBackground() => Colors.red.shade100;

  static const Icon errorIcon = Icon(Icons.error_outline, color: Colors.red);

  static const TextStyle errorText = TextStyle(color: Colors.red);

  static Color tabBarBackgroundColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white;
  }
}
