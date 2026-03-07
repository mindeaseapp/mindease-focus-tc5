
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
      
      expect(controller.displayMode, DisplayMode.summary);
    });

    test('setDisplayMode should update if allowed', () {
       controller.setComplexity(InterfaceComplexity.medium); 
       controller.setDisplayMode(DisplayMode.balanced);
       expect(controller.displayMode, DisplayMode.balanced);
    });

    test('setDisplayMode should revert to default if not allowed', () {
       controller.setComplexity(InterfaceComplexity.simple); 
       
       controller.setDisplayMode(DisplayMode.detailed);
       
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
