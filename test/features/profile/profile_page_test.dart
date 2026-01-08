import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/pages/profile/profile_page.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';

void main() {
  testWidgets(
    'ProfilePage renderiza título e opções',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MaterialApp(
            home: ProfilePage(),
          ),
        ),
      );

      // AppBar
      expect(find.text('Perfil Cognitivo'), findsOneWidget);

      // Opção de tema
      expect(find.text('Modo Escuro'), findsOneWidget);
    },
  );
}
