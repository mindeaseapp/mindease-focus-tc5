import 'package:flutter/material.dart';

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
import 'package:mindease_focus/features/auth/domain/validators/register_form_validator.dart';

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
  final _registerController = RegisterController();

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
  bool _isFormValid = false;

  bool get _isMobile => MediaQuery.of(context).size.width < RegisterStyles.mobileBreakpoint;

  @override
  void initState() {
    super.initState();
    _registerController.addListener(() {
      if (mounted) setState(() {});
    });
  }

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

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_isFormValid || _registerController.isLoading) return;

    if (_formKey.currentState!.validate()) {
      final success = await _registerController.register(
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
            content: Text(_registerController.errorMessage ?? 'Erro desconhecido.'),
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
    _registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GradientPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  label: 'MindEase - Nome da aplicação',
                  child: Text('MindEase', style: RegisterStyles.brand),
                ),
                AppSpacing.gapLg,
                Semantics(
                  label: 'Facilitando sua jornada acadêmica e profissional',
                  child: Text(
                    'Facilitando sua jornada acadêmica e profissional',
                    style: RegisterStyles.subtitle,
                  ),
                ),
                AppSpacing.gapMd,
                Semantics(
                  label: 'Uma plataforma pensada para pessoas neurodivergentes',
                  child: Text(
                    'Uma plataforma pensada para pessoas neurodivergentes.',
                    style: RegisterStyles.description,
                  ),
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

  Widget _buildDesktop() {
    return FlexGrid(
      left: GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              label: 'MindEase - Nome da aplicação',
              child: Text('MindEase', style: RegisterStyles.brand),
            ),
            AppSpacing.gapLg,
            Semantics(
              label: 'Facilitando sua jornada acadêmica e profissional',
              child: Text(
                'Facilitando sua jornada acadêmica e profissional',
                style: RegisterStyles.subtitle,
              ),
            ),
            AppSpacing.gapMd,
            Semantics(
              label: 'Uma plataforma pensada para pessoas neurodivergentes',
              child: Text(
                'Uma plataforma pensada para pessoas neurodivergentes.',
                style: RegisterStyles.description,
              ),
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
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            label: 'Crie sua conta',
            child: Text('Crie sua conta', style: RegisterStyles.title),
          ),
          AppSpacing.gapSm,
          Semantics(
            label: 'Comece sua jornada com o MindEase',
            child: Text(
              'Comece sua jornada com o MindEase',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          AppSpacing.gapLg,

          // NOME COMPLETO
          Semantics(
            label: 'Campo de nome completo',
            hint: 'Digite seu nome completo',
            child: TextFormField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: NameValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
          ),

          AppSpacing.gapMd,

          // EMAIL
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
              textInputAction: TextInputAction.next,
              validator: PasswordValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              },
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: Semantics(
                  label: _obscurePassword 
                    ? 'Mostrar senha' 
                    : 'Ocultar senha',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    tooltip: _obscurePassword 
                      ? 'Mostrar senha' 
                      : 'Ocultar senha',
                  ),
                ),
              ),
            ),
          ),

          AppSpacing.gapMd,

          // CONFIRMAR SENHA
          Semantics(
            label: 'Campo de confirmação de senha',
            hint: 'Digite novamente sua senha',
            obscured: _obscureConfirmPassword,
            child: TextFormField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              validator: (_) => ConfirmPasswordValidator.validate(
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text,
              ),
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) {
                if (_isFormValid && !_registerController.isLoading) {
                  _submit();
                }
              },
              decoration: InputDecoration(
                labelText: 'Confirmar senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: Semantics(
                  label: _obscureConfirmPassword 
                    ? 'Mostrar confirmação de senha' 
                    : 'Ocultar confirmação de senha',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                    tooltip: _obscureConfirmPassword 
                      ? 'Mostrar confirmação de senha' 
                      : 'Ocultar confirmação de senha',
                  ),
                ),
              ),
            ),
          ),

          AppSpacing.gapSm,

          // TERMOS DE USO
          Semantics(
            label: 'Aceitar termos de uso e política de privacidade',
            hint: _acceptedTerms 
              ? 'Termos aceitos' 
              : 'Marque para aceitar os termos',
            checked: _acceptedTerms,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  excludeSemantics: true,
                  child: Checkbox(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() => _acceptedTerms = value ?? false);
                      _updateFormValidity();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _acceptedTerms = !_acceptedTerms);
                      _updateFormValidity();
                    },
                    child: const Text(
                      'Eu aceito os termos de uso e a política de privacidade',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.gapMd,

          // BOTÃO CRIAR CONTA
          Semantics(
            button: true,
            enabled: _isFormValid && !_registerController.isLoading,
            label: _registerController.isLoading 
              ? 'Criando conta, aguarde' 
              : 'Criar conta',
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: (!_isFormValid || _registerController.isLoading)
                    ? null
                    : _submit,
                child: _registerController.isLoading
                    ? const SizedBox(
                        width: RegisterStyles.loadingIconSize,
                        height: RegisterStyles.loadingIconSize,
                        child: CircularProgressIndicator(
                            color: RegisterStyles.loadingColor, strokeWidth: RegisterStyles.loadingStrokeWidth),
                      )
                    : const Text('Criar conta'),
              ),
            ),
          ),

          AppSpacing.gapMd,

          // LINK PARA LOGIN
          Center(
            child: Semantics(
              button: true,
              label: 'Já tem uma conta? Entrar',
              hint: 'Ir para página de login',
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Já tem uma conta? Entrar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}