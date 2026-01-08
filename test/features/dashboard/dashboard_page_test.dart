import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/dashboard/presentation/dashboard_page.dart';

void main() {
  testWidgets(
    'DashboardPage renderiza título e botões principais',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardPage(),
        ),
      );

      expect(find.text('MindEase – Painel Cognitivo'), findsOneWidget);
      expect(find.text('Kanban + Pomodoro'), findsOneWidget);
      expect(find.text('Perfil Cognitivo'), findsOneWidget);
    },
  );
}
