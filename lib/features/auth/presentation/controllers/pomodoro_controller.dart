import 'dart:async';
import 'package:flutter/foundation.dart';

enum PomodoroMode { focus, break_ }

class PomodoroController extends ChangeNotifier {
  static const int _focusTime = 25 * 60;
  static const int _breakTime = 5 * 60;

  PomodoroMode _mode = PomodoroMode.focus;
  int _timeLeft = _focusTime;
  bool _isRunning = false;
  Timer? _timer;

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

  void onTimerComplete() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
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
