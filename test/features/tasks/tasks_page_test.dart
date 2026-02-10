import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';

import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel/cognitive_panel_models.dart';


class FakeAuthController extends ChangeNotifier implements AuthController {
  final UserEntity _user =
      const UserEntity(id: '1', name: 'Teste User', email: 'teste@email.com');

  @override
  UserEntity get user => _user;

  @override
  bool get isAuthenticated => true;

  @override
  Future<void> logout() async {}

  @override
  Future<void> refreshUser() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFocusModeController extends ChangeNotifier
    implements FocusModeController {
  bool _enabled;

  FakeFocusModeController({bool enabled = false}) : _enabled = enabled;

  @override
  bool get enabled => _enabled;

  @override
  void setEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  @override
  void toggle() => setEnabled(!enabled);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTaskController extends ChangeNotifier implements TaskController {
  bool _isLoading = false;
  String? _error;
  final List<Task> _tasks = <Task>[];

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  @override
  List<Task> get tasks => _tasks;

  @override
  List<Task> get todoTasks =>
      _tasks.where((t) => t.status == TaskStatus.todo).toList();

  @override
  List<Task> get inProgressTasks =>
      _tasks.where((t) => t.status == TaskStatus.inProgress).toList();

  @override
  List<Task> get doneTasks =>
      _tasks.where((t) => t.status == TaskStatus.done).toList();

  @override
  Future<void> loadTasks() async {
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  @override
  Future<void> addTask(
    String title,
    String description, {
    TaskStatus status = TaskStatus.todo,
  }) async {
    notifyListeners();
  }

  @override
  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    notifyListeners();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePomodoroController extends ChangeNotifier implements PomodoroController {
  PomodoroMode _mode = PomodoroMode.focus;
  int _timeLeft = 25 * 60;
  bool _isRunning = false;

  @override
  PomodoroMode get mode => _mode;

  @override
  int get timeLeft => _timeLeft;

  @override
  bool get isRunning => _isRunning;

  @override
  int get totalTime => _mode == PomodoroMode.focus ? 25 * 60 : 5 * 60;

  @override
  double get progress => (totalTime - _timeLeft) / totalTime;

  @override
  String get formattedTime => '25:00';

  @override
  void toggleTimer() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  @override
  void resetTimer() {
    _isRunning = false;
    _timeLeft = totalTime;
    notifyListeners();
  }

  @override
  void switchMode(PomodoroMode newMode) {
    _mode = newMode;
    _timeLeft = totalTime;
    notifyListeners();
  }

  @override
  void onTimerComplete() {
     _isRunning = false;
     notifyListeners();
  }
  
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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TasksPage renderiza header e tab Pomodoro', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>.value(
            value: FakeAuthController(),
          ),
          ChangeNotifierProvider<FocusModeController>.value(
            value: FakeFocusModeController(enabled: false),
          ),
          ChangeNotifierProvider<TaskController>.value(
            value: FakeTaskController(),
          ),
          ChangeNotifierProvider<PomodoroController>.value(
            value: FakePomodoroController(),
          ),
          ChangeNotifierProvider<ProfilePreferencesController>.value(
            value: FakeProfilePreferencesController(),
          ),
        ],
        child: const MaterialApp(
          home: TasksPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Teste User'), findsAtLeastNWidgets(1));

    expect(find.text('Foco'), findsAtLeastNWidgets(1));
    expect(find.text('Tarefas'), findsAtLeastNWidgets(1));

    expect(find.text('Seu tempo de foco'), findsOneWidget);

    expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);
  });
}
