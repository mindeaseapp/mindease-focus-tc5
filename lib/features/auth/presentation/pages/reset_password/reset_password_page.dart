import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_styles.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  bool _isSubmitting = false;
  bool _isFormValid = false;

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateFormValidity);
  }

  void _updateFormValidity() {
    final isValid = EmailValidator.validate(_emailController.text) == null;
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
        if (!mounted) return;
        setState(() => _isSubmitting = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se o email existir, enviaremos instruções para redefinir a senha.'),
            duration: Duration(seconds: 4),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateFormValidity);
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Semantics(
        label: 'Página de recuperação de senha',
        child: _isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  Widget _buildMobile() {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GradientPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    label: 'MindEase',
                    child: ExcludeSemantics(
                      child: Text('MindEase', style: ResetPasswordStyles.brand),
                    ),
                  ),
                  AppSpacing.gapLg,
                  Semantics(
                    header: true,
                    label: 'Não se preocupe, ajudaremos você',
                    child: ExcludeSemantics(
                      child: Text('Não se preocupe, ajudaremos você', style: ResetPasswordStyles.subtitle),
                    ),
                  ),
                  AppSpacing.gapMd,
                  Text('Recupere o acesso à sua conta de forma simples e segura.', style: ResetPasswordStyles.description),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(ResetPasswordStyles.cardPadding),
                  child: _buildForm(),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
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
              label: 'MindEase',
              child: ExcludeSemantics(
                child: Text('MindEase', style: ResetPasswordStyles.brand),
              ),
            ),
            AppSpacing.gapLg,
            Semantics(
              header: true,
              label: 'Não se preocupe, ajudaremos você',
              child: ExcludeSemantics(
                child: Text('Não se preocupe, ajudaremos você', style: ResetPasswordStyles.subtitle),
              ),
            ),
            AppSpacing.gapMd,
            Text('Recupere o acesso à sua conta de forma simples e segura.', style: ResetPasswordStyles.description),
          ],
        ),
      ),
      right: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(ResetPasswordStyles.cardPadding),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            label: 'Recuperar senha',
            child: const ExcludeSemantics(
              child: Text('Recuperar senha', style: ResetPasswordStyles.title),
            ),
          ),
          AppSpacing.gapSm,
          Text('Digite seu email e enviaremos instruções para redefinir sua senha.', style: ResetPasswordStyles.helper),
          AppSpacing.gapLg,
          Semantics(
            label: 'Campo de email. Digite seu endereço de email para receber instruções de recuperação de senha',
            textField: true,
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: EmailValidator.validate,
              onChanged: (_) => _updateFormValidity(),
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'nome@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ),
          AppSpacing.gapLg,
          Semantics(
            button: true,
            enabled: _isFormValid && !_isSubmitting,
            label: _isSubmitting 
              ? 'Enviando instruções. Por favor, aguarde' 
              : _isFormValid 
                ? 'Enviar instruções de recuperação de senha' 
                : 'Botão desabilitado. Digite um email válido para enviar instruções',
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: (!_isFormValid || _isSubmitting) ? null : _submit,
                child: _isSubmitting
                    ? Semantics(
                        label: 'Carregando',
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                            semanticsLabel: 'Enviando instruções',
                          ),
                        ),
                      )
                    : const Text('Enviar instruções'),
              ),
            ),
          ),
          AppSpacing.gapLg,
          Center(
            child: Semantics(
              button: true,
              label: 'Voltar para a página de login',
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar para login'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}