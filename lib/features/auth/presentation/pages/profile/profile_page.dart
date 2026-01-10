import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cognitive_alerts_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cognitive_panel_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/focus_mode_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/notifications_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';
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
    // ✅ usa a instância GLOBAL do Provider (main.dart)
    final prefs = context.watch<ProfilePreferencesController>();

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

            // ✅ IMPORTANTE: deixar scrollável (web/mobile + fontes grandes)
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

                  // ==========================
                  // Card: Informações Pessoais
                  // ==========================
                  SettingsSectionCard(
                    semanticsLabel: 'Informações pessoais',
                    icon: Icons.person_outline,
                    title: 'Informações Pessoais',
                    children: [
                      for (final section in widget.viewModel.sections)
                        for (final tile in section.tiles) SettingsTile(data: tile),
                    ],
                  ),

                  AppSpacing.gapLg,

                  // ==========================
                  // Card: Painel Cognitivo
                  // ==========================
                  CognitivePanelCard(controller: _cognitiveController),

                  AppSpacing.gapLg,

                  // ==========================
                  // Card: Modo Foco (Provider global)
                  // ==========================
                  const FocusModeCard(),

                  AppSpacing.gapLg,

                  // ==========================
                  // Card: Alertas Cognitivos
                  // ==========================
                  CognitiveAlertsCard(controller: prefs),

                  AppSpacing.gapLg,

                  // ==========================
                  // Card: Notificações
                  // ==========================
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
