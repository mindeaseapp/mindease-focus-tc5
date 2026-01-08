import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/layout/flex_grid.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

import 'package:mindease_focus/features/auth/domain/validators/email_validator.dart';
import 'package:mindease_focus/features/auth/reset_password/presentation/reset_password_styles.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isSubmitting = false;
  bool _isFormValid = false;

  bool get _isMobile => MediaQuery.of(context).size.width < 768;

  // ======================================================
  // 🔄 FORM STATE
  // ======================================================

  void _updateFormValidity() {
    final isValid =
        EmailValidator.validate(_emailController.text) == null;

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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Se o email existir, enviaremos instruções para redefinir a senha.',
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                  Text('MindEase', style: ResetPasswordStyles.brand),
                  AppSpacing.gapLg,
                  Text(
                    'Não se preocupe, ajudaremos você',
                    style: ResetPasswordStyles.subtitle,
                  ),
                  AppSpacing.gapMd,
                  Text(
                    'Recupere o acesso à sua conta de forma simples e segura.',
                    style: ResetPasswordStyles.description,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(
                    ResetPasswordStyles.cardPadding,
                  ),
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

  // ======================================================
  // 🖥️ DESKTOP
  // ======================================================
  Widget _buildDesktop() {
    return FlexGrid(
      left: GradientPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MindEase', style: ResetPasswordStyles.brand),
            AppSpacing.gapLg,
            Text(
              'Não se preocupe, ajudaremos você',
              style: ResetPasswordStyles.subtitle,
            ),
            AppSpacing.gapMd,
            Text(
              'Recupere o acesso à sua conta de forma simples e segura.',
              style: ResetPasswordStyles.description,
            ),
          ],
        ),
      ),
      right: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(
                ResetPasswordStyles.cardPadding,
              ),
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
          Text(
            'Recuperar senha',
            style: ResetPasswordStyles.title,
          ),
          AppSpacing.gapSm,
          Text(
            'Digite seu email e enviaremos instruções para redefinir sua senha.',
            style: ResetPasswordStyles.helper,
          ),
          AppSpacing.gapLg,

          TextFormField(
            controller: _emailController,
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

          AppSpacing.gapLg,

          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: (!_isFormValid || _isSubmitting) ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Enviar instruções'),
            ),
          ),

          AppSpacing.gapLg,

          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar para login'),
            ),
          ),
        ],
      ),
    );
  }
}
