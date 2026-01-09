import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child, 
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope não encontrado acima na árvore.');
    return scope!.notifier!;
  }
}
