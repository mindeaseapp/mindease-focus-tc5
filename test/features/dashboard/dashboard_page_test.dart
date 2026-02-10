import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/dashboard/dashboard_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/models/task_model.dart';
import 'package:mindease_focus/features/auth/data/repositories/task_repository.dart';

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
  @override
  bool enabled;

  FakeFocusModeController({this.enabled = false});

  @override
  void setEnabled(bool value) {
    enabled = value;
    notifyListeners();
  }

  @override
  void toggle() => setEnabled(!enabled);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTaskController extends ChangeNotifier implements TaskController {
  @override
  List<Task> get tasks => [
        const Task(
          id: '1',
          title: 'Mock Task 1',
          status: TaskStatus.todo,
        ),
        const Task(
          id: '2',
          title: 'Mock Task 2',
          status: TaskStatus.done,
        ),
      ];

  @override
  bool get isLoading => false;

  @override
  Future<void> loadTasks() async {}

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

  testWidgets('DashboardPage renderiza elementos principais',
      (WidgetTester tester) async {
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
          ChangeNotifierProvider<ProfilePreferencesController>.value(
            value: FakeProfilePreferencesController(),
          ),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pump(); 
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
    expect(
      find.text('Bem-vindo de volta! Aqui está seu resumo de hoje.'),
      findsOneWidget,
    );
    expect(find.text('Tarefas Recentes'), findsOneWidget);
    expect(find.text('Mock Task 1'), findsOneWidget); 
    
    expect(find.text('Dica do Dia'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);
  });
}
