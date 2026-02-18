import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mindease_focus/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';

import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';

import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class FakeAuthController extends ChangeNotifier implements AuthController {
  @override
  UserEntity get user => const UserEntity(id: '1', name: 'Teste User', email: 'teste@email.com');
  @override
  bool get isAuthenticated => true;
  @override
  bool get needsPasswordReset => false;
  @override
  Future<void> logout() async {}
  @override
  Future<void> refreshUser() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFocusModeController extends ChangeNotifier implements FocusModeController {
  @override
  bool get enabled => false;
  @override
  void toggle() {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTaskController extends ChangeNotifier implements TaskController {
  @override
  List<Task> get tasks => [];
  @override
  bool get isLoading => false;
  @override
  String? get error => null;
  @override
  Future<void> loadTasks() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeDashboardController extends ChangeNotifier implements DashboardController {
  bool _welcomeHandled = false;
  @override
  bool get welcomeHandled => _welcomeHandled;
  @override
  void markWelcomeHandled() {
    if (_welcomeHandled) return;
    _welcomeHandled = true;
    notifyListeners();
  }
  @override
  List<DashboardMetric> getMetrics(List<Task> tasks) => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfilePreferencesController extends ChangeNotifier implements ProfilePreferencesController {
  @override
  bool get hideDistractions => false;
  @override
  bool get highContrast => false;
  @override
  bool get darkMode => false;
  @override
  bool get breakReminder => true;
  @override
  bool get taskTimeAlert => true;
  @override
  bool get smoothTransition => true;
  @override
  bool get pushNotifications => true;
  @override
  bool get notificationSounds => false;
  @override
  InterfaceComplexity get complexity => InterfaceComplexity.medium;

  @override
  Future<void> applyComplexity(InterfaceComplexity value) async {}
  @override
  Future<void> loadPreferences(String userId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeNavigationService implements NavigationService {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async => null;
  
  @override
  Future<dynamic> replaceWith(String routeName, {Object? arguments}) async => null;

  @override
  void goBack() {}

  @override
  void goToTasks({int? tabIndex}) {}
  
  @override
  void goToProfile() {}
  
  @override
  void goToLogin() {}
  
  @override
  void goToDashboard() {}
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DashboardPage renderiza elementos principais', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NavigationService>(create: (_) => FakeNavigationService()),
          ChangeNotifierProvider<AuthController>(create: (_) => FakeAuthController()),
          ChangeNotifierProvider<FocusModeController>(create: (_) => FakeFocusModeController()),
          ChangeNotifierProvider<TaskController>(create: (_) => FakeTaskController()),
          ChangeNotifierProvider<DashboardController>(create: (_) => FakeDashboardController()),
          ChangeNotifierProvider<ProfilePreferencesController>(create: (_) => FakeProfilePreferencesController()),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    // Usando pump com duração em vez de settle inicialmente para quebrar qualquer loop infinito detectado pelo framework
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    
    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
  });
}
