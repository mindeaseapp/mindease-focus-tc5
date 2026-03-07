import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthController, bool>(
      (auth) => auth.isAuthenticated,
    );

    if (isAuthenticated) {
      return child;
    }

    return const LoginPage();
  }
}