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

// ✅ CRIE/IMPORTE a página de tasks
import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  // ✅ NOVO
  static const String tasks = '/tasks';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        resetPassword: (_) => const ResetPasswordPage(),
        dashboard: (_) => const DashboardPage(),

        // ✅ ProfilePage precisa do viewModel, então a rota cria ele aqui:
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
              onOpenPersonalInfo: () {
                // opcional: navegue ou abra modal
                // debugPrint('Abrir dados pessoais');
              },
            ),
          );
        },

        // ✅ NOVO: rota /tasks registrada
        tasks: (_) => const TasksPage(),
      };
}
