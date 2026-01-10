import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ ADICIONE ISSO

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel_models.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/toggle_setting_tile.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';

class NotificationsCard extends StatelessWidget {
  final ProfilePreferencesController controller;

  const NotificationsCard({super.key, required this.controller});

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final allowed = controller.complexity.allowedNotifications;

        final canPush = allowed.contains(NotificationSetting.pushNotifications);

        // ✅ Sons só fazem sentido se:
        // - a complexidade permitir
        // - push estiver ligado
        final canSoundsByComplexity =
            allowed.contains(NotificationSetting.notificationSounds);
        final canSounds = canSoundsByComplexity && controller.pushNotifications;

        final String? soundsDisabledReason = !canSoundsByComplexity
            ? 'Disponível no modo Médio/Avançado'
            : (!controller.pushNotifications
                ? 'Ative as notificações push para habilitar sons'
                : null);

        return SettingsSectionCard(
          semanticsLabel: 'Notificações',
          icon: Icons.notifications_none_outlined,
          title: 'Notificações',
          children: [
            // ==========================
            // Push Notifications
            // ==========================
            ToggleSettingTile(
              title: 'Notificações Push',
              subtitle: 'Receba notificações no navegador',
              value: controller.pushNotifications,
              enabled: canPush,
              onChanged: (v) {
                controller.setPushNotifications(v);

                _showSnack(
                  context,
                  v
                      ? '✅ Notificações push ativadas'
                      : '🛑 Notificações push desativadas',
                );

                // opcional: se desligar push, seu controller já desliga sons.
                if (!v && controller.notificationSounds) {
                  _showSnack(context, '🔇 Sons desativados (push desligado)');
                }
              },
              semanticsLabel:
                  'Notificações push. ${controller.pushNotifications ? "Ativado" : "Desativado"}',
            ),

            // ==========================
            // Notification Sounds
            // ==========================
            ToggleSettingTile(
              title: 'Sons de Notificação',
              subtitle: 'Toque um som ao receber notificações',
              value: controller.notificationSounds,
              enabled: canSounds,
              disabledReason: soundsDisabledReason,
              onChanged: (v) {
                controller.setNotificationSounds(v);

                if (v) {
                  // ✅ feedback imediato (sem plugin)
                  SystemSound.play(SystemSoundType.click);
                }

                _showSnack(
                  context,
                  v ? '🔔 Sons de notificação ativados' : '🔕 Sons de notificação desativados',
                );
              },
              semanticsLabel:
                  'Sons de notificação. ${controller.notificationSounds ? "Ativado" : "Desativado"}',
            ),
          ],
        );
      },
    );
  }
}
