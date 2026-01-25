import 'package:flutter/material.dart';

class KanbanColumnStyles {
  // Container hover
  static const double hoverBgAlpha = 0.3;
  static const double hoverBorderWidth = 2;
  static BorderRadius columnRadius() => BorderRadius.circular(12);
  static const EdgeInsets columnPadding = EdgeInsets.all(8);

  // Header
  static const EdgeInsets headerPadding = EdgeInsets.all(16);
  static BorderRadius headerRadius() => BorderRadius.circular(12);
  static const double headerIconSize = 20;
  static const SizedBox headerGap8 = SizedBox(width: 8);

  static const TextStyle headerTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Counter
  static const EdgeInsets counterPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static BorderRadius counterRadius() => BorderRadius.circular(12);
  static const Color counterBg = Colors.white;

  static const TextStyle counterText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Spacing
  static const SizedBox gap8h = SizedBox(height: 8);

  // Drag UI
  static const double dragFeedbackElevation = 6;
  static const double dragFeedbackWidth = 280;
  static const double dragFeedbackOpacity = 0.8;
  static const double childWhenDraggingOpacity = 0.3;

  static BorderRadius dragRadius() => BorderRadius.circular(12);

  static const EdgeInsets taskBottomPadding = EdgeInsets.only(bottom: 12);

  // Empty state
  static const EdgeInsets emptyPadding = EdgeInsets.all(24);
  static BorderRadius emptyRadius() => BorderRadius.circular(12);

  static const double emptyBorderWidth = 2;

  static Color emptyBorderColor() => Colors.grey.shade300;
  static Color emptyBg() => Colors.grey.shade50;

  static const double emptyIconSize = 48;
  static Color emptyIconColor() => Colors.grey.shade400;

  static Color emptyTextColor() => Colors.grey.shade600;

  static const SizedBox emptyGap8 = SizedBox(height: 8);
}
