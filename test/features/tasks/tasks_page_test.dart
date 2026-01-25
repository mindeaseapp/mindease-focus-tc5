import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';

import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';


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
