import 'package:flutter/material.dart';

// auth
import 'auth/login/presentation/login_page.dart';

// app
import 'dashboard/presentation/dashboard_page.dart';
import 'profile/presentation/profile_page.dart';

class AppRoutes {
  // 🔹 nomes das rotas
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  // 🔹 mapa de rotas
  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    dashboard: (_) => const DashboardPage(),
    profile: (_) => const ProfilePage(),
  };
}
