
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/features/auth/presentation/pages/update_password/update_password_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/update_password_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/shared/domain/entities/user_entity.dart';

class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  bool get isAuthenticated => true;
  
   @override
  UserEntity get user => const UserEntity(id: '1', email: 'test@test.com', name: 'Test User');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUpdatePasswordController extends ChangeNotifier implements UpdatePasswordController {
  @override
  bool isLoading = false;
  
  @override
  String? errorMessage;

  @override
  Future<bool> updatePassword(String password) async {
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
     try {
      await Supabase.initialize(url: 'https://fake-url.com', anonKey: 'fake-anon-key');
    } catch (_) {}
  });

  Future<void> _pumpUpdatePasswordPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() async => await tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
           ChangeNotifierProvider<AuthController>(create: (_) => MockAuthController()),
           ChangeNotifierProvider<UpdatePasswordController>(create: (_) => MockUpdatePasswordController()),
        ],
        child: MaterialApp(
          home: const UpdatePasswordPage(),
          routes: {
             '/login': (context) => const SizedBox(),
          }
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Deve renderizar campos de nova senha e confirmação', (tester) async {
    await _pumpUpdatePasswordPage(tester);

    expect(find.text('Criar Nova Senha'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Nova Senha'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Confirmar Nova Senha'), findsOneWidget);
  });

   testWidgets('Deve validar senhas não coincidentes', (tester) async {
    await _pumpUpdatePasswordPage(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Nova Senha'), 'Password123!');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirmar Nova Senha'), 'Password123');
    await tester.pumpAndSettle();
    
    // Trigger validation
    await tester.tap(find.widgetWithText(ElevatedButton, 'Redefinir e Ir para Login'));
    await tester.pumpAndSettle();

    expect(find.text('As senhas não coincidem'), findsOneWidget);
  });
}
