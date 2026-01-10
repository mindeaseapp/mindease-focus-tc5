import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/toggle_setting_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

class FocusModeCard extends StatelessWidget {
  const FocusModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<ProfilePreferencesController>();
    final theme = context.read<ThemeController>();

    // ✅ Hacka: quando "Ocultar distrações" está ON,
    // reduz conteúdo visual (ex.: remove subtítulos).
    final reduceVisualNoise = prefs.hideDistractions;

    return SettingsSectionCard(
      semanticsLabel: 'Modo Foco',
      icon: Icons.visibility_outlined,
      title: 'Modo Foco',
      children: [
        // ✅ Ocultar Distrações (efeito visual IMEDIATO no card)
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

        // ✅ Alto Contraste (reflete globalmente no tema)
        ToggleSettingTile(
          title: 'Alto Contraste',
          subtitle: reduceVisualNoise
              ? null
              : 'Aumenta o contraste para melhor legibilidade',
          value: prefs.highContrast,
          onChanged: (value) {
            prefs.setHighContrast(value);
            theme.toggleHighContrast(value);

            // opcional (se quiser seguir uma regra mais “forte” do hacka):
            // ao ligar alto contraste, também liga "ocultar distrações"
            // para reduzir carga cognitiva.
            // if (value && !prefs.hideDistractions) prefs.setHideDistractions(true);
          },
          semanticsLabel:
              'Alto contraste. ${prefs.highContrast ? "Ativado" : "Desativado"}',
        ),

        // ✅ Modo Escuro (reflete globalmente no tema)
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
