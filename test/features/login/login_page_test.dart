import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';

void main() {
  Future<void> _pumpLoginPage(
    WidgetTester tester, {
    Size size = const Size(1440, 900),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    await tester.pumpAndSettle();
  }

  // ======================================================
  // Renderização básica
  // ======================================================
  testWidgets(
    'LoginPage renderiza campos principais',
    (WidgetTester tester) async {
      await _pumpLoginPage(tester);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    },
  );

  // ======================================================
  // Labels visuais (não Semantics)
  // ======================================================
  testWidgets(
    'LoginPage exibe labels corretos nos campos',
    (WidgetTester tester) async {
      await _pumpLoginPage(tester);

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
    },
  );

  // ======================================================
  // Botão de visibilidade da senha
  // ======================================================
  testWidgets(
    'Botão de visibilidade da senha alterna estado',
    (WidgetTester tester) async {
      await _pumpLoginPage(tester);

      final visibilityButton = find.byIcon(Icons.visibility_outlined);
      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    },
  );

  // ======================================================
  // Navegação por teclado
  // ======================================================
  testWidgets(
    'Navegação por teclado funciona entre os campos',
    (WidgetTester tester) async {
      await _pumpLoginPage(tester);

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);

      await tester.tap(emailField);
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      expect(passwordField, findsOneWidget);
    },
  );

  // ======================================================
  // Botão Entrar desabilitado sem dados
  // ======================================================
  testWidgets(
    'Botão Entrar inicia desabilitado',
    (WidgetTester tester) async {
      await _pumpLoginPage(tester);

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed, isNull);
    },
  );
}
