import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/routes.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/shared/tokens/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MindEaseApp(),
    ),
  );
}

class MindEaseApp extends StatelessWidget {
  const MindEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.mode,

      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
