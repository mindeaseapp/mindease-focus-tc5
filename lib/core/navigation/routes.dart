import 'package:flutter/material.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/update_password/update_password_page.dart';

import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mindease_focus/features/profile/presentation/pages/profile_page.dart';
import 'package:mindease_focus/features/tasks/presentation/pages/tasks_page.dart';

import 'package:mindease_focus/shared/auth/auth_guard.dart';

import 'package:mindease_focus/shared/pages/not_found/not_found_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String updatePassword = '/update-password';

  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String tasks = '/tasks';

  static const String notFound = '/not_found';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    resetPassword: (_) => const ResetPasswordPage(),
    updatePassword: (_) => const UpdatePasswordPage(),

    dashboard: (_) => const AuthGuard(child: DashboardPage()),
    tasks: (_) => const AuthGuard(child: TasksPage()),

    profile: (_) => const AuthGuard(child: ProfilePage()),

    notFound: (_) => const NotFoundPage(),
  };

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

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => NotFoundPage(requestedRoute: settings.name),
      settings: const RouteSettings(name: notFound),
    );
  }
}
