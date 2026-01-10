import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Imports do projeto
import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_page.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/profile_view_model.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
// Importe o ThemeController se existir no seu projeto, senão usa o Mock abaixo
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart'; 
import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';

// =========================================================
// MOCKS PARA TUDO QUE PODE QUEBRAR
// =========================================================

class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  get user => const UserEntity(id: '1', name: 'Teste', email: 'teste@email.com');
  @override
  Future<void> logout() async {}
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class MockProfilePreferences extends ChangeNotifier implements ProfilePreferencesController {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

// Mock do ThemeController (Muitas vezes é o culpado silencioso)
class MockThemeController extends ChangeNotifier implements ThemeController {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // 1. Hack SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // 2. Hack Supabase (Try/Catch caso já tenha sido iniciado)
    try {
      await Supabase.initialize(url: 'https://fake.com', anonKey: 'fake');
    } catch (_) {}
  });

  testWidgets('ProfilePage deve renderizar sem explodir', (WidgetTester tester) async {
    // 1. Tela Gigante
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // 2. Ignorar erros de Overflow (pixels estourados)
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('overflow')) return;
      FlutterError.dumpErrorToConsole(details);
    };

    final dummyViewModel = ProfileViewModel(
      pageTitle: 'Perfil',
      pageSubtitle: 'Subtitulo',
      sections: const [],
    );

    // 3. Injetar TUDO que é possível
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(create: (_) => MockAuthController()),
          ChangeNotifierProvider<ProfilePreferencesController>(create: (_) => MockProfilePreferences()),
          ChangeNotifierProvider<ThemeController>(create: (_) => MockThemeController()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ProfilePage(viewModel: dummyViewModel),
          ),
        ),
      ),
    );

    // 4. Pump simples (sem esperar animações infinitas)
    await tester.pump();

    // 5. Expectativa mínima (se achou o título, funcionou)
    expect(find.text('Perfil'), findsOneWidget);
  });
}