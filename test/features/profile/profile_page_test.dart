import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/features/profile/presentation/pages/profile_page.dart';
import 'package:mindease_focus/features/profile/domain/models/profile_view/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';


class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  UserEntity get user =>
      const UserEntity(id: '1', name: 'Teste', email: 'teste@email.com');

  @override
  Future<void> logout() async {}

  @override
  bool get isAuthenticated => true;

  @override
  bool get needsPasswordReset => false;

  @override
  Future<void> refreshUser() async {}

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class MockThemeController extends ChangeNotifier implements ThemeController {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class FakeFocusModeController extends ChangeNotifier
    implements FocusModeController {
  @override
  bool enabled;

  FakeFocusModeController({this.enabled = false});

  @override
  void toggle() {
    enabled = !enabled;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class FakeProfilePreferencesController extends ChangeNotifier implements ProfilePreferencesController {
  @override
  InterfaceComplexity get complexity => InterfaceComplexity.medium;
  
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
  Future<void> applyComplexity(InterfaceComplexity complexity) async {}
  @override
  Future<void> loadPreferences(String userId) async {}
  
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class MockNavigationService implements NavigationService {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async => null;
  @override
  Future<dynamic> replaceWith(String routeName, {Object? arguments}) async => null;
  @override
  void goBack() {}
  @override
  void goToLogin() {}
  @override
  void goToDashboard() {}
  @override
  void goToTasks({int? tabIndex}) {}
  @override
  void goToProfile() {}

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      await Supabase.initialize(url: 'https://fake.com', anonKey: 'fake');
    } catch (_) {}
  });

  testWidgets('ProfilePage renderiza sem crash e mostra elementos base',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final dummyViewModel = ProfileViewModel(
      pageTitle: 'Perfil',
      pageSubtitle: 'Subtitulo',
      sections: const [],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NavigationService>(create: (_) => MockNavigationService()),
          ChangeNotifierProvider<AuthController>(
            create: (_) => MockAuthController(),
          ),
          ChangeNotifierProvider<ProfilePreferencesController>(
            create: (_) => FakeProfilePreferencesController(),
          ),
          ChangeNotifierProvider<ThemeController>(
            create: (_) => MockThemeController(),
          ),
          ChangeNotifierProvider<FocusModeController>(
            create: (_) => FakeFocusModeController(enabled: false),
          ),
        ],
        child: MaterialApp(
          home: ProfilePage(viewModel: dummyViewModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Perfil'), findsAtLeastNWidgets(1));
    expect(find.text('Subtitulo'), findsOneWidget);
    expect(find.text('Sair da Conta'), findsOneWidget);
    expect(find.text('Teste'), findsAtLeastNWidgets(1));
  });
}
