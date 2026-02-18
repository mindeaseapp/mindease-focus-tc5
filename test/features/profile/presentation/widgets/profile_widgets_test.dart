import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/profile_identity_tile/profile_identity_tile.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/settings_switches/settings_switches_card.dart';

void main() {
  group('ProfileIdentityTile', () {
    testWidgets('renders name and email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileIdentityTile(
              name: 'John Doe',
              email: 'john.doe@example.com',
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileIdentityTile(
              name: 'John Doe',
              email: 'john.doe@example.com',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, true);
    });
  });

  group('SettingsSwitchesCard', () {
    testWidgets('renders title and items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsSwitchesCard(
              title: 'Settings',
              icon: Icons.settings,
              items: [
                SettingsSwitchItemData(
                  title: 'Option 1',
                  subtitle: 'Description 1',
                  value: true,
                  onChanged: (_) {},
                ),
                SettingsSwitchItemData(
                  title: 'Option 2',
                  subtitle: 'Description 2',
                  value: false,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Description 2'), findsOneWidget);
    });

    testWidgets('toggles switch when tapped', (tester) async {
      bool value = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SettingsSwitchesCard(
                  title: 'Settings',
                  icon: Icons.settings,
                  items: [
                    SettingsSwitchItemData(
                      title: 'Option 1',
                      subtitle: 'Description 1',
                      value: value,
                      onChanged: (v) {
                        setState(() {
                          value = v;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(value, true);
    });
  });
}
