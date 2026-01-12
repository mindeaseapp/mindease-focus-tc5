import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// AUTH
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_page.dart';

// APP
import 'package:mindease_focus/features/auth/presentation/pages/dashboard/dashboard_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';

// NOT FOUND
import 'package:mindease_focus/shared/pages/not_found/not_found_page.dart';
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String tasks = '/tasks';

  static const String notFound = '/not_found';

  static bool get isLoggedIn =>
      Supabase.instance.client.auth.currentUser != null;

  // ✅ defina quais rotas NÃO precisam de login
  static const Set<String> publicRoutes = {
    login,
    register,
    resetPassword,
    notFound,
  };

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        resetPassword: (_) => const ResetPasswordPage(),
        dashboard: (_) => const DashboardPage(),

        profile: (context) {
          final user = Supabase.instance.client.auth.currentUser;

          final name = user?.userMetadata?['name']?.toString() ??
              user?.email?.split('@').first ??
              'Usuário';

          final email = user?.email ?? 'sem-email@local';

          return ProfilePage(
            viewModel: ProfileViewModel.demo(
              name: name,
              email: email,
              onOpenPersonalInfo: () {},
            ),
          );
        },

        tasks: (_) => const TasksPage(),
        notFound: (_) => const NotFoundPage(),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;

    // 1) Se a rota existe no map:
    final builder = routes[name];
    if (builder != null) {
      final isPublic = publicRoutes.contains(name);
      if (!isPublic && !isLoggedIn) {
        // ✅ tentou acessar rota protegida sem login
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: const RouteSettings(name: login),
        );
      }

      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }

    // 2) Se NÃO existe: NotFound
    return MaterialPageRoute(
      builder: (_) => NotFoundPage(requestedRoute: name),
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
