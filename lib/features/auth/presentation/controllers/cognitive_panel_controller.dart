import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel_models.dart';

class CognitivePanelController extends ChangeNotifier {
  InterfaceComplexity _complexity = InterfaceComplexity.medium;
  DisplayMode _displayMode = DisplayMode.balanced;
  ElementSpacing _spacing = ElementSpacing.medium;
  FontSizePreference _fontSize = FontSizePreference.normal;

  InterfaceComplexity get complexity => _complexity;
  DisplayMode get displayMode => _displayMode;
  ElementSpacing get spacing => _spacing;
  FontSizePreference get fontSize => _fontSize;

  String get spacingLabel => _spacing.label;
  String get fontSizeLabel => _fontSize.label;

  double get spacingSliderValue => _spacing.index.toDouble();
  double get fontSizeSliderValue => _fontSize.index.toDouble();

  void setComplexity(InterfaceComplexity value) {
    if (_complexity == value) return;
    _complexity = value;
    notifyListeners();
  }

  void setDisplayMode(DisplayMode value) {
    if (_displayMode == value) return;
    _displayMode = value;
    notifyListeners();
  }

  void setSpacingFromSlider(double value) {
    final index = value.round().clamp(0, ElementSpacing.values.length - 1);
    final next = ElementSpacing.values[index];
    if (_spacing == next) return;
    _spacing = next;
    notifyListeners();
  }

  void setFontSizeFromSlider(double value) {
    final index =
        value.round().clamp(0, FontSizePreference.values.length - 1);
    final next = FontSizePreference.values[index];
    if (_fontSize == next) return;
    _fontSize = next;
    notifyListeners();
  }
}
