import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/tasks/presentation/tasks_page.dart';

void main() {
  testWidgets(
    'TasksPage deve renderizar texto Tasks',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TasksPage(),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
    },
  );
}
