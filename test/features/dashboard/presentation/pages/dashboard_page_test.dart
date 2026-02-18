
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mindease_focus/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockDashboardController extends Mock implements DashboardController {}
class MockTaskController extends Mock implements TaskController {}
class MockAuthController extends Mock implements AuthController {}
class MockFocusModeController extends Mock implements FocusModeController {}
class MockProfilePreferencesController extends Mock implements ProfilePreferencesController {}
class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockDashboardController mockDashboardController;
  late MockTaskController mockTaskController;
  late MockAuthController mockAuthController;
  late MockFocusModeController mockFocusModeController;
  late MockProfilePreferencesController mockProfilePreferencesController;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockDashboardController = MockDashboardController();
    mockTaskController = MockTaskController();
    mockAuthController = MockAuthController();
    mockFocusModeController = MockFocusModeController();
    mockProfilePreferencesController = MockProfilePreferencesController();
    mockNavigationService = MockNavigationService();

    // Default stubs
    when(() => mockDashboardController.welcomeHandled).thenReturn(true);
    when(() => mockDashboardController.getMetrics(any())).thenReturn([]);
    
    when(() => mockTaskController.tasks).thenReturn([]);
    when(() => mockTaskController.loadTasks()).thenAnswer((_) async {});
    
    when(() => mockAuthController.user).thenReturn(const UserEntity(id: '1', name: 'Test User', email: 'test@test.com'));
    
    when(() => mockFocusModeController.enabled).thenReturn(false);
    
    when(() => mockProfilePreferencesController.highContrast).thenReturn(false);
    when(() => mockProfilePreferencesController.hideDistractions).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardController>.value(value: mockDashboardController),
        ChangeNotifierProvider<TaskController>.value(value: mockTaskController),
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        ChangeNotifierProvider<FocusModeController>.value(value: mockFocusModeController),
        ChangeNotifierProvider<ProfilePreferencesController>.value(value: mockProfilePreferencesController),
        Provider<NavigationService>.value(value: mockNavigationService),
      ],
      child: const MaterialApp(
        home: DashboardPage(),
      ),
    );
  }

  group('DashboardPage', () {
    testWidgets('renders correctly', (tester) async {
       // Mock specific metrics to verify rendering
       when(() => mockDashboardController.getMetrics(any())).thenReturn([
         DashboardMetric(title: 'Tasks Done', value: '5', subtitle: 'Great job', icon: Icons.check)
       ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Post frame callback

      expect(find.text('Dashboard').first, findsOneWidget);
      expect(find.text('Bem-vindo de volta! Aqui está seu resumo de hoje.'), findsOneWidget);
      expect(find.text('Tasks Done'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      
      // Verify TaskController.loadTasks called
      verify(() => mockTaskController.loadTasks()).called(1);
    });

    testWidgets('hides distractions when preference enabled', (tester) async {
      when(() => mockProfilePreferencesController.hideDistractions).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo de volta! Aqui está seu resumo de hoje.'), findsNothing);
    });

    testWidgets('shows focus mode banner', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Modo Foco Ativo'), findsOneWidget);
      expect(find.text('Configurar'), findsOneWidget);
    });

    testWidgets('shows recent tasks', (tester) async {
      when(() => mockTaskController.tasks).thenReturn([
        Task(id: '1', title: 'Task 1', status: TaskStatus.todo),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Tarefas Recentes'), findsOneWidget);
      expect(find.text('Task 1'), findsOneWidget);
    });

    testWidgets('adapts to focus mode enabled', (tester) async {
      when(() => mockFocusModeController.enabled).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Should hide some elements like metrics
      // Code: if (!isFocusMode) ... [MetricsGrid, RecentTasks, etc]
      // Metrics are mocked to return empty list usually, but if enabled=true, grid shouldn't be built.
      
      expect(find.text('Modo Foco Ativo'), findsOneWidget);
      // Actually FocusBanner uses Container.
      // MetricsGrid uses Card. RecentTasks uses Card.
      // If focus mode enabled, only FocusBanner is shown?
      
      // Let's check text that only appears in normal mode
      expect(find.text('Tarefas Recentes'), findsNothing);
      expect(find.text('Dica do Dia'), findsNothing);
    });
  });
}
