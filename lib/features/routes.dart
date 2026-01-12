import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
import 'package:mindease_focus/features/auth/presentation/pages/dashboard/dashboard_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';

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

  // Protegidas
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String tasks = '/tasks';
  static const String updatePassword = '/update-password';

  // Not Found
  static const String notFound = '/not_found';

  /// Rotas registradas normalmente (MaterialApp.routes)
  static final Map<String, WidgetBuilder> routes = {
    // ✅ públicas
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    resetPassword: (_) => const ResetPasswordPage(),

    // ✅ pode ser pública ou protegida (depende da sua regra)
    // Se quiser proteger, deixa com AuthGuard. Se quiser pública, remova o AuthGuard.
    updatePassword: (_) => const UpdatePasswordPage(),

    // ✅ protegidas via AuthGuard (estratégia do Marcelo)
    dashboard: (_) => const AuthGuard(child: DashboardPage()),
    tasks: (_) => const AuthGuard(child: TasksPage()),

    profile: (context) {
      final user = Supabase.instance.client.auth.currentUser;

      final name = user?.userMetadata?['name']?.toString() ??
          user?.email?.split('@').first ??
          'Usuário';

      final email = user?.email ?? 'sem-email@local';

      final vm = ProfileViewModel.demo(
        name: name,
        email: email,
        onOpenPersonalInfo: () {},
      );

      return AuthGuard(
        child: ProfilePage(viewModel: vm),
      );
    },

    // ✅ rota fixa
    notFound: (_) => const NotFoundPage(),
  };

  /// ✅ Fallback principal:
  /// - Se a rota existir no map -> abre normal
  /// - Se NÃO existir -> abre NotFound (e "cai" em /not_found)
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;

    final builder = routes[name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (_) => NotFoundPage(requestedRoute: name),
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