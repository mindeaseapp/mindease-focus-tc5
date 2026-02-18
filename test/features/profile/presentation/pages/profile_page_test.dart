
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/profile/presentation/pages/profile_page.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockProfilePreferencesController extends Mock implements ProfilePreferencesController {}
class MockAuthController extends Mock implements AuthController {}
class MockNavigationService extends Mock implements NavigationService {}
class MockFocusModeController extends Mock implements FocusModeController {}
class MockThemeController extends Mock implements ThemeController {}

void main() {
  late MockProfilePreferencesController mockProfilePreferencesController;
  late MockAuthController mockAuthController;
  late MockNavigationService mockNavigationService;
  late MockFocusModeController mockFocusModeController;
  late MockThemeController mockThemeController;

  setUp(() {
    mockProfilePreferencesController = MockProfilePreferencesController();
    mockAuthController = MockAuthController();
    mockNavigationService = MockNavigationService();
    mockFocusModeController = MockFocusModeController();
    mockThemeController = MockThemeController();

    when(() => mockAuthController.user).thenReturn(const UserEntity(id: '1', name: 'Test User', email: 'test@test.com'));
    when(() => mockAuthController.logout()).thenAnswer((_) async {});
    
    when(() => mockProfilePreferencesController.complexity).thenReturn(InterfaceComplexity.medium);
    // displayMode, spacing, fontSize are likely derived or local to the page logic
    when(() => mockProfilePreferencesController.hideDistractions).thenReturn(false);
    when(() => mockProfilePreferencesController.highContrast).thenReturn(false);
    when(() => mockProfilePreferencesController.darkMode).thenReturn(false);
    when(() => mockProfilePreferencesController.breakReminder).thenReturn(true);
    when(() => mockProfilePreferencesController.taskTimeAlert).thenReturn(false);
    when(() => mockProfilePreferencesController.smoothTransition).thenReturn(false);
    when(() => mockProfilePreferencesController.pushNotifications).thenReturn(false);
    when(() => mockProfilePreferencesController.notificationSounds).thenReturn(false);

    when(() => mockFocusModeController.enabled).thenReturn(false);
    
    // ThemeController calls are often buried in widgets if they use Provider directly.
    // ProfilePage uses ProfilePreferencesController which often mirrors Theme. 
    // Checking source: ProfilePage -> FocusModeCard uses FocusModeController.
    // CognitivePanelCard uses local controller.
    // NotificationsCard uses ProfilePreferencesController.
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfilePreferencesController>.value(value: mockProfilePreferencesController),
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        ChangeNotifierProvider<FocusModeController>.value(value: mockFocusModeController),
        Provider<NavigationService>.value(value: mockNavigationService),
         // ThemeController might be needed if widgets down the tree consume it.
         ChangeNotifierProvider<ThemeController>.value(value: mockThemeController),
      ],
      child: MaterialApp(
        onGenerateRoute: null,
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Page')),
          '/dashboard': (_) => const Scaffold(body: Text('Dashboard Page')),
          '/tasks': (_) => const Scaffold(body: Text('Tasks Page')),
        },
        home: const ProfilePage(),
      ),
    );
  }

  group('ProfilePage', () {
    testWidgets('renders correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test User').first, findsOneWidget);
      expect(find.text('test@test.com').first, findsOneWidget);
      expect(find.text('Informações Pessoais'), findsOneWidget);
      expect(find.text('Sair da Conta'), findsOneWidget);
    });

    testWidgets('calls logout on button press', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());

       await tester.ensureVisible(find.text('Sair da Conta'));
       await tester.tap(find.text('Sair da Conta'), warnIfMissed: false);
       await tester.pump();

       verify(() => mockAuthController.logout()).called(1);
    });
  });
}
