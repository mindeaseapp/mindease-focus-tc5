import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';

import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/login_form_validator.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_styles.dart';
import 'package:mindease_focus/features/auth/presentation/pages/login/feature_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: AppOpacity.medium
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Icon(
                        Icons.psychology_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    AppSpacing.hGapSm,
                    Semantics(
                      header: true,
                      label: 'MindEase - Nome da aplicação',
                      child: Text('MindEase', style: LoginStyles.brand),
                    ),
                  ],
                ),
                AppSpacing.gapLg,
                Semantics(
                  label: 'Facilitando sua jornada acadêmica e profissional',
                  child: Text(
                    'Facilitando sua jornada acadêmica e profissional',
                    style: LoginStyles.subtitle,
                  ),
                ),
                AppSpacing.gapMd,
                Semantics(
                  label: 'Uma plataforma pensada para pessoas neurodivergentes',
                  child: Text(
                    'Uma plataforma pensada para pessoas neurodivergentes.',
                    style: LoginStyles.description,
                  ),
                ),
                AppSpacing.gapXl,
                const FeatureCardsRow(),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: AppOpacity.medium),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: AppSizes.iconLG,
                  ),
                ),
                AppSpacing.hGapSm,
                Semantics(
                  header: true,
                  label: 'MindEase - Nome da aplicação',
                  child: Text('MindEase', style: LoginStyles.brand),
                ),
              ],
            ),
            AppSpacing.gapLg,
            Semantics(
              label: 'Facilitando sua jornada acadêmica e profissional',
              child: Text(
                'Facilitando sua jornada acadêmica e profissional',
                style: LoginStyles.subtitle,
              ),
            ),
            AppSpacing.gapMd,
            Semantics(
              label: 'Uma plataforma pensada para pessoas neurodivergentes',
              child: Text(
                'Uma plataforma pensada para pessoas neurodivergentes.',
                style: LoginStyles.description,
              ),
            ),
            const Spacer(),
            const FeatureCardsRow(),
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
          Semantics(
            header: true,
            label: 'Bem-vindo de volta',
            child: Text('Bem-vindo de volta', style: LoginStyles.title),
          ),
          AppSpacing.gapSm,
          Semantics(
            label: 'Entre com suas credenciais para continuar',
            child: Text(
              'Entre com suas credenciais para continuar',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
          AppSpacing.gapLg,

          Semantics(
            label: 'Campo de email',
            hint: 'Digite seu endereço de email',
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: EmailValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ),

          AppSpacing.gapMd,

          // SENHA
          Semantics(
            label: 'Campo de senha',
            hint: 'Digite sua senha',
            obscured: _obscurePassword,
            child: TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: PasswordValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: Semantics(
                  label: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    tooltip:
                        _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                  ),
                ),
              ),
            ),
          ),

          AppSpacing.gapSm,

          // ESQUECI MINHA SENHA
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              button: true,
              label: 'Esqueci minha senha',
              hint: 'Recuperar senha',
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
          ),

          AppSpacing.gapLg,

          // BOTÃO ENTRAR
          Semantics(
            button: true,
            enabled: _isFormValid && !_isSubmitting,
            label: _isSubmitting ? 'Entrando, aguarde' : 'Entrar na conta',
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: (!_isFormValid || _isSubmitting) ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Entrar'),
              ),
            ),
          ),

          AppSpacing.gapMd,

          // CADASTRO
          Center(
            child: Semantics(
              label: 'Não tem uma conta? Cadastre-se',
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
                  Semantics(
                    button: true,
                    label: 'Cadastre-se',
                    hint: 'Criar nova conta',
                    child: GestureDetector(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
