import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Controllers
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';

// Models
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view_model.dart';

// Widgets
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/profile_identity_tile.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cognitive_alerts_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cognitive_panel_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/focus_mode_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/notifications_card.dart';

// Tokens e Layout Compartilhado
import 'package:mindease_focus/shared/layout/centered_constrained.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class ProfilePage extends StatefulWidget {
  final ProfileViewModel viewModel;

  const ProfilePage({
    super.key,
    required this.viewModel,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final CognitivePanelController _cognitiveController =
      CognitivePanelController();

  @override
  void dispose() {
    _cognitiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Acesso aos Controllers (Estado Global)
    final prefs = context.watch<ProfilePreferencesController>();
    final authController = context.watch<AuthController>();

    // 2. Acesso à Entidade de Domínio (Clean Architecture)
    // A View não sabe de onde vem o dado, nem como tratar nulos. Ela só exibe.
    final userEntity = authController.user;

    return Scaffold(
      body: SafeArea(
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: CenteredConstrained(
            maxWidth: AppSizes.maxProfileWidth,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding(context),
              vertical: AppSpacing.xl,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Cabeçalho da Página ---
                  Center(
                    child: Column(
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            widget.viewModel.pageTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        AppSpacing.gapXs,
                        Text(
                          widget.viewModel.pageSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapXl,

                  // ============================================
                  // 1. Identidade do Usuário (Dados Reais)
                  // ============================================
                  // Substitui a antiga lista estática por um componente
                  // conectado ao AuthController
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ProfileIdentityTile(
                        name: userEntity.name,
                        email: userEntity.email,
                        // No futuro, isso pode abrir um modal de edição de perfil
                        onTap: () {}, 
                      ),
                    ),
                  ),

                  AppSpacing.gapLg,

                  // ============================================
                  // 2. Painel Cognitivo
                  // ============================================
                  CognitivePanelCard(controller: _cognitiveController),

                  AppSpacing.gapLg,

                  // ============================================
                  // 3. Modo Foco
                  // ============================================
                  const FocusModeCard(),

                  AppSpacing.gapLg,

                  // ============================================
                  // 4. Alertas e Preferências
                  // ============================================
                  CognitiveAlertsCard(controller: prefs),

                  AppSpacing.gapLg,

                  // ============================================
                  // 5. Notificações
                  // ============================================
                  NotificationsCard(controller: prefs),

                  AppSpacing.gapXl,

                  // ============================================
                  // 6. Área de Ações da Conta (Logout)
                  // ============================================
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Ação de Logout
                        // O AuthGuard (se configurado nas rotas) redirecionará 
                        // automaticamente para o Login quando o status mudar.
                        context.read<AuthController>().logout();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text("Sair da Conta"),
                    ),
                  ),
                  
                  // Espaço extra no final para garantir scroll confortável
                  AppSpacing.gapXl,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}