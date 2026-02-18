import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/register/register_page.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';

class MockAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRegisterController extends ChangeNotifier implements RegisterController {
  @override
  bool isLoading = false;
  @override
  String? errorMessage;
  
  bool _isFormValid = false;
  @override
  bool get isFormValid => _isFormValid;
  @override
  set isFormValid(bool value) => _isFormValid = value;

  @override
  void updateFormValidity({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    _isFormValid = name.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
    notifyListeners();
  }

  @override
  Future<bool> register({required String name, required String email, required String password}) async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockNavigationService implements NavigationService {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      await Supabase.initialize(
        url: 'https://exemplo-falso.supabase.co',
        anonKey: 'chave-falsa-teste',
      );
    } catch (_) {}
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NavigationService>(create: (_) => MockNavigationService()),
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
    });

    testWidgets('Deve habilitar o botão quando o formulário for válido',
        (tester) async {
      await loadPage(tester);

      // Usando find.byType(TextFormField).at(N) ou find.widgetWithText para maior precisão
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