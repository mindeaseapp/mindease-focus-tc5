
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindease_focus/shared/widgets/gradient_panel/gradient_panel.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';

class MockProfilePreferencesController extends Mock implements ProfilePreferencesController {}

void main() {
  group('GradientPanel', () {
    testWidgets('renders with gradient when hideDistractions is false', (tester) async {
       // We need to provide the controller, or null.
       // The code uses context.select<ProfilePreferencesController?, bool>(...).
       // So we can provide null or a mock.

       final mockController = MockProfilePreferencesController();
       when(() => mockController.hideDistractions).thenReturn(false);

       await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<ProfilePreferencesController?>.value(
              value: mockController, 
              child: const GradientPanel(child: Text('Content')),
            ),
          ),
        ),
      );

      // Check if decoration has gradient
      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
      expect(decoration.color, isNull);
    });

    testWidgets('renders solid color when hideDistractions is true', (tester) async {
       final mockController = MockProfilePreferencesController();
       when(() => mockController.hideDistractions).thenReturn(true);

       await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<ProfilePreferencesController?>.value(
              value: mockController, 
              child: const GradientPanel(child: Text('Content')),
            ),
          ),
        ),
      );

      // Check if decoration has color (no gradient)
      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNull);
      // In focus mode, it uses theme.colorScheme.surface
      // We can't easily verify the exact color without knowing theme, but we check if it is set.
      // Actually decoration.color might be null if using color parameter of container?
      // No, it uses decoration: BoxDecoration(color: ...).
      
      // Wait, look at code: 
      // decoration: hideDistractions ? BoxDecoration(color: ...) : BoxDecoration(gradient: ...)
      
      expect(decoration.color, isNotNull);
    });
  });
}
