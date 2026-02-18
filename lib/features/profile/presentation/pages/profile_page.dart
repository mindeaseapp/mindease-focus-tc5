import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/core/navigation/routes.dart';

// Controllers
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';

// ViewModel
import 'package:mindease_focus/features/profile/domain/models/profile_view/profile_view_model.dart';

// Widgets (cards)
import 'package:mindease_focus/features/profile/presentation/widgets/cards/cognitive_alerts/cognitive_alerts_card.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/cognitive_panel/cognitive_panel_card.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/focus_mode/focus_mode_card.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/notifications/notifications_card.dart';

// Widgets (settings)
import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

// Identidade real
import 'package:mindease_focus/features/profile/presentation/widgets/cards/profile_identity_tile/profile_identity_tile.dart';

// Layout/Tokens
import 'package:mindease_focus/shared/layout/centered_constrained.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

// Header + Drawer
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';

// ✅ NOVO: FAB com Popover + Ajuda
import 'package:mindease_focus/shared/widgets/focus_mode/mindease_accessibility_fab.dart';

// Styles
import 'package:mindease_focus/features/profile/presentation/pages/profile_styles.dart';

class ProfilePage extends StatefulWidget {
  final ProfileViewModel? viewModel;

  const ProfilePage({
    super.key,
    this.viewModel,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final CognitivePanelController _cognitiveController;

  @override
  void initState() {
    super.initState();
    // ✅ Inicializa o controller local com callback para salvar no Supabase
    _cognitiveController = CognitivePanelController(
      onComplexityChanged: (newComplexity) {
        if (mounted) {
           context.read<ProfilePreferencesController>().applyComplexity(newComplexity);
        }
      },
    );
  }

  @override
  void dispose() {
    _cognitiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Controllers
    final prefs = context.watch<ProfilePreferencesController>();
    
    // ✅ Sincronia: Se o dado do Supabase mudar (load inicial), atualiza a UI
    if (prefs.complexity != _cognitiveController.complexity) {
      // Usamos postFrameCallback ou apenas setamos se não estivermos no meio de build? 
      // Como o setComplexity tem check de igualdade e notifyListeners, melhor evitar chamar durante build se possível,
      // mas aqui é essencial para a UI refletir o estado.
      // O controller local tem check de igualdade, então só vai notificar se mudar de verdade.
      _cognitiveController.setComplexity(prefs.complexity);
    }

    // Auth
    final authController = context.watch<AuthController>();
    final userEntity = authController.user;
    final userLabel = userEntity.displayName;

    final viewModel = widget.viewModel ?? ProfileViewModel.demo(
      name: userEntity.name,
      email: userEntity.email,
    );

    void goTo(MindEaseNavItem item) {
      if (item == MindEaseNavItem.profile) return;
      
      final routeName = item == MindEaseNavItem.dashboard 
          ? AppRoutes.dashboard 
          : AppRoutes.tasks;
          
      if (item == MindEaseNavItem.dashboard) {
        Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.dashboard);
      } else {
        Navigator.of(context).pushNamed(routeName);
      }
    }

    void logout() {
      context.read<AuthController>().logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
    }

    return Scaffold(
      appBar: MindEaseHeader(
        current: MindEaseNavItem.profile,
        userLabel: userLabel,
        onNavigate: goTo,
        onLogout: logout,
      ),
      drawer: AppSizes.isMobile(context)
          ? MindEaseDrawer(
              current: MindEaseNavItem.profile,
              onNavigate: goTo,
              onLogout: logout,
            )
          : null,

      // ✅ AQUI: adiciona o Popover (expandir) + Ajuda na tela de Perfil
      floatingActionButton: const MindEaseAccessibilityFab(),

      body: SafeArea(
        top: false,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: CenteredConstrained(
            maxWidth: AppSizes.maxProfileWidth,
            padding: ProfilePageStyles.contentPadding(context),
            child: SingleChildScrollView(
              physics: ProfilePageStyles.scrollPhysics,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: ProfilePageStyles.headerAlignment(context),
                    child: Column(
                      crossAxisAlignment:
                          ProfilePageStyles.headerCrossAxisAlignment(context),
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            viewModel.pageTitle,
                            textAlign: ProfilePageStyles.headerTextAlign(context),
                            style: ProfilePageStyles.titleStyle(context),
                          ),
                        ),
                        AppSpacing.gapXs,
                        Text(
                          viewModel.pageSubtitle,
                          textAlign: ProfilePageStyles.headerTextAlign(context),
                          style: ProfilePageStyles.subtitleStyle(context),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapXl,

                  // 1) Identidade REAL do usuário
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ProfileIdentityTile(
                        name: userEntity.name,
                        email: userEntity.email,
                        onTap: () {},
                      ),
                    ),
                  ),
                  AppSpacing.gapLg,

                  // 2) Seção do ViewModel
                  SettingsSectionCard(
                    semanticsLabel: 'Informações pessoais',
                    icon: Icons.person_outline,
                    title: 'Informações Pessoais',
                    children: [
                      for (final section in viewModel.sections)
                        for (final tile in section.tiles) SettingsTile(data: tile),
                    ],
                  ),
                  AppSpacing.gapLg,

                  // 3) Painel Cognitivo
                  CognitivePanelCard(controller: _cognitiveController),
                  AppSpacing.gapLg,

                  // 4) Modo Foco
                  const FocusModeCard(),
                  AppSpacing.gapLg,

                  // 5) Alertas e Preferências
                  CognitiveAlertsCard(controller: prefs),
                  AppSpacing.gapLg,

                  // 6) Notificações
                  NotificationsCard(controller: prefs),
                  AppSpacing.gapXl,

                  // 7) Botão logout
                  SizedBox(
                    height: ProfilePageStyles.logoutButtonHeight,
                    child: OutlinedButton.icon(
                      onPressed: logout,
                      style: ProfilePageStyles.logoutButtonStyle(),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Sair da Conta'),
                    ),
                  ),
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
