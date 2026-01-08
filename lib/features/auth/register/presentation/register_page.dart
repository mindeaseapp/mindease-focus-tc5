import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

import 'package:mindease_focus/features/auth/domain/validators/name_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/confirm_password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/register_form_validator.dart';

import 'package:mindease_focus/features/auth/register/presentation/register_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isSubmitting = false;
  bool _isFormValid = false;

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  void _updateFormValidity() {
    final isValid = RegisterFormValidator.isValid(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      acceptedTerms: _acceptedTerms,
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

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isSubmitting = false);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  // ======================================================
  // 📱 MOBILE — NÃO MEXE
  // ======================================================
  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GradientPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MindEase', style: RegisterStyles.brand),
                AppSpacing.gapLg,
                Text(
                  'Facilitando sua jornada acadêmica e profissional',
                  style: RegisterStyles.subtitle,
                ),
                AppSpacing.gapMd,
                Text(
                  'Uma plataforma pensada para pessoas neurodivergentes.',
                  style: RegisterStyles.description,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(RegisterStyles.cardPadding),
                child: _buildForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🖥️ DESKTOP — AJUSTADO
  // ======================================================
  Widget _buildDesktop() {
    return FlexGrid(
      left: GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MindEase', style: RegisterStyles.brand),
            AppSpacing.gapLg,
            Text(
              'Facilitando sua jornada acadêmica e profissional',
              style: RegisterStyles.subtitle,
            ),
            AppSpacing.gapMd,
            Text(
              'Uma plataforma pensada para pessoas neurodivergentes.',
              style: RegisterStyles.description,
            ),
          ],
        ),
      ),
      right: Center(
        child: SizedBox(
          width: 420,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(RegisterStyles.cardPadding),
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // 🧩 FORM — COMPACTO PARA WEB
  // ======================================================
  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Crie sua conta', style: RegisterStyles.title),
          AppSpacing.gapSm,
          Text(
            'Comece sua jornada com o MindEase',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapLg,
          TextFormField(
            controller: _nameController,
            validator: NameValidator.validate,
            onChanged: (_) => _updateFormValidity(),
            decoration: const InputDecoration( 
              labelText: 'Nome completo',
              prefixIcon: Icon(Icons.person_outline), 
            ),
          ),
          AppSpacing.gapMd,
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
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          AppSpacing.gapMd,
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            validator: (_) => ConfirmPasswordValidator.validate(
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
            onChanged: (_) => _updateFormValidity(),
            decoration: InputDecoration(
              labelText: 'Confirmar senha',
              prefixIcon: const Icon(Icons.lock_outline), 
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
            ),
          ),
          AppSpacing.gapSm,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _acceptedTerms,
                onChanged: (value) {
                  setState(() => _acceptedTerms = value ?? false);
                  _updateFormValidity();
                },
              ),
              const Expanded( 
                child: Text(
                  'Eu aceito os termos de uso e a política de privacidade',
                  style: AppTypography.bodySmall,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: (!_isFormValid || _isSubmitting) ? null : _submit,
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Criar conta'), 
            ),
          ),
          AppSpacing.gapMd,
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Já tem uma conta? Entrar'), 
            ),
          ),
        ],
      ),
    );
  }
}