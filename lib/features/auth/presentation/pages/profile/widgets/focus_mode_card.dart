import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/toggle_setting_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

class FocusModeCard extends StatelessWidget {
  final ProfilePreferencesController controller;

  const FocusModeCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SettingsSectionCard(
          semanticsLabel: 'Modo Foco',
          icon: Icons.visibility_outlined,
          title: 'Modo Foco',
          children: [
            ToggleSettingTile(
              title: 'Ocultar Distrações',
              subtitle: 'Remove elementos não essenciais da interface',
              value: controller.hideDistractions,
              onChanged: controller.setHideDistractions,
              semanticsLabel:
                  'Ocultar distrações. ${controller.hideDistractions ? "Ativado" : "Desativado"}',
            ),
            ToggleSettingTile(
              title: 'Alto Contraste',
              subtitle: 'Aumenta o contraste para melhor legibilidade',
              value: controller.highContrast,
              onChanged: controller.setHighContrast,
              semanticsLabel:
                  'Alto contraste. ${controller.highContrast ? "Ativado" : "Desativado"}',
            ),

            // ✅ DARK MODE (preferências + tema global)
            ToggleSettingTile(
              title: 'Modo Escuro',
              subtitle: 'Interface com fundo escuro',
              value: controller.darkMode,
              onChanged: (value) {
                // 1) salva no controller local (preferências)
                controller.setDarkMode(value);

                // 2) alterna o tema global do app
                context.read<ThemeController>().toggleDarkMode(value);
              },
              semanticsLabel:
                  'Modo escuro. ${controller.darkMode ? "Ativado" : "Desativado"}',
            ),
          ],
        );
      },
    );
  }
}
