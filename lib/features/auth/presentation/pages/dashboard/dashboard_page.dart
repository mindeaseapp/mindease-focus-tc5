import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindEase – Painel Cognitivo'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: null,
              child: Text('Kanban + Pomodoro'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: null,
              child: Text('Perfil Cognitivo'),
            ),
          ],
        ),
      ),
    );
  }
}