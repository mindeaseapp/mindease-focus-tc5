import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // O 'select' escuta apenas a mudança na propriedade isAuthenticated
    final isAuthenticated = context.select<AuthController, bool>(
      (auth) => auth.isAuthenticated,
    );

    if (isAuthenticated) {
      return child;
    }

    // Se não estiver autenticado, retorna a página de Login.
    // Isso impede que a rota protegida seja renderizada.
    return const LoginPage();
  }
}