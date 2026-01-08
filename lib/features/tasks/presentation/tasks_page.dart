import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/presentation/pomodoro_widget.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kanban Cognitivo')),
      body: const Column(
        children: [
          Expanded(
            child: Row(
              children: [
                KanbanColumn(title: 'A Fazer'),
                KanbanColumn(title: 'Fazendo'),
                KanbanColumn(title: 'Concluído'),
              ],
            ),
          ),
          PomodoroWidget(),
        ],
      ),
    );
  }
}

class KanbanColumn extends StatelessWidget {
  final String title;
  const KanbanColumn({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text('Tarefa exemplo'),
            ),
          )
        ],
      ),
    );
  }
}