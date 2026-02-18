import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/update_password_controller.dart';
import 'package:mindease_focus/features/auth/domain/validators/password_validator.dart';
import 'package:mindease_focus/features/auth/domain/validators/confirm_password_validator.dart';

// Tokens e Layout
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

// Estilos Locais
import 'package:mindease_focus/features/auth/presentation/pages/update_password/update_password_styles.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = context.read<AuthController>();
      if (!authController.isAuthenticated) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link expirado ou inválido. Faça login novamente.'),
            backgroundColor: UpdatePasswordStyles.errorColor,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UpdatePasswordController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir Senha')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: UpdatePasswordStyles.desktopContentWidth),
            child: Card(
              child: Padding(
                padding: UpdatePasswordStyles.cardPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          'Criar Nova Senha', 
                          style: UpdatePasswordStyles.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AppSpacing.gapMd,
                      Text(
                        'Sua identidade foi confirmada. Crie uma nova senha segura.',
                        textAlign: TextAlign.center,
                        style: UpdatePasswordStyles.description,
                      ),
                      AppSpacing.gapLg,

                      // Nova Senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        validator: PasswordValidator.validate,
                        decoration: InputDecoration(
                          labelText: 'Nova Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _obscureText ? 'Mostrar senha' : 'Ocultar senha',
                            icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                      ),
                      AppSpacing.gapMd,

                      // Confirmar Senha
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText,
                        validator: (val) => ConfirmPasswordValidator.validate(
                          password: _passwordController.text,
                          confirmPassword: val ?? '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Confirmar Nova Senha',
                          prefixIcon: Icon(Icons.lock_reset),
                        ),
                      ),
                      AppSpacing.gapLg,

                      // Botão Salvar
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeight,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () => _submit(context, controller),
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: UpdatePasswordStyles.loadingIconSize, 
                                  height: UpdatePasswordStyles.loadingIconSize, 
                                  child: CircularProgressIndicator(
                                      color: UpdatePasswordStyles.loadingColor, 
                                      strokeWidth: UpdatePasswordStyles.loadingStrokeWidth),
                                )
                              : const Text('Redefinir e Ir para Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Lógica de UI separada
  Future<void> _submit(BuildContext context, UpdatePasswordController controller) async {
    if (!_formKey.currentState!.validate()) return;

    // Chama o UseCase através do Controller
    final success = await controller.updatePassword(_passwordController.text);
    
    // Verifica se o widget ainda existe antes de usar o contexto
    if (!context.mounted) return;

    if (success) {
      // Navegação de sucesso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Senha Atualizada!'),
          content: const Text('Sua senha foi alterada com sucesso. Faça login novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                // Limpa a pilha e manda para o Login
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', 
                  (route) => false,
                );
              },
              child: const Text('Ir para Login'),
            ),
          ],
        ),
      );
    } else if (controller.errorMessage != null) {
      // Feedback de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage!),
          backgroundColor: UpdatePasswordStyles.errorColor,
        ),
      );
    }
  }
}