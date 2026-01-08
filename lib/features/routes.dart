import 'package:flutter/material.dart';

// ==============================
// AUTH
// ==============================
import 'package:mindease_focus/features/auth/login/presentation/login_page.dart';
import 'package:mindease_focus/features/auth/register/presentation/register_page.dart';
import 'package:mindease_focus/features/auth/reset_password/presentation/reset_password_page.dart';

// ==============================
// APP
// ==============================
import 'package:mindease_focus/features/dashboard/presentation/dashboard_page.dart';
import 'package:mindease_focus/features/profile/presentation/profile_page.dart';

class AppRoutes {
  // ======================================================
  // 🔹 NOMES DAS ROTAS
  // ======================================================
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  // ======================================================
  // 🔹 MAPA DE ROTAS
  // ======================================================
  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    resetPassword: (_) => const ResetPasswordPage(),
    dashboard: (_) => const DashboardPage(),
    profile: (_) => const ProfilePage(),
  };
}
