import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/login_form_validator.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  bool _isFormValid = false;

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  // ======================================================
  // 🔄 FORM STATE
  // ======================================================

  void _updateFormValidity() {
    final isValid = LoginFormValidator.isValid(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_isFormValid || _isSubmitting) return;

    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulação de login
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ======================================================
  // 🧱 UI
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  // ======================================================
  // 📱 MOBILE
  // ======================================================

  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GradientPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MindEase', style: LoginStyles.brand),
                AppSpacing.gapLg,
                Text(
                  'Facilitando sua jornada acadêmica e profissional',
                  style: LoginStyles.subtitle,
                ),
                AppSpacing.gapMd,
                Text(
                  'Uma plataforma pensada para pessoas neurodivergentes.',
                  style: LoginStyles.description,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(LoginStyles.cardPadding),
                child: _buildForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🖥️ DESKTOP
  // ======================================================

  Widget _buildDesktop() {
    return FlexGrid(
      left: GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MindEase', style: LoginStyles.brand),
            AppSpacing.gapLg,
            Text(
              'Facilitando sua jornada acadêmica e profissional',
              style: LoginStyles.subtitle,
            ),
            AppSpacing.gapMd,
            Text(
              'Uma plataforma pensada para pessoas neurodivergentes.',
              style: LoginStyles.description,
            ),
          ],
        ),
      ),
      right: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(LoginStyles.cardPadding),
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // 🧩 FORM
  // ======================================================

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bem-vindo de volta', style: LoginStyles.title),
          AppSpacing.gapSm,
          Text(
            'Entre com suas credenciais para continuar',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: AppTypography.medium,
            ),
          ),
          AppSpacing.gapLg,

          // EMAIL
          TextFormField(
            controller: _emailController,
            validator: EmailValidator.validate,
            onChanged: (_) => _updateFormValidity(),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),

          AppSpacing.gapMd,

          // SENHA
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: PasswordValidator.validate,
            onChanged: (_) => _updateFormValidity(),
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
          ),

          AppSpacing.gapSm,

          // ESQUECI MINHA SENHA
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reset-password');
              },
              child: Text(
                'Esqueci minha senha',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: AppTypography.medium,
                ),
              ),
            ),
          ),

          AppSpacing.gapLg,

          // BOTÃO ENTRAR
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: (!_isFormValid || _isSubmitting) ? null : _submit,
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Entrar'),
            ),
          ),

          AppSpacing.gapMd,

          // ✅ CADASTRO — CORREÇÃO DEFINITIVA (SEM OVERFLOW)
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              children: [
                Text(
                  'Não tem uma conta?',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Cadastre-se',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
