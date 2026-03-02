import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';

void main() {
  group('MindEaseHeader', () {
    Widget createHeader({
      MindEaseNavItem current = MindEaseNavItem.dashboard,
      String userLabel = 'User',
      ValueChanged<MindEaseNavItem>? onNavigate,
    }) {
      return ChangeNotifierProvider(
        create: (_) => NotificationController(),
        child: MaterialApp(
          home: Scaffold(
            appBar: MindEaseHeader(
              current: current,
              onNavigate: onNavigate ?? (_) {},
              userLabel: userLabel,
              onLogout: () {},
            ),
          ),
        ),
      );
    }

    testWidgets('renders desktop layout on wide screen', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createHeader());

      expect(find.text('MindEase'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Tarefas'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('User'), findsOneWidget);

      expect(find.byIcon(Icons.menu), findsNothing);
      
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('renders mobile layout on small screen', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createHeader());

      expect(find.text('MindEase'), findsNothing);
      expect(find.text('Dashboard'), findsNothing);
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

      await tester.pumpWidget(createHeader(
        onNavigate: (item) => navigatedTo = item,
      ));

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
