
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mindease_focus/features/dashboard/presentation/dashboard_page.dart';

void main() {
  testWidgets('DashboardPage renders title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
    expect(find.text('MindEase Focus'), findsOneWidget);
  });
}
