
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/tasks/presentation/pages/tasks_page.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class MockTaskController extends Mock implements TaskController {}
class MockAuthController extends Mock implements AuthController {}
class MockFocusModeController extends Mock implements FocusModeController {}
class MockProfilePreferencesController extends Mock implements ProfilePreferencesController {}
class MockNavigationService extends Mock implements NavigationService {}
class MockPomodoroController extends Mock implements PomodoroController {}

void main() {
  late MockTaskController mockTaskController;
  late MockAuthController mockAuthController;
  late MockFocusModeController mockFocusModeController;
  late MockProfilePreferencesController mockProfilePreferencesController;
  late MockNavigationService mockNavigationService;
  late MockPomodoroController mockPomodoroController;

  setUp(() {
    mockTaskController = MockTaskController();
    mockAuthController = MockAuthController();
    mockFocusModeController = MockFocusModeController();
    mockProfilePreferencesController = MockProfilePreferencesController();
    mockNavigationService = MockNavigationService();
    mockPomodoroController = MockPomodoroController();

    when(() => mockTaskController.tasks).thenReturn([
      const Task(id: '1', title: 'Task 1', status: TaskStatus.todo),
    ]);
    when(() => mockTaskController.isLoading).thenReturn(false);
    when(() => mockTaskController.error).thenReturn(null);
    when(() => mockTaskController.loadTasks()).thenAnswer((_) async {});
    
    when(() => mockAuthController.user).thenReturn(const UserEntity(id: '1', name: 'Test User', email: 'test@test.com'));
    
    when(() => mockFocusModeController.enabled).thenReturn(false);
    
    when(() => mockProfilePreferencesController.highContrast).thenReturn(false);
    when(() => mockProfilePreferencesController.hideDistractions).thenReturn(false);

    when(() => mockPomodoroController.timeLeft).thenReturn(25 * 60);
    when(() => mockPomodoroController.formattedTime).thenReturn('25:00');
    when(() => mockPomodoroController.isRunning).thenReturn(false);
    when(() => mockPomodoroController.mode).thenReturn(PomodoroMode.focus);
    when(() => mockPomodoroController.progress).thenReturn(0.0);
    
    // Add missing totalTime getter mock if needed by progress calculation or UI
    when(() => mockPomodoroController.totalTime).thenReturn(1500);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskController>.value(value: mockTaskController),
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        ChangeNotifierProvider<FocusModeController>.value(value: mockFocusModeController),
        ChangeNotifierProvider<ProfilePreferencesController>.value(value: mockProfilePreferencesController),
        ChangeNotifierProvider<PomodoroController>.value(value: mockPomodoroController),
        Provider<NavigationService>.value(value: mockNavigationService),
      ],
      child: const MaterialApp(
        home: TasksPage(),
      ),
    );
  }

  group('TasksPage', () {
    testWidgets('renders tabs (Focus and Tasks)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Foco').first, findsOneWidget);
      expect(find.text('Tarefas').first, findsOneWidget);
    });

    testWidgets('renders Pomodoro timer in Focus tab', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
       await tester.pumpAndSettle();

       // Should start on first tab (Focus) default
       expect(find.text('Seu tempo de foco'), findsOneWidget);
       expect(find.text('25:00'), findsOneWidget); // Default pomodoro mocked
    });

    testWidgets('renders Kanban in Tasks tab', (tester) async {
       tester.view.physicalSize = const Size(1600, 1000);
       tester.view.devicePixelRatio = 1.0;
       addTearDown(tester.view.resetPhysicalSize);

       await tester.pumpWidget(createWidgetUnderTest());
       await tester.pumpAndSettle();

       await tester.tap(find.text('Tarefas').first);
       await tester.pumpAndSettle();

       // Check if KanbanBoard is present (it has columns Todo, Doing, Done)
       // We can check by text if standard
       expect(find.byType(ListView), findsOneWidget); // KanbanBoard uses scrollable
       // Or verify loadTasks called
       verify(() => mockTaskController.loadTasks()).called(1); // Once on init
       // It seems loadTasks is called in _KanbanTabContent initState too?
       // Yes.
    });
    
    testWidgets('shows loading indicator when tasks loading', (tester) async {
       tester.view.physicalSize = const Size(1600, 1000);
       tester.view.devicePixelRatio = 1.0;
       addTearDown(tester.view.resetPhysicalSize);

       when(() => mockTaskController.isLoading).thenReturn(true);
       when(() => mockTaskController.tasks).thenReturn([]);
       
       await tester.pumpWidget(createWidgetUnderTest());
       await tester.pumpAndSettle();

       await tester.tap(find.widgetWithText(Tab, 'Tarefas'));
       await tester.pump(const Duration(milliseconds: 200)); // Start animation
       await tester.pump(const Duration(milliseconds: 200)); // Mid animation
       await tester.pump(const Duration(seconds: 1)); // Finish animation
       
       expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message if tasks fail to load', (tester) async {
       tester.view.physicalSize = const Size(1600, 1000);
       tester.view.devicePixelRatio = 1.0;
       addTearDown(tester.view.resetPhysicalSize);

       when(() => mockTaskController.error).thenReturn('Failed to load tasks');
       
       await tester.pumpWidget(createWidgetUnderTest());
       await tester.pumpAndSettle();

       await tester.tap(find.descendant(of: find.byType(TabBar), matching: find.text('Tarefas')));
       await tester.pumpAndSettle();

       expect(find.text('Failed to load tasks'), findsOneWidget);
    });
  });
}
