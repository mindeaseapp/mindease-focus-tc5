
import 'package:flutter/material.dart';
import '../../tasks/presentation/tasks_page.dart';
import '../../profile/presentation/profile_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MindEase – Painel Cognitivo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Kanban + Pomodoro'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TasksPage()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Perfil Cognitivo'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
