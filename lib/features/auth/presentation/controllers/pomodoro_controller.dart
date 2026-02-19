import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/services/notification_service.dart';
import 'package:mindease_focus/shared/services/toast_service.dart';
import 'package:mindease_focus/shared/services/pomodoro_alert_service.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';

enum PomodoroMode { focus, break_ }

class PomodoroController extends ChangeNotifier {
  static const int _focusTime = 25 * 60;
  static const int _breakTime = 5 * 60;

  final NotificationService notificationService;
  final ToastService toastService;
  final PomodoroAlertService alertService;
  final ProfilePreferencesController preferencesController;
  final TaskController taskController;

  PomodoroMode _mode = PomodoroMode.focus;
  int _timeLeft = _focusTime;
  bool _isRunning = false;
  Timer? _timer;

  PomodoroController({
    required this.notificationService,
    required this.toastService,
    required this.alertService,
    required this.preferencesController,
    required this.taskController,
  });

  // Getters
  PomodoroMode get mode => _mode;
  int get timeLeft => _timeLeft;
  bool get isRunning => _isRunning;

  int get totalTime => _mode == PomodoroMode.focus ? _focusTime : _breakTime;
  double get progress => (totalTime - _timeLeft) / totalTime;

  String get formattedTime {
    final m = _timeLeft ~/ 60;
    final s = _timeLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // Métodos públicos
  void toggleTimer() {
    _isRunning = !_isRunning;
    notifyListeners();

    if (_isRunning) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _timeLeft = totalTime;
    notifyListeners();
  }

  void switchMode(PomodoroMode newMode) {
    _timer?.cancel();
    _mode = newMode;
    _isRunning = false;
    _timeLeft = totalTime;
    notifyListeners();
  }

  Future<void> onTimerComplete() async {
    _timer?.cancel();
    _isRunning = false;

    // 1️⃣ Notificação padrão do timer (se pushNotifications estiver ON)
    if (preferencesController.pushNotifications) {
      await _sendTimerNotification();
    }

    // 2️⃣ Se foi um pomodoro de foco, rastrear tempo na tarefa
    if (_mode == PomodoroMode.focus) {
      // Pega a tarefa que está "In Progress"
      final inProgressTasks = taskController.inProgressTasks;
      final currentTask = inProgressTasks.isNotEmpty ? inProgressTasks.first : null;

      if (currentTask != null) {
        alertService.onPomodoroComplete(currentTask.id);

        // Verificar se passou de 4 pomodoros
        if (alertService.shouldShowAlert()) {
          await _sendTaskTimeAlert(currentTask.title);
        }
      }
    }

    notifyListeners();
  }

  /// Envia notificação padrão quando o timer completa
  Future<void> _sendTimerNotification() async {
    final String title;
    final String body;

    if (_mode == PomodoroMode.focus) {
      title = '🎉 Tempo de foco concluído!';
      body = 'Hora de fazer uma pausa!';
    } else {
      title = '✨ Pausa concluída!';
      body = 'Pronto para focar novamente?';
    }

    await notificationService.showPomodoroNotification(
      title: title,
      body: body,
    );
  }

  /// Envia alerta de tempo na tarefa (4+ pomodoros)
  Future<void> _sendTaskTimeAlert(String taskTitle) async {
    final taskTimeAlert = preferencesController.taskTimeAlert;
    final pushNotifications = preferencesController.pushNotifications;

    // Lógica de combinação:
    // - taskTimeAlert ON + pushNotifications ON → Toast + Notificação
    // - taskTimeAlert ON + pushNotifications OFF → Apenas Toast
    // - taskTimeAlert OFF → Não faz nada

    if (taskTimeAlert && pushNotifications) {
      // Toast + Notificação do sistema
      // Nota: Toast precisa de BuildContext, será mostrado na próxima interação do usuário
      await notificationService.showTaskTimeAlert(
        title: '⏰ Alerta de Tempo na Tarefa',
        body: 'Você está há ${alertService.consecutivePomodoros} pomodoros em "$taskTitle". Considere fazer uma pausa ou trocar de tarefa!',
      );

      if (kDebugMode) {
        print('🔔 Alerta enviado: Toast + Notificação (taskTimeAlert: ON, push: ON)');
      }
    } else if (taskTimeAlert && !pushNotifications) {
      // Apenas Toast (será implementado quando houver contexto disponível)
      if (kDebugMode) {
        print('🔔 Alerta enviado: Apenas Toast (taskTimeAlert: ON, push: OFF)');
        print('   Nota: Toast requer BuildContext e será mostrado na UI');
      }
    } else {
      if (kDebugMode) {
        print('🔕 Alerta não enviado (taskTimeAlert: OFF)');
      }
    }
  }

  // Métodos privados
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        onTimerComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
