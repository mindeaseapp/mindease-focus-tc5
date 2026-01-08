import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/auth/presentation/pages/reset_password/reset_password_page.dart';

void main() {
  testWidgets('Fluxo completo de reset de senha', (tester) async {
    tester.binding.window.physicalSizeTestValue =
        const Size(1440, 900);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ResetPasswordPage(),
      ),
    );

    final emailField = find.byType(TextFormField);
    final buttonFinder = find.byType(ElevatedButton);

    // Botão inicia desabilitado
    ElevatedButton button =
        tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNull);

    // Email válido
    await tester.enterText(emailField, 'user@email.com');
    await tester.pump();

    button = tester.widget<ElevatedButton>(buttonFinder);
    expect(button.onPressed, isNotNull);

    // Submit
    await tester.tap(find.text('Enviar instruções'));
    await tester.pump();

    // Loading aparece
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Aguarda conclusão async sem depender de tempo fixo
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Se o email existir'),
      findsOneWidget,
    );
  });
}
