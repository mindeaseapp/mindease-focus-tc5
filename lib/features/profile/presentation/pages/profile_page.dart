import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/core/navigation/routes.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';

import 'package:mindease_focus/features/profile/domain/models/profile_view/profile_view_model.dart';

import 'package:mindease_focus/features/profile/presentation/widgets/cards/cognitive_alerts/cognitive_alerts_card.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/cognitive_panel/cognitive_panel_card.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/focus_mode/focus_mode_card.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/notifications/notifications_card.dart';

import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

import 'package:mindease_focus/features/profile/presentation/widgets/cards/profile_identity_tile/profile_identity_tile.dart';

import 'package:mindease_focus/shared/layout/centered_constrained.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';

import 'package:mindease_focus/shared/widgets/focus_mode/mindease_accessibility_fab.dart';

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
    _cognitiveController = CognitivePanelController(
      onComplexityChanged: (newComplexity) {
        if (mounted) {
           context.read<ProfilePreferencesController>().applyComplexity(newComplexity);
        }
      },
      onFontSizeChanged: (newFontSize) {
        if (mounted) {
          context.read<ProfilePreferencesController>().setFontSize(newFontSize);
        }
      },
      onDisplayModeChanged: (newDisplayMode) {
        if (mounted) {
          context.read<ProfilePreferencesController>().setDisplayMode(newDisplayMode);
        }
      },
      onSpacingChanged: (newSpacing) {
        if (mounted) {
          context.read<ProfilePreferencesController>().setSpacing(newSpacing);
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
    final prefs = context.watch<ProfilePreferencesController>();
    
    _cognitiveController.syncFromGlobal(
      globalComplexity: prefs.complexity,
      globalDisplayMode: prefs.displayMode,
      globalSpacing: prefs.spacing,
      globalFontSize: prefs.fontSize,
    );

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

      floatingActionButton: const MindEaseAccessibilityFab(),

      body: SafeArea(
        top: false,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: CenteredConstrained(
            maxWidth: AppSizes.maxProfileWidth,
            padding: ProfilePageStyles.contentPadding(context),
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
    );
  }
}
