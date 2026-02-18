import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class DashboardController extends ChangeNotifier {
  bool _welcomeHandled = false;
  bool get welcomeHandled => _welcomeHandled;

  void markWelcomeHandled() {
    if (_welcomeHandled) return;
    _welcomeHandled = true;
    notifyListeners();
  }

  // Futuramente isso viria de UseCases reais
  List<DashboardMetric> getMetrics(List<Task> tasks) {
    final doneCount = tasks.where((t) => t.status == TaskStatus.done).length;
    
    return [
      DashboardMetric(
        title: 'Tarefas Concluídas',
        value: doneCount.toString(),
        subtitle: 'Total no sistema',
        icon: Icons.checklist_rounded,
      ),
      const DashboardMetric(
        title: 'Tempo de Foco',
        value: '3h 45m',
        subtitle: 'Hoje',
        icon: Icons.timer_outlined,
      ),
      const DashboardMetric(
        title: 'Produtividade',
        value: '+24%',
        subtitle: 'vs. semana passada',
        icon: Icons.trending_up_rounded,
      ),
    ];
  }
}

class DashboardMetric {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const DashboardMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}
