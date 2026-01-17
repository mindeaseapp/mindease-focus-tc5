import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Imports do teu projeto
import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/domain/entities/user_entity.dart';

// === SOLUÇÃO: FAKE MANUAL ===
// Em vez de usar Mockito, criamos uma classe que "finge" ser o AuthController.
// Estendemos ChangeNotifier para ganhar as funções addListener/dispose de graça.
class FakeAuthController extends ChangeNotifier implements AuthController {
  
  // 1. Criamos um utilizador falso fixo
  final _fakeUser = UserEntity(
    id: '123',
    name: 'Teste User',
    email: 'teste@email.com',
    // Adiciona outros campos se o teu UserEntity pedir
  );

  // 2. Implementamos o getter 'user' que a página pede
  @override
  UserEntity get user => _fakeUser;

  // 3. Preenchemos o resto com funções vazias para o compilador não reclamar
  @override
  bool get isAuthenticated => true;

  @override
  Future<void> logout() async {
    // Não faz nada, é só um fake
  }

  @override
  Future<void> refreshUser() async {
    // Não faz nada
  }

  // Se o teu AuthController tiver mais métodos, adiciona-os aqui vazios
}

void main() {
  testWidgets(
    'TasksPage renderiza título Kanban + Pomodoro',
    (WidgetTester tester) async {
      // Configuração de tamanho de tela
      tester.binding.window.physicalSizeTestValue = const Size(1440, 900);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      // Instanciamos o nosso Fake
      final fakeController = FakeAuthController();

      await tester.pumpWidget(
        // Injetamos o Fake no Provider
        ChangeNotifierProvider<AuthController>.value(
          value: fakeController,
          child: const MaterialApp(
            home: TasksPage(),
          ),
        ),
      );

      // Verificações
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Teste User'), findsOneWidget); // Verifica se leu o nome do Fake
    },
  );
}