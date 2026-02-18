
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';

void main() {
  late PomodoroController controller;

  setUp(() {
    controller = PomodoroController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('PomodoroController', () {
    test('initial state should be focus mode', () {
      expect(controller.mode, PomodoroMode.focus);
      expect(controller.timeLeft, 25 * 60);
      expect(controller.isRunning, false);
      expect(controller.progress, 0.0);
    });

    test('toggleTimer should start and stop timer', () {
      controller.toggleTimer();
      expect(controller.isRunning, true);

      controller.toggleTimer();
      expect(controller.isRunning, false);
    });

    test('resetTimer should reset time and stop timer', () {
      controller.toggleTimer();
      controller.resetTimer();

      expect(controller.isRunning, false);
      expect(controller.timeLeft, 25 * 60);
    });

    test('switchMode should change mode and reset timer', () {
      controller.switchMode(PomodoroMode.break_);
      
      expect(controller.mode, PomodoroMode.break_);
      expect(controller.timeLeft, 5 * 60);
      expect(controller.isRunning, false);
    });

    test('formattedTime should return correct string', () {
      expect(controller.formattedTime, '25:00');
    });
  });
}
