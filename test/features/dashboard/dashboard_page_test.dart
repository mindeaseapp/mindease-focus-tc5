import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/dashboard/dashboard_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';

class FakeAuthController extends ChangeNotifier implements AuthController {
  final UserEntity _user =
      const UserEntity(id: '1', name: 'Teste User', email: 'teste@email.com');

  @override
  UserEntity get user => _user;

  @override
  bool get isAuthenticated => true;

  @override
  Future<void> logout() async {}

  @override
  Future<void> refreshUser() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFocusModeController extends ChangeNotifier
    implements FocusModeController {
  @override
  bool enabled;

  FakeFocusModeController({this.enabled = false});

  @override
  void setEnabled(bool value) {
    enabled = value;
    notifyListeners();
  }

  @override
  void toggle() => setEnabled(!enabled);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DashboardPage renderiza elementos principais',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>.value(
            value: FakeAuthController(),
          ),
          ChangeNotifierProvider<FocusModeController>.value(
            value: FakeFocusModeController(enabled: false),
          ),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
    expect(
      find.text('Bem-vindo de volta! Aqui está seu resumo de hoje.'),
      findsOneWidget,
    );
    expect(find.text('Tarefas Recentes'), findsOneWidget);
    expect(find.text('Dica do Dia'), findsOneWidget);

    expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);
  });
}
