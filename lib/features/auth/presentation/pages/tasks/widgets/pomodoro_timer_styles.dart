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

  // Colors
  static Color borderColor(BuildContext context) => Colors.blue.shade200;

  static List<Color> gradientColors() => [
        Colors.blue.shade50,
        Colors.purple.shade50,
      ];

  static Color primary() => Colors.blue.shade600;

  static Color chipBg() => Colors.white.withValues(alpha: 0.95);

  static Color ringBg() => Colors.grey.shade300;

  static Color infoColor() => Colors.grey.shade700;

  static Color subLabelColor() => Colors.grey.shade600;

  // Text styles
  static const TextStyle headerTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static const TextStyle timeText = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: Colors.black87,
  );

  static TextStyle subLabel() => TextStyle(
        fontSize: 12,
        color: subLabelColor(),
      );

  static TextStyle info() => TextStyle(
        fontSize: 12,
        color: infoColor(),
      );

  // Segmented control
  static const BoxConstraints segConstraints = BoxConstraints(
    minWidth: 48,
    minHeight: 28,
  );

  static const EdgeInsets segItemPadding = EdgeInsets.symmetric(horizontal: 10);

  static const EdgeInsets segOuterPadding = EdgeInsets.all(3);

  static BorderRadius segRadius() => BorderRadius.circular(12);

  static BorderRadius segItemRadius() => BorderRadius.circular(10);

  static TextStyle segText({required bool selected}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: selected ? Colors.white : Colors.black87,
      );

  // Buttons
  static ButtonStyle actionButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: primary(),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        elevation: 0,
      );
}
