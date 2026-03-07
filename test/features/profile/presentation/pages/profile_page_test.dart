import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/features/profile/presentation/pages/profile_page.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class MockProfilePreferencesController extends Mock implements ProfilePreferencesController {}
class MockAuthController extends Mock implements AuthController {}
class MockNavigationService extends Mock implements NavigationService {}
class MockFocusModeController extends Mock implements FocusModeController {}
class MockThemeController extends Mock implements ThemeController {}
class MockNotificationController extends Mock implements NotificationController {}

void main() {
  late MockProfilePreferencesController mockProfilePreferencesController;
  late MockAuthController mockAuthController;
  late MockNavigationService mockNavigationService;
  late MockFocusModeController mockFocusModeController;
  late MockThemeController mockThemeController;
  late MockNotificationController mockNotificationController;

  setUp(() {
    mockProfilePreferencesController = MockProfilePreferencesController();
    mockAuthController = MockAuthController();
    mockNavigationService = MockNavigationService();
    mockFocusModeController = MockFocusModeController();
    mockThemeController = MockThemeController();
    mockNotificationController = MockNotificationController();

    when(() => mockAuthController.user).thenReturn(const UserEntity(id: '1', name: 'Test User', email: 'test@test.com'));
    when(() => mockAuthController.logout()).thenAnswer((_) async {});
    
    when(() => mockProfilePreferencesController.complexity).thenReturn(InterfaceComplexity.medium);
    when(() => mockProfilePreferencesController.displayMode).thenReturn(DisplayMode.balanced);
    when(() => mockProfilePreferencesController.hideDistractions).thenReturn(false);
    when(() => mockProfilePreferencesController.highContrast).thenReturn(false);
    when(() => mockProfilePreferencesController.darkMode).thenReturn(false);
    when(() => mockProfilePreferencesController.breakReminder).thenReturn(true);
    when(() => mockProfilePreferencesController.taskTimeAlert).thenReturn(false);
    when(() => mockProfilePreferencesController.smoothTransition).thenReturn(false);
    when(() => mockProfilePreferencesController.pushNotifications).thenReturn(false);
    when(() => mockProfilePreferencesController.notificationSounds).thenReturn(false);
    when(() => mockProfilePreferencesController.fontSize).thenReturn(FontSizePreference.normal);
    when(() => mockProfilePreferencesController.spacing).thenReturn(ElementSpacing.medium);

    when(() => mockFocusModeController.enabled).thenReturn(false);
    when(() => mockNotificationController.unreadCount).thenReturn(0);
    when(() => mockNotificationController.notifications).thenReturn([]);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfilePreferencesController>.value(value: mockProfilePreferencesController),
        ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        ChangeNotifierProvider<FocusModeController>.value(value: mockFocusModeController),
        ChangeNotifierProvider<NotificationController>.value(value: mockNotificationController),
        ChangeNotifierProvider<ThemeController>.value(value: mockThemeController),
        Provider<NavigationService>.value(value: mockNavigationService),
      ],
      child: MaterialApp(
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
    });
  });
}
