import 'package:flutter/material.dart';

// ==============================
// AUTH
// ==============================
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/update_password/update_password_page.dart';

// ==============================
// APP
// ==============================
import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mindease_focus/features/profile/presentation/pages/profile_page.dart';
import 'package:mindease_focus/features/tasks/presentation/pages/tasks_page.dart';

// ==============================
// SHARED
// ==============================
import 'package:mindease_focus/shared/auth/auth_guard.dart';

// ==============================
// NOT FOUND
// ==============================
import 'package:mindease_focus/shared/pages/not_found/not_found_page.dart';

class AppRoutes {
  // Públicas
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String updatePassword = '/update-password';

  // Protegidas
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String tasks = '/tasks';

  // Not Found
  static const String notFound = '/not_found';

  static final Map<String, WidgetBuilder> routes = {
    // ✅ públicas
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    resetPassword: (_) => const ResetPasswordPage(),
    updatePassword: (_) => const UpdatePasswordPage(),

    // ✅ protegidas
    dashboard: (_) => const AuthGuard(child: DashboardPage()),
    tasks: (_) => const AuthGuard(child: TasksPage()),

    // ✅ Profile dinâmico + protegido
    profile: (_) => const AuthGuard(child: ProfilePage()),

    // ✅ rota fixa
    notFound: (_) => const NotFoundPage(),
  };

  /// ✅ Fallback principal:
  /// - Se existir no map -> abre
  /// - Se não -> NotFound
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final builder = routes[routeName];

    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (_) => NotFoundPage(requestedRoute: routeName),
      settings: const RouteSettings(name: notFound),
    );
  }

  /// ✅ Backup extra
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => NotFoundPage(requestedRoute: settings.name),
      settings: const RouteSettings(name: notFound),
    );
  }
}
