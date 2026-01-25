import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/routes.dart';

// Controllers
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';

// ViewModel
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view/profile_view_model.dart';

// Widgets (cards)
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/cognitive_alerts/cognitive_alerts_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/cognitive_panel/cognitive_panel_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/focus_mode/focus_mode_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/notifications/notifications_card.dart';

// Widgets (settings)
import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

// Identidade real
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/profile_identity_tile/profile_identity_tile.dart';

// Layout/Tokens
import 'package:mindease_focus/shared/layout/centered_constrained.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

// Header + Drawer
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';

// Styles
import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_styles.dart';

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
    // Controllers
    final prefs = context.watch<ProfilePreferencesController>();

    // Auth
    final authController = context.watch<AuthController>();
    final userEntity = authController.user;

    void goTo(MindEaseNavItem item) {
      switch (item) {
        case MindEaseNavItem.dashboard:
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
          return;
        case MindEaseNavItem.tasks:
          Navigator.of(context).pushReplacementNamed(AppRoutes.tasks);
          return;
        case MindEaseNavItem.profile:
          Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
          return;
      }
    }

    void logout() {
      context.read<AuthController>().logout();

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
    }

    final userLabel = (userEntity.name.isNotEmpty)
        ? userEntity.name
        : (userEntity.email.isNotEmpty ? userEntity.email : 'Usuário');

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
                  // --- Cabeçalho da Página (✅ MOBILE à esquerda / DESKTOP centro) ---
                  Align(
                    alignment: ProfilePageStyles.headerAlignment(context),
                    child: Column(
                      crossAxisAlignment:
                          ProfilePageStyles.headerCrossAxisAlignment(context),
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            widget.viewModel.pageTitle,
                            textAlign: ProfilePageStyles.headerTextAlign(context),
                            style: ProfilePageStyles.titleStyle(context),
                          ),
                        ),
                        AppSpacing.gapXs,
                        Text(
                          widget.viewModel.pageSubtitle,
                          textAlign: ProfilePageStyles.headerTextAlign(context),
                          style: ProfilePageStyles.subtitleStyle(context),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.gapXl,

                  // ============================================
                  // 1) Identidade REAL do usuário
                  // ============================================
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

                  // ============================================
                  // 2) Seção do ViewModel
                  // ============================================
                  SettingsSectionCard(
                    semanticsLabel: 'Informações pessoais',
                    icon: Icons.person_outline,
                    title: 'Informações Pessoais',
                    children: [
                      for (final section in widget.viewModel.sections)
                        for (final tile in section.tiles)
                          SettingsTile(data: tile),
                    ],
                  ),

                  AppSpacing.gapLg,

                  // ============================================
                  // 3) Painel Cognitivo
                  // ============================================
                  CognitivePanelCard(controller: _cognitiveController),

                  AppSpacing.gapLg,

                  // ============================================
                  // 4) Modo Foco
                  // ============================================
                  const FocusModeCard(),

                  AppSpacing.gapLg,

                  // ============================================
                  // 5) Alertas e Preferências
                  // ============================================
                  CognitiveAlertsCard(controller: prefs),

                  AppSpacing.gapLg,

                  // ============================================
                  // 6) Notificações
                  // ============================================
                  NotificationsCard(controller: prefs),

                  AppSpacing.gapXl,

                  // ============================================
                  // 7) Botão logout
                  // ============================================
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
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
