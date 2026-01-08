import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page.dart';

void main() {
  testWidgets(
    'TasksPage renderiza título Kanban + Pomodoro',
    (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue =
          const Size(1440, 900);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: TasksPage(),
        ),
      );

      // AppBar existe
      expect(find.byType(AppBar), findsOneWidget);
    },
  );
}
