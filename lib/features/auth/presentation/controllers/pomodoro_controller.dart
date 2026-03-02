import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/notifications/data/services/notification_service.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';

enum PomodoroMode { focus, break_ }

class PomodoroController extends ChangeNotifier {
  static const int _focusTime = 25 * 60;
  static const int _breakTime = 5 * 60;

  final NotificationController? _notificationController;
  final ProfilePreferencesController? _preferencesController;
  final TaskController? _taskController;
  String? _currentTaskId;

  PomodoroMode _mode = PomodoroMode.focus;
  int _timeLeft = _focusTime;
  bool _isRunning = false;
  Timer? _timer;

  PomodoroController({
    NotificationController? notificationController,
    ProfilePreferencesController? preferencesController,
    TaskController? taskController,
  })  : _notificationController = notificationController,
        _preferencesController = preferencesController,
        _taskController = taskController;

  // ── Getters ────────────────────────────────────────────────────────────────

  PomodoroMode get mode => _mode;
  int get timeLeft => _timeLeft;
  bool get isRunning => _isRunning;
  String? get currentTaskId => _currentTaskId;
  int get totalTime => _mode == PomodoroMode.focus ? _focusTime : _breakTime;
  double get progress => (totalTime - _timeLeft) / totalTime;

  String get formattedTime {
    final m = _timeLeft ~/ 60;
    final s = _timeLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void setCurrentTask(String? taskId) {
    _currentTaskId = taskId;
    notifyListeners();
  }

  // ── Controle do Timer ──────────────────────────────────────────────────────

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

  /// Chamado quando o timer chega a zero (pelo _startTimer ou em testes).
  void onTimerComplete() {
    _timer?.cancel();
    _isRunning = false;

    _handleCompletionAlerts();

    if (_mode == PomodoroMode.focus && _currentTaskId != null) {
      _taskController?.incrementPomodoroCount(
        _currentTaskId!,
        notificationController: _notificationController,
        taskTimeAlertEnabled: _preferencesController?.taskTimeAlert ?? true,
        pushNotificationsEnabled: _preferencesController?.pushNotifications ?? false,
      );
    }

    notifyListeners();
  }

  // ── Alertas de conclusão ───────────────────────────────────────────────────

  /// Lógica de negócio:
  ///   taskTimeAlert=ON  → sininho in-app
  ///   pushNotifications=ON → notificação nativa do SO / browser
  ///   Ambos OFF → silêncio
  void _handleCompletionAlerts() {
    final prefs = _preferencesController;
    if (prefs == null) return;
    if (!prefs.taskTimeAlert && !prefs.pushNotifications) return;

    final isFocus = _mode == PomodoroMode.focus;
    final title = isFocus ? '🎉 Foco concluído!' : '✨ Pausa concluída!';
    final body = isFocus
        ? 'Excelente trabalho! Hora de descansar um pouco.'
        : 'Descanso finalizado. Pronto para a próxima sessão?';

    // Sininho in-app
    if (prefs.taskTimeAlert) {
      _notificationController?.addNotification(title: title, body: body);

      // Push do sistema (Android / iOS / Desktop / Web)
      // Conforme regra: Push só dispara se Alerta de Tempo estiver ON.
      if (prefs.pushNotifications) {
        // ignore: unawaited_futures
        NotificationService()
            .showNotification(
              id: isFocus ? 1 : 2,
              title: title,
              body: body,
            )
            .catchError((_) {
          // Silencia erros de plataforma não inicializada (ex: testes)
        });
      }
    }
  }

  // ── Internos ───────────────────────────────────────────────────────────────

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
