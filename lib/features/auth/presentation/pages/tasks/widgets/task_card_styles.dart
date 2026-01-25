import 'package:flutter/material.dart';

class TaskCardStyles {
  // Card
  static const double elevation = 2;
  static const double radius = 12;
  static const EdgeInsets padding = EdgeInsets.all(16);

  // Spacing
  static const SizedBox gap8 = SizedBox(width: 8);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox w4 = SizedBox(width: 4);

  // Icons
  static const double dragIconSize = 20;
  static const double deleteIconSize = 20;
  static const double timeIconSize = 14;

  static Color dragIconColor() => Colors.grey.shade400;
  static Color deleteColor() => Colors.red.shade400;
  static Color timeColor() => Colors.grey.shade600;
  static Color descColor() => Colors.grey.shade700;

  // Text
  static const TextStyle titleText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle descriptionText() => TextStyle(
        fontSize: 14,
        color: descColor(),
      );

  static TextStyle timeText() => TextStyle(
        fontSize: 12,
        color: timeColor(),
      );
}
