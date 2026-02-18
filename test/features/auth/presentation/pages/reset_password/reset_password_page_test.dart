
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';

class MockResetPasswordController extends ChangeNotifier implements ResetPasswordController {
  @override
  bool isLoading = false;
  
  @override
  String? errorMessage;

  @override
  Future<bool> resetPassword(String email) async {
    if (email == 'success@test.com') {
      return true;
    } else {
      errorMessage = 'Erro ao enviar instruções.';
      return false;
    }
  }

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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      await Supabase.initialize(url: 'https://fake-url.com', anonKey: 'fake-anon-key');
    } catch (_) {}
  });

  Future<void> _pumpResetPasswordPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() async => await tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NavigationService>(create: (_) => MockNavigationService()),
          ChangeNotifierProvider<ResetPasswordController>(create: (_) => MockResetPasswordController()),
        ],
        child: MaterialApp(
          home: const ResetPasswordPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Deve renderizar campo de email e texto de ajuda', (tester) async {
    await _pumpResetPasswordPage(tester);

    expect(find.text('Recuperar senha'), findsOneWidget);
    expect(find.text('Digite seu email e enviaremos instruções para redefinir sua senha.'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
  });

  testWidgets('Deve validar email inválido', (tester) async {
    await _pumpResetPasswordPage(tester);

    final emailField = find.widgetWithText(TextFormField, 'Email');
    await tester.enterText(emailField, 'invalid-email');
    await tester.pumpAndSettle();

    expect(find.text('Digite um email válido (ex: nome@email.com)'), findsOneWidget);
  });
  
  testWidgets('Botão deve estar desabilitado se formulário inválido', (tester) async {
     await _pumpResetPasswordPage(tester);
     
     final button = find.widgetWithText(ElevatedButton, 'Enviar instruções');
     final elevatedButton = tester.widget<ElevatedButton>(button);
     
     expect(elevatedButton.onPressed, isNull);
  });
}
