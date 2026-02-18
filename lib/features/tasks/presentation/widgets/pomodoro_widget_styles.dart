
class PomodoroWidgetStyles {
  // Defaults
  static const int initialSeconds = 1500;
  static const Duration tick = Duration(seconds: 1);

  // UI
  static const String buttonLabel = 'Iniciar Foco';

  static String timeLabel(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return 'Foco: $m:$s';
  }
}
