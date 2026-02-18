import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';

class MockAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRegisterController extends ChangeNotifier implements RegisterController {
  @override
  bool get isLoading => false;
  
  @override
  String? get errorMessage => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://exemplo-falso.supabase.co',
      anonKey: 'chave-falsa-teste',
    );
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthRepository>(create: (_) => MockAuthRepository()),
          ChangeNotifierProvider<RegisterController>(create: (_) => MockRegisterController()),
        ],
        child: const MaterialApp(
          home: RegisterPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('RegisterPage UI Tests', () {
    testWidgets('Deve carregar os campos do formulário corretamente',
        (tester) async {
      await loadPage(tester);

      expect(find.text('Crie sua conta'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Nome completo'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Confirmar senha'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Criar conta'), findsOneWidget);
    });

    testWidgets('Deve mostrar erro se tentar submeter formulário vazio',
        (tester) async {
      await loadPage(tester);

      final nomeField = find.widgetWithText(TextFormField, 'Nome completo');
      await tester.enterText(nomeField, '');
      await tester.pump();

      await tester.tap(find.text('Crie sua conta'));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Criar conta'));
      expect(button.onPressed, isNull);
    });

    testWidgets('Deve habilitar o botão quando o formulário for válido',
        (tester) async {
      await loadPage(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'Nome completo'), 'Usuário Teste');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'teste@email.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Senha'), 'SenhaForte123!');
      await tester.enterText(find.widgetWithText(TextFormField, 'Confirmar senha'), 'SenhaForte123!');

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Criar conta'));
      expect(button.onPressed, isNotNull);
    });
  });
}