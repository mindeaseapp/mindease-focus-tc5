import 'package:flutter/material.dart';
import 'features/routes.dart';
import 'shared/tokens/app_typography.dart';

void main() {
  runApp(const MindEaseApp());
}

class MindEaseApp extends StatelessWidget {
  const MindEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',

      theme: ThemeData(
        useMaterial3: true,

        // 🔤 FONTE GLOBAL DO APP
        fontFamily: AppTypography.fontFamily,

        // (opcional, mas profissional)
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLarge,
          displayMedium: AppTypography.displayMedium,
          displaySmall: AppTypography.displaySmall,
          headlineLarge: AppTypography.h1,
          headlineMedium: AppTypography.h2,
          headlineSmall: AppTypography.h3,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.body,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.label,
          labelSmall: AppTypography.labelSmall,
        ),
      ),

      // ✅ PRIMEIRA TELA
      initialRoute: AppRoutes.login,

      // ✅ MAPA DE ROTAS (Clean)
      routes: AppRoutes.routes,
    );
  }
}
