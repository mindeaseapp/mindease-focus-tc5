import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/toggle_setting_tile/toggle_setting_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

class FocusModeCard extends StatelessWidget {
  const FocusModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<ProfilePreferencesController>();
    final theme = context.read<ThemeController>();

    final reduceVisualNoise = prefs.hideDistractions;

    return SettingsSectionCard(
      semanticsLabel: 'Modo Foco',
      icon: Icons.visibility_outlined,
      title: 'Modo Foco',
      children: [
        ToggleSettingTile(
          title: 'Ocultar Distrações',
          subtitle: reduceVisualNoise
              ? null
              : 'Remove elementos não essenciais da interface',
          value: prefs.hideDistractions,
          onChanged: prefs.setHideDistractions,
          semanticsLabel:
              'Ocultar distrações. ${prefs.hideDistractions ? "Ativado" : "Desativado"}',
        ),

        ToggleSettingTile(
          title: 'Alto Contraste',
          subtitle: reduceVisualNoise
              ? null
              : 'Aumenta o contraste para melhor legibilidade',
          value: prefs.highContrast,
          onChanged: (value) {
            prefs.setHighContrast(value);
            theme.toggleHighContrast(value);

          },
          semanticsLabel:
              'Alto contraste. ${prefs.highContrast ? "Ativado" : "Desativado"}',
        ),

        ToggleSettingTile(
          title: 'Modo Escuro',
          subtitle: reduceVisualNoise ? null : 'Interface com fundo escuro',
          value: prefs.darkMode,
          onChanged: (value) {
            prefs.setDarkMode(value);
            theme.toggleDarkMode(value);
          },
          semanticsLabel:
              'Modo escuro. ${prefs.darkMode ? "Ativado" : "Desativado"}',
        ),
      ],
    );
  }
}
