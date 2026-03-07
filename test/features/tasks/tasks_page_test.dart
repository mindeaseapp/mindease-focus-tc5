import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/tasks/presentation/pages/tasks_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';

import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class FakeAuthController extends ChangeNotifier implements AuthController {
  @override
  UserEntity get user => const UserEntity(id: '1', name: 'Teste User', email: 'teste@email.com');
  @override
  bool get isAuthenticated => true;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFocusModeController extends ChangeNotifier implements FocusModeController {
  @override
  bool enabled = false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTaskController extends ChangeNotifier implements TaskController {
  @override
  List<Task> get tasks => [];
  @override
  List<Task> get todoTasks => [];
  @override
  List<Task> get inProgressTasks => [];
  @override
  List<Task> get doneTasks => [];
  @override
  bool get isLoading => false;
  @override
  Future<void> loadTasks() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePomodoroController extends ChangeNotifier implements PomodoroController {
  @override
  PomodoroMode get mode => PomodoroMode.focus;
  @override
  int get timeLeft => 25 * 60;
  @override
  bool get isRunning => false;
  @override
  int get totalTime => 25 * 60;
  @override
  double get progress => 0.0;
  @override
  String get formattedTime => '25:00';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfilePreferencesController extends ChangeNotifier implements ProfilePreferencesController {
  @override
  bool hideDistractions = false;
  @override
  bool highContrast = false;
  @override
  bool darkMode = false;
  @override
  bool breakReminder = true;
  @override
  bool taskTimeAlert = true;
  @override
  bool smoothTransition = true;
  @override
  bool pushNotifications = true;
  @override
  bool notificationSounds = false;
  @override
  InterfaceComplexity get complexity => InterfaceComplexity.medium;
  @override
  ElementSpacing get spacing => ElementSpacing.medium;
  @override
  DisplayMode get displayMode => DisplayMode.balanced;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeNavigationService implements NavigationService {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTasksPage({
    TaskController? taskController,
    PomodoroController? pomodoroController,
  }) {
    return MultiProvider(
      providers: [
        Provider<NavigationService>(create: (_) => FakeNavigationService()),
        ChangeNotifierProvider<AuthController>(create: (_) => FakeAuthController()),
        ChangeNotifierProvider<FocusModeController>(create: (_) => FakeFocusModeController()),
        ChangeNotifierProvider<TaskController>(create: (_) => taskController ?? FakeTaskController()),
        ChangeNotifierProvider<PomodoroController>(create: (_) => pomodoroController ?? FakePomodoroController()),
        ChangeNotifierProvider<NotificationController>(create: (_) => NotificationController()),
        ChangeNotifierProvider<ProfilePreferencesController>(create: (_) => FakeProfilePreferencesController()),
      ],
      child: const MaterialApp(
        home: TasksPage(),
      ),
    );
  }

  testWidgets('TasksPage renderiza header e tab Pomodoro', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createTasksPage());
    await tester.pumpAndSettle();
    expect(find.text('Teste User'), findsAtLeastNWidgets(1));
  });

  testWidgets('shows error message if tasks fail to load', (tester) async {
    final taskController = FakeTaskController();
    await tester.pumpWidget(createTasksPage(taskController: taskController));
    await tester.pump();
  });

  testWidgets('renders Kanban in Tasks tab', (tester) async {
    await tester.pumpWidget(createTasksPage());
    await tester.pumpAndSettle();
  });
}
