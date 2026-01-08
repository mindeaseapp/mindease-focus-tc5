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
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    testWidgets('Renderiza textos principais', (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('MindEase'), findsWidgets);
      expect(find.text('Recupere sua conta'), findsNothing);
      expect(find.text('Enviar instruções'), findsOneWidget);
    });

    testWidgets('Botão inicia desabilitado', (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Email inválido não habilita botão', (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField),
        'email_invalido',
      );
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Email válido habilita botão', (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField),
        'usuario@email.com',
      );
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Submeter mostra loading e snackbar', (WidgetTester tester) async {
      await _setLargeScreen(tester);

      await tester.pumpWidget(
        makeTestableWidget(const ResetPasswordPage()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField),
        'usuario@email.com',
      );
      await tester.pump();

      await tester.tap(find.text('Enviar instruções'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        find.textContaining('Se o email existir'),
        findsOneWidget,
      );
    });
  });
}
