import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/features/profile/presentation/pages/profile_page.dart';
import 'package:mindease_focus/features/profile/domain/models/profile_view/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';


class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  UserEntity get user =>
      const UserEntity(id: '1', name: 'Teste', email: 'teste@email.com');

  @override
  Future<void> logout() async {}

  @override
  bool get isAuthenticated => true;

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    try {
      await Supabase.initialize(url: 'https://fake.com', anonKey: 'fake');
    } catch (_) {
    }
  });

  testWidgets('ProfilePage renderiza sem crash e mostra elementos base',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final msg = details.exception.toString().toLowerCase();
      if (msg.contains('overflow')) return;
      FlutterError.dumpErrorToConsole(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    final dummyViewModel = ProfileViewModel(
      pageTitle: 'Perfil',
      pageSubtitle: 'Subtitulo',
      sections: const [],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(
            create: (_) => MockAuthController(),
          ),
          ChangeNotifierProvider<ProfilePreferencesController>(
            create: (_) => ProfilePreferencesController(),
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
    expect(find.byIcon(Icons.logout_rounded), findsOneWidget);

    expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);

    expect(find.text('Teste'), findsAtLeastNWidgets(1));

    final titleFinder = find.byWidgetPredicate((w) {
      if (w is! Text) return false;
      if (w.data != 'Perfil') return false;
      final size = w.style?.fontSize;
      return size != null && size >= 28;
    });
    expect(titleFinder, findsOneWidget);
  });
}
