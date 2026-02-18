
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';

void main() {
  group('MindEaseHeader', () {
    testWidgets('renders desktop layout on wide screen', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: MindEaseHeader(
              current: MindEaseNavItem.dashboard,
              onNavigate: (_) {},
              userLabel: 'User',
              onLogout: () {},
            ),
          ),
        ),
      );

      expect(find.text('MindEase'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Tarefas'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget); // In nav bar
      // User menu also has "Perfil" potentially?
      // Check for user label
      expect(find.text('User'), findsOneWidget);

      // Mobile menu button should not exist
      expect(find.byIcon(Icons.menu), findsNothing);
      
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('renders mobile layout on small screen', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: MindEaseHeader(
              current: MindEaseNavItem.dashboard,
              onNavigate: (_) {},
              userLabel: 'User',
              onLogout: () {},
            ),
          ),
        ),
      );

      // Mobile layout hides MindEase text (or shows it differently?) 
      // Code says: label: '' when mobile. So 'MindEase' text not shown.
      expect(find.text('MindEase'), findsNothing);
      
      // Nav items should be hidden (in drawer)
      expect(find.text('Dashboard'), findsNothing);

      // Should have menu button
      expect(find.byIcon(Icons.menu), findsOneWidget);

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
    
    testWidgets('calls onNavigate when nav item tapped (desktop)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      
      MindEaseNavItem? navigatedTo;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: MindEaseHeader(
              current: MindEaseNavItem.dashboard,
              onNavigate: (item) => navigatedTo = item,
              userLabel: 'User',
              onLogout: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tarefas'));
      await tester.pumpAndSettle();
      expect(navigatedTo, MindEaseNavItem.tasks);
      
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
