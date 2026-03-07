import 'package:flutter/material.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_styles.dart';

class DashboardController extends ChangeNotifier {
  bool _welcomeHandled = false;
  bool get welcomeHandled => _welcomeHandled;

  void markWelcomeHandled() {
    if (_welcomeHandled) return;
    _welcomeHandled = true;
    notifyListeners();
  }

  List<DashboardMetric> getMetrics(List<Task> tasks) {
    final total = tasks.length;
    final pendingCount = tasks.where((t) => t.status == TaskStatus.todo).length;
    final inProgressCount = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final doneCount = tasks.where((t) => t.status == TaskStatus.done).length;

    String motivationalValue;
    String motivationalSubtitle;

    if (total == 0) {
      motivationalValue = '🚀';
      motivationalSubtitle = 'Crie sua primeira tarefa!';
    } else if (doneCount == total) {
      motivationalValue = '🎉';
      motivationalSubtitle = 'Todas as tarefas concluídas!';
    } else if (doneCount > total / 2) {
      motivationalValue = '🔥';
      motivationalSubtitle = 'Continue assim, falta pouco!';
    } else if (inProgressCount > 0) {
      motivationalValue = '💪';
      motivationalSubtitle = 'Você está no caminho certo!';
    } else {
      motivationalValue = '⏳';
      motivationalSubtitle = 'Hora de começar!';
    }

    return [
      DashboardMetric(
        kind: DashboardMetricKind.done,
        title: 'Pendentes',
        value: (pendingCount + inProgressCount).toString(),
        subtitle: '$pendingCount a fazer · $inProgressCount em andamento',
        icon: Icons.assignment_outlined,
      ),
      DashboardMetric(
        kind: DashboardMetricKind.focus,
        title: 'Concluídas',
        value: doneCount.toString(),
        subtitle: total > 0 ? '${(doneCount * 100 ~/ total)}% do total' : 'Nenhuma tarefa',
        icon: Icons.check_circle_outline_rounded,
      ),
      DashboardMetric(
        kind: DashboardMetricKind.productivity,
        title: 'Motivação',
        value: motivationalValue,
        subtitle: motivationalSubtitle,
        icon: Icons.emoji_events_outlined,
      ),
    ];
  }
}

class DashboardMetric {
  final DashboardMetricKind kind;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const DashboardMetric({
    required this.kind,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}

