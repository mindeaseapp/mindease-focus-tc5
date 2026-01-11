import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/routes.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/cognitive_alerts/cognitive_alerts_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/cognitive_panel/cognitive_panel_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/focus_mode/focus_mode_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/notifications/notifications_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';
import 'package:mindease_focus/shared/layout/centered_constrained.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

// ✅ NOVO: header + drawer
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';

// ✅ NOVO: estilos do ProfilePage
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
    final prefs = context.watch<ProfilePreferencesController>();

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
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
    }

    return Scaffold(
      appBar: MindEaseHeader(
        current: MindEaseNavItem.profile,
        userLabel: 'Usuário',
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
            padding: ProfilePageStyles.contentPadding(context), // ✅ estilo separado
            child: SingleChildScrollView(
              physics: ProfilePageStyles.scrollPhysics, // ✅ estilo separado
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            widget.viewModel.pageTitle,
                            textAlign: ProfilePageStyles.headerTextAlign, // ✅
                            style: ProfilePageStyles.titleStyle(context), // ✅
                          ),
                        ),
                        AppSpacing.gapXs,
                        Text(
                          widget.viewModel.pageSubtitle,
                          textAlign: ProfilePageStyles.headerTextAlign, // ✅
                          style: ProfilePageStyles.subtitleStyle(context), // ✅
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapXl,

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
                  CognitivePanelCard(controller: _cognitiveController),
                  AppSpacing.gapLg,
                  const FocusModeCard(),
                  AppSpacing.gapLg,
                  CognitiveAlertsCard(controller: prefs),
                  AppSpacing.gapLg,
                  NotificationsCard(controller: prefs),
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
