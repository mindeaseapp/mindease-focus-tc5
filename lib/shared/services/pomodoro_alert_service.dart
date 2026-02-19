import 'package:flutter/foundation.dart';

/// Serviço para rastrear pomodoros consecutivos na mesma tarefa
/// e disparar alertas quando passar de 4 pomodoros
class PomodoroAlertService {
  String? _currentTaskId;
  int _consecutivePomodoros = 0;

  /// Chame isso quando um pomodoro de foco completa
  /// [taskId] - ID da tarefa que está "In Progress"
  void onPomodoroComplete(String? taskId) {
    if (taskId == null) {
      // Sem tarefa ativa, não rastreia
      if (kDebugMode) {
        print('PomodoroAlertService: Nenhuma tarefa ativa');
      }
      return;
    }

    if (_currentTaskId != taskId) {
      // Trocou de tarefa, resetar contador
      _currentTaskId = taskId;
      _consecutivePomodoros = 1;
      if (kDebugMode) {
        print('PomodoroAlertService: Nova tarefa $_currentTaskId - Contador: 1');
      }
    } else {
      // Mesma tarefa, incrementar
      _consecutivePomodoros++;
      if (kDebugMode) {
        print('PomodoroAlertService: Tarefa $_currentTaskId - Contador: $_consecutivePomodoros');
      }
    }
  }

  /// Retorna true se passou de 4 pomodoros consecutivos
  bool shouldShowAlert() {
    final shouldAlert = _consecutivePomodoros > 4;
    if (kDebugMode && shouldAlert) {
      print('PomodoroAlertService: ⚠️ ALERTA! Passou de 4 pomodoros ($_consecutivePomodoros)');
    }
    return shouldAlert;
  }

  /// Reseta o contador (útil quando finalizar tarefa ou trocar manualmente)
  void reset() {
    if (kDebugMode) {
      print('PomodoroAlertService: Reset - Tarefa: $_currentTaskId, Contador: $_consecutivePomodoros');
    }
    _currentTaskId = null;
    _consecutivePomodoros = 0;
  }

  /// Getter para número de pomodoros consecutivos
  int get consecutivePomodoros => _consecutivePomodoros;

  /// Getter para ID da tarefa atual
  String? get currentTaskId => _currentTaskId;
}
