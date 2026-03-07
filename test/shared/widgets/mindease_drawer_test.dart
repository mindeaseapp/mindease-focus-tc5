
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart'; 
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

void main() {
  group('MindEaseDrawer', () {
    testWidgets('renders correctly with current item selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MindEaseDrawer(
              current: MindEaseNavItem.dashboard,
              onNavigate: (_) {},
              onLogout: () {},
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Tarefas'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('Sair'), findsOneWidget);

      final dashboardItem = find.widgetWithText(InkWell, 'Dashboard').first;
      
      expect(tester.getSemantics(find.ancestor(of: find.text('Dashboard'), matching: find.byType(Semantics)).first).hasFlag(ui.SemanticsFlag.isSelected), true);
      expect(tester.getSemantics(find.ancestor(of: find.text('Tarefas'), matching: find.byType(Semantics)).first).hasFlag(ui.SemanticsFlag.isSelected), false);
    });

    testWidgets('calls onNavigate when item tapped', (tester) async {
      MindEaseNavItem? navigatedTo;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MindEaseDrawer(
              current: MindEaseNavItem.dashboard,
              onNavigate: (item) => navigatedTo = item,
              onLogout: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tarefas'));
      await tester.pump(); 

      expect(navigatedTo, MindEaseNavItem.tasks);
    });

    testWidgets('calls onLogout when logout tapped', (tester) async {
      bool logoutCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MindEaseDrawer(
              current: MindEaseNavItem.dashboard,
              onNavigate: (_) {},
              onLogout: () => logoutCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Sair'));
      await tester.pump();

      expect(logoutCalled, true);
    });
  });
}
