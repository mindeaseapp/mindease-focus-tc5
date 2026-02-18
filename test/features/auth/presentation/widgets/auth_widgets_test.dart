import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/app_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/section_header.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_section_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';

void main() {
  group('Auth Widgets', () {
    testWidgets('AppCard renders child and semantics', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCard(
              semanticsLabel: 'Test Card',
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.bySemanticsLabel('Test Card'), findsOneWidget);
    });

    testWidgets('SectionHeader renders icon and title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              icon: Icons.settings,
              title: 'Settings Header',
            ),
          ),
        ),
      );

      expect(find.text('Settings Header'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('SettingsSectionCard renders title, icon and children', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsSectionCard(
              semanticsLabel: 'Settings Section',
              icon: Icons.person,
              title: 'Profile',
              children: [
                Text('Child 1'),
                Text('Child 2'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('SettingsTile renders title, subtitle and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsTile(
              data: SettingsTileData(
                leading: const Icon(Icons.notifications),
                title: 'Notifications',
                subtitle: 'Manage alerts',
                onTap: () => tapped = true,
                semanticsLabel: 'Tap Notifications',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Manage alerts'), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      expect(tapped, true);
    });
  });
}
