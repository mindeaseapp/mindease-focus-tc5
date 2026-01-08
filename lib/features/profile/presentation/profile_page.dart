import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/shared/controllers/theme_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Cognitivo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile(
            title: const Text('Modo Escuro'),
            subtitle: const Text('Interface com fundo escuro'),
            value: theme.isDark,
            onChanged: theme.toggleDarkMode,
          ),
        ],
      ),
    );
  }
}
