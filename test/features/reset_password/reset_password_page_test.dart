import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/auth/reset_password/presentation/reset_password_page.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  group('ResetPasswordPage - Widget Tests', () {
    Future<void> _setLargeScreen(WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue =
          const Size(1440, 900);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });
    }

    testWidgets('Renderiza textos principais',
        (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );

      expect(find.text('Recuperar senha'), findsOneWidget);
      expect(
        find.text(
          'Digite seu email e enviaremos instruções para redefinir sua senha.',
        ),
        findsOneWidget,
      );
      expect(find.text('Enviar instruções'), findsOneWidget);
    });

    testWidgets('Botão inicia desabilitado',
        (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );

      final button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, isNull);
    });

    testWidgets('Email inválido não habilita botão',
        (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );

      await tester.enterText(
        find.byType(TextFormField),
        'email_invalido',
      );
      await tester.pump();

      final button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, isNull);
    });

    testWidgets('Email válido habilita botão',
        (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );

      await tester.enterText(
        find.byType(TextFormField),
        'usuario@email.com',
      );
      await tester.pump();

      final button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, isNotNull);
    });

    testWidgets('Submeter mostra loading e snackbar',
        (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );

      await tester.enterText(
        find.byType(TextFormField),
        'usuario@email.com',
      );
      await tester.pump();

      await tester.tap(find.text('Enviar instruções'));
      await tester.pump();

      // Loading aparece
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Avança qualquer Future pendente (mais seguro que 2s fixos)
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Se o email existir'),
        findsOneWidget,
      );
    });

    testWidgets('Voltar para login faz pop',
        (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResetPasswordPage(),
                    ),
                  );
                },
                child: const Text('Abrir Reset'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Abrir Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Recuperar senha'), findsOneWidget);

      await tester.ensureVisible(find.text('Voltar para login'));
      await tester.tap(find.text('Voltar para login'));
      await tester.pumpAndSettle();

      expect(find.text('Recuperar senha'), findsNothing);
    });
  });
}
