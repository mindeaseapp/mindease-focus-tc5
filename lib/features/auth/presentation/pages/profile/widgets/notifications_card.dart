import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/toggle_setting_tile.dart';

class NotificationsCard extends StatelessWidget {
  final ProfilePreferencesController controller;

  const NotificationsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return SettingsSectionCard(
          semanticsLabel: 'Notificações',
          icon: Icons.notifications_none_outlined,
          title: 'Notificações',
          children: [
            ToggleSettingTile(
              title: 'Notificações Push',
              subtitle: 'Receba notificações no navegador',
              value: controller.pushNotifications,
              onChanged: controller.setPushNotifications,
              semanticsLabel:
                  'Notificações push. ${controller.pushNotifications ? "Ativado" : "Desativado"}',
            ),
            ToggleSettingTile(
              title: 'Sons de Notificação',
              subtitle: 'Toque um som ao receber notificações',
              value: controller.notificationSounds,
              onChanged: controller.setNotificationSounds,
              semanticsLabel:
                  'Sons de notificação. ${controller.notificationSounds ? "Ativado" : "Desativado"}',
            ),
          ],
        );
      },
    );
  }
}
