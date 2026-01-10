import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

// Imports do seu projeto
import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';

// Mock simples para não quebrar o Provider
class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // 1. HACK: Simula o SharedPreferences para o Supabase não chorar
    SharedPreferences.setMockInitialValues({});
    
    // 2. HACK: Inicializa o Supabase com dados falsos para evitar erro de instância
    await Supabase.initialize(
      url: 'https://fake-url.com',
      anonKey: 'fake-anon-key',
    );
  });

  Future<void> _pumpLoginPage(WidgetTester tester) async {
    // Configura tamanho de tela para Desktop para evitar erros de overflow nos testes
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() async => await tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(create: (_) => MockAuthController()),
        ],
        child: MaterialApp(
          // Define rotas falsas para navegação não quebrar o teste
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

    // 1. Acha o ícone inicial (Olho aberto)
    final visibilityIcon = find.byIcon(Icons.visibility_outlined);
    expect(visibilityIcon, findsOneWidget);

    // 2. Clica nele
    await tester.tap(visibilityIcon);
    await tester.pumpAndSettle();

    // 3. Verifica se mudou para o ícone de olho riscado/fechado
    // Nota: O seu código usa visibility_off_outlined quando a senha NÃO é obscura? 
    // Se der erro aqui, inverta os ícones neste teste.
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('Botão Entrar deve estar desabilitado se campos estiverem vazios', (tester) async {
    await _pumpLoginPage(tester);

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Entrar');
    final button = tester.widget<ElevatedButton>(buttonFinder);

    expect(button.onPressed, isNull);
  });
}