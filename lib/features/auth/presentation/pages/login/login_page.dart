import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/core/navigation/routes.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/login_form_validator.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_styles.dart';
import 'package:mindease_focus/features/auth/presentation/pages/login/feature_card.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/login_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';

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
  bool _isFormValid = false;

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final isValid = LoginFormValidator.isValid(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  Future<void> _submit(LoginController controller) async {
    FocusScope.of(context).unfocus();

    if (controller.isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    final success = await controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.read<AuthController>().refreshUser();

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dashboard,
        arguments: {'showWelcome': true},
      );
    } else if (controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    return ChangeNotifierProvider(
      create: (_) => LoginController(authRepository),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: _isMobile ? _buildMobile(controller) : _buildDesktop(controller),
          );
        },
      ),
    );
  }

  Widget _buildMobile(LoginController controller) {
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
                      padding: LoginStyles.brandIconPadding,
                      decoration: LoginStyles.brandIconDecoration(context),
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
                Text(
                  'Facilitando sua jornada acadêmica e profissional',
                  style: LoginStyles.subtitle,
                ),
                AppSpacing.gapMd,
                Text(
                  'Uma plataforma pensada para pessoas neurodivergentes.',
                  style: LoginStyles.description,
                ),
                AppSpacing.gapXl,
                const FeatureCardsRow(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Card(
              child: _buildForm(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(LoginController controller) {
    return FlexGrid(
      left: GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: LoginStyles.brandIconPadding,
                  decoration: LoginStyles.brandIconDecoration(context),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: AppSizes.iconLG,
                  ),
                ),
                AppSpacing.hGapSm,
                Text('MindEase', style: LoginStyles.brand),
              ],
            ),
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
            AppSpacing.gapXl,
            const FeatureCardsRow(),
          ],
        ),
      ),
      right: Center(
        child: ConstrainedBox(
          constraints: LoginStyles.desktopCardConstraints,
          child: Card(
            child: _buildForm(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(LoginController controller) {
    return Padding(
      padding: const EdgeInsets.all(LoginStyles.cardPadding),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text('Bem-vindo de volta', style: LoginStyles.title),
            ),
            AppSpacing.gapSm,
            Text(
              'Entre com suas credenciais para continuar',
              style: LoginStyles.formSubtitle,
            ),
            AppSpacing.gapLg,

            TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: EmailValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              enabled: !controller.isLoading,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            AppSpacing.gapMd,

            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: PasswordValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) => _submit(controller),
              enabled: !controller.isLoading,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: controller.isLoading
                        ? null
                        : () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
              ),
            ),

            AppSpacing.gapSm,

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: controller.isLoading
                    ? null
                    : () => Navigator.pushNamed(context, '/reset-password'),
                child: const Text('Esqueci minha senha'),
              ),
            ),

            AppSpacing.gapLg,

            // Entrar
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: (!_isFormValid || controller.isLoading)
                    ? null
                    : () => _submit(controller),
                child: controller.isLoading
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

            AppSpacing.gapMd,

            // Cadastro
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                children: [
                  Text(
                    'Não tem uma conta?',
                    style: LoginStyles.noAccountText,
                  ),
                  Semantics(
                    button: true,
                    label: 'Ir para tela de cadastro',
                    child: GestureDetector(
                      onTap: controller.isLoading
                          ? null
                          : () => Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Cadastre-se',
                        style: LoginStyles.signUpLink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
