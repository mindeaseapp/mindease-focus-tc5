
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

      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNull);
            
      expect(decoration.color, isNotNull);
    });
  });
}
