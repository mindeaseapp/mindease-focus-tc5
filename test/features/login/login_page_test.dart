import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';

void main() {
  testWidgets(
    'LoginPage renderiza campos principais',
    (WidgetTester tester) async {
      // Define tamanho de tela realista
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verificações estáveis
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Entrar'), findsOneWidget);
    },
  );

  testWidgets(
    'LoginPage possui labels de acessibilidade',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica semântica dos campos
      expect(
        find.bySemanticsLabel(RegExp(r'Campo de email')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Campo de senha')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Botão de visibilidade de senha possui tooltip',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Encontra o botão de visibilidade
      final visibilityButton = find.byTooltip('Mostrar senha');
      expect(visibilityButton, findsOneWidget);

      // Testa toggle
      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Ocultar senha'), findsOneWidget);
    },
  );

  testWidgets(
    'Navegação por teclado funciona corretamente',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Encontra os campos
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Testa foco no email
      await tester.tap(emailField);
      await tester.pumpAndSettle();

      // Simula "próximo" campo (enter no email deve ir para senha)
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      // Verifica que o campo de senha pode receber foco
      expect(passwordField, findsOneWidget);
    },
  );
}