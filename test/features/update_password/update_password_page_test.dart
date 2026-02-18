import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

// Imports do seu projeto
import 'package:mindease_focus/features/auth/presentation/pages/update_password/update_password_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/update_password_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';

class MockAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUpdatePasswordController extends ChangeNotifier implements UpdatePasswordController {
  @override
  bool isLoading = false;
  @override
  String? errorMessage;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  bool get isAuthenticated => true;

  @override
  UserEntity get user => const UserEntity(id: '1', email: 'test@test.com', name: 'Test User');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      await Supabase.initialize(
        url: 'https://fake-url.com',
        anonKey: 'fake-anon-key',
      );
    } catch (_) {}
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1000));
    addTearDown(() async => await tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthRepository>(create: (_) => MockAuthRepository()),
          ChangeNotifierProvider<AuthController>(create: (_) => MockAuthController()),
          ChangeNotifierProvider<UpdatePasswordController>(create: (_) => MockUpdatePasswordController()),
        ],
        child: MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login Screen')),
            '/dashboard': (context) => const Scaffold(body: Text('Dashboard')),
          },
          home: const UpdatePasswordPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('UpdatePasswordPage Tests', () {
    testWidgets('Deve renderizar os elementos da tela', (tester) async {
      await pumpPage(tester);

      expect(find.text('Criar Nova Senha'), findsOneWidget);
      expect(find.text('Nova Senha'), findsOneWidget);
      expect(find.text('Confirmar Nova Senha'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Botão de visibilidade deve alternar ícone', (tester) async {
      await pumpPage(tester);

      final iconFinder = find.byIcon(Icons.visibility_outlined);
      expect(iconFinder, findsAtLeastNWidgets(1));

      await tester.tap(iconFinder.first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));
    });

    testWidgets('Validação: Não deve enviar formulário vazio', (tester) async {
      await pumpPage(tester);

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);
      await tester.pump();

      // Se não preencheu, o controller não deve ter sido chamado com sucesso
      expect(find.text('Criar Nova Senha'), findsOneWidget);
    });
  });
}