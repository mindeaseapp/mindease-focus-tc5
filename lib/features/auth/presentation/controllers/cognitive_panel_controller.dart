import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel_models.dart';

class CognitivePanelController extends ChangeNotifier {
  // ✅ opcional: avisa alguém quando a complexidade mudar (ex.: prefs)
  final ValueChanged<InterfaceComplexity>? onComplexityChanged;

  CognitivePanelController({this.onComplexityChanged});

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

  void _enforceRulesAfterComplexityChange() {
    final allowedModes = _complexity.allowedDisplayModes;
    if (!allowedModes.contains(_displayMode)) {
      _displayMode = _complexity.defaultDisplayMode;
    }

    final allowedSpacings = _complexity.allowedSpacings;
    if (!allowedSpacings.contains(_spacing)) {
      _spacing = _complexity.defaultSpacing;
    }

    final allowedFonts = _complexity.allowedFontSizes;
    if (!allowedFonts.contains(_fontSize)) {
      _fontSize = _complexity.defaultFontSize;
    }
  }

  void setComplexity(InterfaceComplexity value) {
    if (_complexity == value) return;
    _complexity = value;

    // ✅ previsível e consistente
    _enforceRulesAfterComplexityChange();

    notifyListeners();

    // ✅ avisa (se alguém quiser reagir: prefs/app/analytics etc.)
    onComplexityChanged?.call(_complexity);
  }

  void setDisplayMode(DisplayMode value) {
    final allowed = _complexity.allowedDisplayModes;
    final next = allowed.contains(value) ? value : _complexity.defaultDisplayMode;

    if (_displayMode == next) return;
    _displayMode = next;
    notifyListeners();
  }

  void setSpacingFromSlider(double value) {
    final index = value.round().clamp(0, ElementSpacing.values.length - 1);
    final candidate = ElementSpacing.values[index];

    final allowed = _complexity.allowedSpacings;
    final next = allowed.contains(candidate) ? candidate : _complexity.defaultSpacing;

    if (_spacing == next) return;
    _spacing = next;
    notifyListeners();
  }

  void setFontSizeFromSlider(double value) {
    final index = value.round().clamp(0, FontSizePreference.values.length - 1);
    final candidate = FontSizePreference.values[index];

    final allowed = _complexity.allowedFontSizes;
    final next = allowed.contains(candidate) ? candidate : _complexity.defaultFontSize;

    if (_fontSize == next) return;
    _fontSize = next;
    notifyListeners();
  }
}
