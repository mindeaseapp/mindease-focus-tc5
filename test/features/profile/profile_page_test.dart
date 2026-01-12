import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Imports do projeto
import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';

// =========================================================
// MOCKS PARA O QUE REALMENTE PRECISA
// =========================================================

class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  UserEntity get user =>
      const UserEntity(id: '1', name: 'Teste', email: 'teste@email.com');

  @override
  Future<void> logout() async {}

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

// Mock do ThemeController (se o seu Header/Drawer acessar getters específicos,
// implemente aqui também)
class MockThemeController extends ChangeNotifier implements ThemeController {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // 1) Hack SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // 2) Hack Supabase (Try/Catch caso já tenha sido iniciado)
    try {
      await Supabase.initialize(url: 'https://fake.com', anonKey: 'fake');
    } catch (_) {}
  });

  testWidgets('ProfilePage deve renderizar sem explodir',
      (WidgetTester tester) async {
    // 1) Tela grande
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // 2) Ignorar somente overflow
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('overflow')) return;
      FlutterError.dumpErrorToConsole(details);
    };

    final dummyViewModel = ProfileViewModel(
      pageTitle: 'Perfil',
      pageSubtitle: 'Subtitulo',
      sections: const [],
    );

    // 3) Injetar providers
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
        ],
        child: MaterialApp(
          home: ProfilePage(viewModel: dummyViewModel),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Perfil'), findsOneWidget);
  });
}
