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

  // Header text
  static const TextStyle headerTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle headerSubtitle() =>
      TextStyle(fontSize: 14, color: Colors.grey.shade600);

  // Button
  static ButtonStyle addTaskButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      );

  // Desktop column padding
  static const EdgeInsets desktopColumnPadding =
      EdgeInsets.symmetric(horizontal: 12);

  // Desktop divider
  static double dividerWidth = 1;
  static double dividerThickness = 1;

  static Color dividerColor() => Colors.grey.shade300;

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

  static Color tipBg() => Colors.blue.shade50;
  static Color tipBorder() => Colors.blue.shade200;

  static Color tipIconColor() => Colors.blue.shade700;
  static Color tipTextColor() => Colors.blue.shade900;

  static const TextStyle tipTextStyleBase = TextStyle(fontSize: 13);

  static TextStyle tipTextStyle() =>
      tipTextStyleBase.copyWith(color: tipTextColor());

  // Snackbars
  static Color savingSnackBg() => Colors.blue.shade600;
  static Color deleteSnackBg() => Colors.red.shade600;

  static const Duration snackDuration = Duration(seconds: 1);

  // Columns definition (mesmo conteúdo)
  static final List<Map<String, dynamic>> columns = [
    {
      'id': TaskStatus.todo,
      'title': 'A Fazer',
      'icon': Icons.circle_outlined,
      'color': Colors.grey.shade600,
      'bgColor': Colors.grey.shade50,
    },
    {
      'id': TaskStatus.inProgress,
      'title': 'Em Andamento',
      'icon': Icons.pending_outlined,
      'color': Colors.blue.shade600,
      'bgColor': Colors.blue.shade50,
    },
    {
      'id': TaskStatus.done,
      'title': 'Concluído',
      'icon': Icons.check_circle_outline,
      'color': Colors.green.shade600,
      'bgColor': Colors.green.shade50,
    },
  ];
}
