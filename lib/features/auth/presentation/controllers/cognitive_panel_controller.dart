import 'package:flutter/foundation.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';

class CognitivePanelController extends ChangeNotifier {
  final ValueChanged<InterfaceComplexity>? onComplexityChanged;
  final ValueChanged<DisplayMode>? onDisplayModeChanged;
  final ValueChanged<FontSizePreference>? onFontSizeChanged;
  final ValueChanged<ElementSpacing>? onSpacingChanged;

  CognitivePanelController({
    this.onComplexityChanged,
    this.onDisplayModeChanged,
    this.onFontSizeChanged,
    this.onSpacingChanged,
  });

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

    _enforceRulesAfterComplexityChange();

    notifyListeners();

    onComplexityChanged?.call(_complexity);
  }

  void setDisplayMode(DisplayMode value) {
    final allowed = _complexity.allowedDisplayModes;
    final next = allowed.contains(value) ? value : _complexity.defaultDisplayMode;

    if (_displayMode == next) return;
    _displayMode = next;
    notifyListeners();
    onDisplayModeChanged?.call(_displayMode);
  }

  void setSpacingFromSlider(double value) {
    final index = value.round().clamp(0, ElementSpacing.values.length - 1);
    final candidate = ElementSpacing.values[index];

    final allowed = _complexity.allowedSpacings;
    final next = allowed.contains(candidate) ? candidate : _complexity.defaultSpacing;

    if (_spacing == next) return;
    _spacing = next;
    notifyListeners();
    onSpacingChanged?.call(_spacing);
  }

  void setFontSizeFromSlider(double value) {
    final index = value.round().clamp(0, FontSizePreference.values.length - 1);
    final candidate = FontSizePreference.values[index];

    final allowed = _complexity.allowedFontSizes;
    final next = allowed.contains(candidate) ? candidate : _complexity.defaultFontSize;

    if (_fontSize == next) return;
    _fontSize = next;
    notifyListeners();
    onFontSizeChanged?.call(_fontSize);
  }

  void syncFromGlobal({
    required InterfaceComplexity globalComplexity,
    required DisplayMode globalDisplayMode,
    required ElementSpacing globalSpacing,
    required FontSizePreference globalFontSize,
  }) {
    bool hasChanges = false;
    
    if (_complexity != globalComplexity) {
      _complexity = globalComplexity;
      hasChanges = true;
    }
    if (_displayMode != globalDisplayMode) {
      _displayMode = globalDisplayMode;
      hasChanges = true;
    }
    if (_spacing != globalSpacing) {
      _spacing = globalSpacing;
      hasChanges = true;
    }
    if (_fontSize != globalFontSize) {
      _fontSize = globalFontSize;
      hasChanges = true;
    }

    if (hasChanges) {
      notifyListeners();
    }
  }
}
