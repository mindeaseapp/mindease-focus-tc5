
import 'package:flutter_test/flutter_test.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

void main() {
  late CognitivePanelController controller;
  bool complexityChangedCalled = false;
  InterfaceComplexity? complexityChangedValue;

  setUp(() {
    complexityChangedCalled = false;
    complexityChangedValue = null;
    controller = CognitivePanelController(
      onComplexityChanged: (value) {
        complexityChangedCalled = true;
        complexityChangedValue = value;
      },
    );
  });

  group('CognitivePanelController', () {
    test('initial state should be correct', () {
      expect(controller.complexity, InterfaceComplexity.medium);
      expect(controller.displayMode, DisplayMode.balanced);
      expect(controller.spacing, ElementSpacing.medium);
      expect(controller.fontSize, FontSizePreference.normal);
    });

    test('setComplexity should update state and enforce rules', () {
      controller.setComplexity(InterfaceComplexity.simple);
      
      expect(controller.complexity, InterfaceComplexity.simple);
      expect(complexityChangedCalled, true);
      expect(complexityChangedValue, InterfaceComplexity.simple);
      
      // Simple enforces summary
      expect(controller.displayMode, DisplayMode.summary);
    });

    test('setDisplayMode should update if allowed', () {
       controller.setComplexity(InterfaceComplexity.medium); // Medium allows balanced
       controller.setDisplayMode(DisplayMode.balanced);
       expect(controller.displayMode, DisplayMode.balanced);
    });

    test('setDisplayMode should revert to default if not allowed', () {
       controller.setComplexity(InterfaceComplexity.simple); // Simple only allows summary
       
       // Try setting detailed (not allowed in simple)
       controller.setDisplayMode(DisplayMode.detailed);
       
       // Should stay/revert to summary (default for simple)
       expect(controller.displayMode, DisplayMode.summary);
    });

    test('setSpacingFromSlider should update if allowed', () {
      controller.setSpacingFromSlider(ElementSpacing.medium.index.toDouble());
      expect(controller.spacing, ElementSpacing.medium);
    });

    test('setFontSizeFromSlider should update if allowed', () {
      controller.setFontSizeFromSlider(FontSizePreference.large.index.toDouble());
      expect(controller.fontSize, FontSizePreference.large);
    });
  });
}
