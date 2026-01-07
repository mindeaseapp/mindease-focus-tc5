import 'package:flutter/material.dart';
import 'features/routes.dart';

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
      theme: ThemeData(useMaterial3: true),

      // ✅ PRIMEIRA TELA
      initialRoute: AppRoutes.login,

      // ✅ MAPA DE ROTAS (Clean)
      routes: AppRoutes.routes,
    );
  }
}
