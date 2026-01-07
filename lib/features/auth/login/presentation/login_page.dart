import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

import 'login_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlexGrid(
        left: GradientPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MindEase', style: LoginStyles.brand),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Facilitando sua jornada acadêmica e profissional',
                style: LoginStyles.subtitle,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Uma plataforma pensada para pessoas neurodivergentes.',
                style: LoginStyles.description,
              ),
            ],
          ),
        ),
        right: Center(
          child: Card(
            child: SizedBox(
              width: AppSizes.maxContentWidth,
              child: Padding(
                padding: EdgeInsets.all(LoginStyles.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bem-vindo de volta',
                      style: LoginStyles.title,
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // 📧 EMAIL
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),

                    SizedBox(height: AppSpacing.md),

                    // 🔒 SENHA
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.login),
                        label: Text(
                          'Entrar',
                          style: LoginStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
