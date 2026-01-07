import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

import 'login_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                    const TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: AppSpacing.md),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
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
