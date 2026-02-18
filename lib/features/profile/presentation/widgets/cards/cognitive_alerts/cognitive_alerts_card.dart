import 'package:flutter/material.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/toggle_setting_tile/toggle_setting_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

class CognitiveAlertsCard extends StatelessWidget {
  final ProfilePreferencesController controller;

  const CognitiveAlertsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final allowed = controller.complexity.allowedCognitiveAlerts;
        final isSimple = controller.complexity == InterfaceComplexity.simple;

        final canBreakReminder =
            allowed.contains(CognitiveAlertSetting.breakReminder);
        final canTaskTimeAlert =
            allowed.contains(CognitiveAlertSetting.taskTimeAlert);
        final canSmoothTransition =
            allowed.contains(CognitiveAlertSetting.smoothTransition);

        return SettingsSectionCard(
          semanticsLabel: 'Alertas Cognitivos',
          icon: Icons.access_time_outlined,
          title: 'Alertas Cognitivos',
          children: [
            ToggleSettingTile(
              title: 'Lembrete de Pausas',
              subtitle: 'Notifica quando é hora de fazer uma pausa',
              value: controller.breakReminder,
              onChanged: controller.setBreakReminder,
              enabled: canBreakReminder,
              semanticsLabel:
                  'Lembrete de pausas. ${controller.breakReminder ? "Ativado" : "Desativado"}',
            ),
            ToggleSettingTile(
              title: 'Alerta de Tempo na Tarefa',
              subtitle: 'Avisa quando você está muito tempo em uma tarefa',
              value: controller.taskTimeAlert,
              onChanged: controller.setTaskTimeAlert,
              enabled: canTaskTimeAlert,
              disabledReason:
                  isSimple ? 'Disponível no modo Médio/Avançado' : null,
              semanticsLabel:
                  'Alerta de tempo na tarefa. ${controller.taskTimeAlert ? "Ativado" : "Desativado"}',
            ),
            ToggleSettingTile(
              title: 'Transição Suave',
              subtitle: 'Avisos antes de mudar de atividade',
              value: controller.smoothTransition,
              onChanged: controller.setSmoothTransition,
              enabled: canSmoothTransition,
              semanticsLabel:
                  'Transição suave. ${controller.smoothTransition ? "Ativado" : "Desativado"}',
            ),
          ],
        );
      },
    );
  }
}
