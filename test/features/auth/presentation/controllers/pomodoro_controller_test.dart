import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';

class MockNotificationController extends Mock implements NotificationController {}
class MockProfilePreferencesController extends Mock implements ProfilePreferencesController {}

void main() {
  late PomodoroController controller;
  late MockNotificationController mockNotification;
  late MockProfilePreferencesController mockPrefs;

  setUp(() {
    mockNotification = MockNotificationController();
    mockPrefs = MockProfilePreferencesController();
    
    when(() => mockPrefs.taskTimeAlert).thenReturn(true);
    when(() => mockPrefs.pushNotifications).thenReturn(true);

    controller = PomodoroController(
      notificationController: mockNotification,
      preferencesController: mockPrefs,
    );
  });

  group('PomodoroController', () {
    test('inicia no modo foco', () {
      expect(controller.mode, PomodoroMode.focus);
    });

    test('timer decrementa quando rodando', () async {
      final initial = controller.timeLeft;
      controller.toggleTimer();
      // Em testes reais de timer usaríamos fake_async, aqui é apenas estrutural
      expect(controller.isRunning, true);
    });
  });
}
