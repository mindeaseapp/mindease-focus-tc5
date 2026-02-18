import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

// Imports do seu projeto
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';

// Mock simples para não quebrar o Provider
class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  bool get isAuthenticated => false;

  @override
  UserEntity get user => const UserEntity(id: '1', email: 'test@test.com', name: 'Test User');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://fake-url.com',
      anonKey: 'fake-anon-key',
    );
  });

  Future<void> _pumpLoginPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() async => await tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthRepository>(create: (_) => MockAuthRepository()),
          ChangeNotifierProvider<AuthController>(create: (_) => MockAuthController()),
        ],
        child: MaterialApp(
          routes: {
            '/dashboard': (c) => const Scaffold(body: Text('Dash')),
            '/register': (c) => const Scaffold(body: Text('Reg')),
            '/reset-password': (c) => const Scaffold(body: Text('Reset')),
          },
          home: const LoginPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Deve renderizar os campos de Email, Senha e botão Entrar', (tester) async {
    await _pumpLoginPage(tester);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
  });

  testWidgets('Botão de visibilidade deve alternar o ícone da senha', (tester) async {
    await _pumpLoginPage(tester);

    final visibilityIcon = find.byIcon(Icons.visibility_outlined);
    expect(visibilityIcon, findsOneWidget);

    await tester.tap(visibilityIcon);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('Botão Entrar deve estar desabilitado se campos estiverem vazios', (tester) async {
    await _pumpLoginPage(tester);

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Entrar');
    final button = tester.widget<ElevatedButton>(buttonFinder);

    expect(button.onPressed, isNull);
  });
}