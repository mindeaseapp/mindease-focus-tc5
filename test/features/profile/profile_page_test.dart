import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/profile/presentation/profile_page.dart';

void main() {
  testWidgets(
    'ProfilePage deve renderizar texto Profile',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      expect(find.text('Profile'), findsOneWidget);
    },
  );
}
