
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil Cognitivo')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ListTile(title: Text('Modo Foco Preferido')),
          ListTile(title: Text('Nível de Complexidade')),
          ListTile(title: Text('Espaçamento e Fonte')),
        ],
      ),
    );
  }
}
