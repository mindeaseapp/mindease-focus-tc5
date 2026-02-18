import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de Layout e UI
import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

// Imports de Validadores
import 'package:mindease_focus/features/auth/domain/validators/name_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/confirm_password_validator.dart';

// Estilos
import 'package:mindease_focus/features/auth/presentation/pages/register/register_styles.dart';

// Controller
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';

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

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  bool get _isMobile => MediaQuery.of(context).size.width < RegisterStyles.mobileBreakpoint;

  void _onFieldsChanged() {
    context.read<RegisterController>().updateFormValidity(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      acceptedTerms: _acceptedTerms,
    );
  }

  Future<void> _submit() async {
    final controller = context.read<RegisterController>();
    FocusScope.of(context).unfocus();
    if (!controller.isFormValid || controller.isLoading) return;

    if (_formKey.currentState!.validate()) {
      final success = await controller.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: RegisterStyles.successColor,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage ?? 'Erro desconhecido.'),
            backgroundColor: RegisterStyles.errorColor,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RegisterController>();
    return Scaffold(
      body: _isMobile ? _buildMobile(controller) : _buildDesktop(controller),
    );
  }

  Widget _buildMobile(RegisterController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GradientPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  label: 'MindEase',
                  child: Text('MindEase', style: RegisterStyles.brand),
                ),
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
                child: _buildForm(controller),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(RegisterController controller) {
    return FlexGrid(
      left: GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              label: 'MindEase',
              child: Text('MindEase', style: RegisterStyles.brand),
            ),
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
          width: RegisterStyles.desktopContentWidth,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(RegisterStyles.cardPadding),
              child: _buildForm(controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(RegisterController controller) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text('Crie sua conta', style: RegisterStyles.title),
          ),
          AppSpacing.gapSm,
          Text(
            'Comece sua jornada com o MindEase',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapLg,

          if (controller.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.cardBorderRadiusSm),
                border: Border.all(color: RegisterStyles.errorColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: RegisterStyles.errorColor),
                  AppSpacing.gapSm,
                  Expanded(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: RegisterStyles.errorColor),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
          ],

          // NOME COMPLETO
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: NameValidator.validate,
            onChanged: (_) => _onFieldsChanged(),
            decoration: const InputDecoration(
              labelText: 'Nome completo',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          AppSpacing.gapMd,

          // EMAIL
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: EmailValidator.validate,
            onChanged: (_) => _onFieldsChanged(),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),

          AppSpacing.gapMd,

          // SENHA
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            validator: PasswordValidator.validate,
            onChanged: (_) => _onFieldsChanged(),
            decoration: InputDecoration(
              labelText: 'Senha',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),

          AppSpacing.gapMd,

          // CONFIRMAR SENHA
          TextFormField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            validator: (_) => ConfirmPasswordValidator.validate(
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
            onChanged: (_) => _onFieldsChanged(),
            decoration: InputDecoration(
              labelText: 'Confirmar senha',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
          ),

          AppSpacing.gapSm,

          // TERMOS DE USO
          InkWell(
            onTap: () {
              setState(() => _acceptedTerms = !_acceptedTerms);
              _onFieldsChanged();
            },
            child: Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  onChanged: (value) {
                    setState(() => _acceptedTerms = value ?? false);
                    _onFieldsChanged();
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
          ),

          AppSpacing.gapMd,

          // BOTÃO CRIAR CONTA
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: (!controller.isFormValid || controller.isLoading) ? null : _submit,
              child: controller.isLoading
                  ? const SizedBox(
                      width: RegisterStyles.loadingIconSize,
                      height: RegisterStyles.loadingIconSize,
                      child: CircularProgressIndicator(
                          color: RegisterStyles.loadingColor, strokeWidth: RegisterStyles.loadingStrokeWidth),
                    )
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