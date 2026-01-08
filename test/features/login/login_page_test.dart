import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/auth/presentation/pages/login/login_page.dart';

void main() {
  testWidgets(
    'LoginPage renderiza campos principais',
    (WidgetTester tester) async {
      // Define tamanho de tela realista
      tester.binding.window.physicalSizeTestValue =
          const Size(1440, 900);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
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
}
