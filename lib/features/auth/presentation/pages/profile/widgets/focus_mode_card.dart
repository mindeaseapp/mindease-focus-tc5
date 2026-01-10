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

    return SettingsSectionCard(
      semanticsLabel: 'Modo Foco',
      icon: Icons.visibility_outlined,
      title: 'Modo Foco',
      children: [
        // ✅ Regra Hacka: "reduzir estímulos visuais"
        // Efeito visual é aplicado em widgets que leem prefs.hideDistractions
        ToggleSettingTile(
          title: 'Ocultar Distrações',
          subtitle: 'Remove elementos não essenciais da interface',
          value: prefs.hideDistractions,
          onChanged: prefs.setHideDistractions,
          semanticsLabel:
              'Ocultar distrações. ${prefs.hideDistractions ? "Ativado" : "Desativado"}',
        ),

        // ✅ Regra Hacka: "alto contraste" precisa refletir visualmente
        ToggleSettingTile(
          title: 'Alto Contraste',
          subtitle: 'Aumenta o contraste para melhor legibilidade',
          value: prefs.highContrast,
          onChanged: (value) {
            // 1) salva a preferência
            prefs.setHighContrast(value);

            // 2) aplica no app (tema global)
            theme.toggleHighContrast(value);

            // (opcional) se quiser: ao ligar alto contraste, desliga gradiente também?
            // Isso fica a seu critério, mas pode ajudar acessibilidade.
            // if (value && !prefs.hideDistractions) prefs.setHideDistractions(true);
          },
          semanticsLabel:
              'Alto contraste. ${prefs.highContrast ? "Ativado" : "Desativado"}',
        ),

        // ✅ Regra: modo escuro é global (MaterialApp.themeMode)
        ToggleSettingTile(
          title: 'Modo Escuro',
          subtitle: 'Interface com fundo escuro',
          value: prefs.darkMode,
          onChanged: (value) {
            // 1) salva a preferência
            prefs.setDarkMode(value);

            // 2) aplica no app (tema global)
            theme.toggleDarkMode(value);
          },
          semanticsLabel: 'Modo escuro. ${prefs.darkMode ? "Ativado" : "Desativado"}',
        ),
      ],
    );
  }
}
