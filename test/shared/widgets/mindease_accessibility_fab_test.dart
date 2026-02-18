import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/shared/widgets/focus_mode/mindease_accessibility_fab.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockFocusModeController extends Mock implements FocusModeController {}

void main() {
  late MockFocusModeController mockFocusModeController;

  setUp(() {
    mockFocusModeController = MockFocusModeController();
    when(() => mockFocusModeController.enabled).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<FocusModeController>.value(
      value: mockFocusModeController,
      child: const MaterialApp(
        home: Scaffold(
          body: MindEaseAccessibilityFab(),
        ),
      ),
    );
  }

  group('MindEaseAccessibilityFab', () {
    testWidgets('renders expand and help buttons', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.open_in_full_rounded), findsOneWidget);
      expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
    });

    testWidgets('opens popover when expand button is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.open_in_full_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Acessibilidade'), findsOneWidget);
      expect(find.text('Ativar Modo Foco'), findsOneWidget);
    });

    testWidgets('toggles focus mode when switch is tapped', skip: true, (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Open the popover
      await tester.tap(find.byIcon(Icons.open_in_full_rounded));
      await tester.pumpAndSettle();

      // Verify the element is present
      final textFinder = find.text('Ativar Modo Foco');
      expect(textFinder, findsOneWidget);

      // Find the InkWell that wraps the text to ensure we tap the interactive area
      final inkWellFinder = find.ancestor(
        of: textFinder,
        matching: find.byType(InkWell),
      );
      
      await tester.tap(inkWellFinder);
      await tester.pump(); // Process the tap event
      
      verify(() => mockFocusModeController.toggle()).called(1);
    });

    testWidgets('shows help dialog when help button is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.help_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Ajuda'), findsOneWidget);
      expect(find.text('Acessibilidade e modo foco.'), findsOneWidget);
    });
  });
}
