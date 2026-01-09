import 'package:flutter/material.dart';

// ==============================
// AUTH
// ==============================
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_page.dart';

// ==============================
// APP
// ==============================
import 'package:mindease_focus/features/auth/presentation/pages/dashboard/dashboard_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    resetPassword: (_) => const ResetPasswordPage(),
    dashboard: (_) => const DashboardPage(),

    // ✅ Profile dinâmico (somente leitura por enquanto)
    profile: (context) {
      final vm = ProfileViewModel.demo(
        name: 'Usuário MindEase',
        email: 'usuario@mindease.com',
        // ✅ sem onOpenPersonalInfo
      );

      return ProfilePage(viewModel: vm);
    },
  };
}
