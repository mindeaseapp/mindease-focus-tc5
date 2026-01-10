import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/models/cognitive_panel_models.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/app_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/section_header.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class CognitivePanelCard extends StatelessWidget {
  final CognitivePanelController controller;

  const CognitivePanelCard({
    super.key,
    required this.controller,
  });

  // =========================
  // ✅ Helpers (só deste card)
  // =========================

  double _spacingFactor(ElementSpacing s) {
    switch (s) {
      case ElementSpacing.low:
        return 0.90;
      case ElementSpacing.medium:
        return 1.00;
      case ElementSpacing.high:
        return 1.20;
    }
  }

  double _fontFactor(FontSizePreference f) {
    switch (f) {
      case FontSizePreference.small:
        return 0.92;
      case FontSizePreference.normal:
        return 1.00;
      case FontSizePreference.large:
        return 1.15;
    }
  }

  Widget _vGap(double base, double factor) => SizedBox(height: base * factor);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // ✅ fatores calculados pelo estado atual do painel
        final spacingFactor = _spacingFactor(controller.spacing);
        final fontFactor = _fontFactor(controller.fontSize);

        // ✅ aplica escala de fonte só nesse card (não mexe no app todo)
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontFactor),
          ),
          child: AppCard(
            semanticsLabel: 'Painel Cognitivo',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.psychology_outlined,
                  title: 'Painel Cognitivo',
                ),
                _vGap(AppSpacing.md, spacingFactor),

                const _FieldLabel(text: 'Nível de Complexidade da Interface'),
                _vGap(AppSpacing.xs, spacingFactor),
                _ComplexityDropdown(controller: controller),

                _vGap(AppSpacing.md, spacingFactor),
                const _FieldLabel(text: 'Modo de Exibição'),
                _vGap(AppSpacing.xs, spacingFactor),
                _DisplayModeDropdown(
                  controller: controller,
                  complexity: controller.complexity,
                ),

                _vGap(AppSpacing.md, spacingFactor),
                _SliderBlock(
                  label: 'Espaçamento entre Elementos',
                  valueLabel: controller.spacingLabel,
                  sliderValue: controller.spacingSliderValue,
                  max: (ElementSpacing.values.length - 1).toDouble(),
                  onChanged: controller.setSpacingFromSlider,
                  semanticsValue: 'Espaçamento: ${controller.spacingLabel}',
                  // ✅ opcional: também escala o “respiro” interno do bloco
                  internalSpacingFactor: spacingFactor,
                ),

                _vGap(AppSpacing.md, spacingFactor),
                _SliderBlock(
                  label: 'Tamanho da Fonte',
                  valueLabel: controller.fontSizeLabel,
                  sliderValue: controller.fontSizeSliderValue,
                  max: (FontSizePreference.values.length - 1).toDouble(),
                  onChanged: controller.setFontSizeFromSlider,
                  semanticsValue: 'Fonte: ${controller.fontSizeLabel}',
                  internalSpacingFactor: spacingFactor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}

class _ComplexityDropdown extends StatelessWidget {
  final CognitivePanelController controller;

  const _ComplexityDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Nível de Complexidade da Interface',
      hint: 'Selecione o nível de complexidade',
      value: controller.complexity.label,
      child: DropdownMenu<InterfaceComplexity>(
        expandedInsets: EdgeInsets.zero,
        initialSelection: controller.complexity,
        label: const Text(''),
        requestFocusOnTap: true,
        dropdownMenuEntries: InterfaceComplexity.values
            .map(
              (e) => DropdownMenuEntry<InterfaceComplexity>(
                value: e,
                label: e.label,
              ),
            )
            .toList(),
        onSelected: (value) {
          if (value == null) return;
          controller.setComplexity(value);
        },
      ),
    );
  }
}

class _DisplayModeDropdown extends StatelessWidget {
  final CognitivePanelController controller;
  final InterfaceComplexity complexity;

  const _DisplayModeDropdown({
    required this.controller,
    required this.complexity,
  });

  @override
  Widget build(BuildContext context) {
    final allowed = complexity.allowedDisplayModes;

    return Semantics(
      label: 'Modo de Exibição',
      hint: 'Selecione o modo de exibição',
      value: controller.displayMode.label,
      child: DropdownMenu<DisplayMode>(
        expandedInsets: EdgeInsets.zero,
        initialSelection: controller.displayMode,
        label: const Text(''),
        requestFocusOnTap: true,
        dropdownMenuEntries: DisplayMode.values.map((e) {
          final enabled = allowed.contains(e);

          return DropdownMenuEntry<DisplayMode>(
            value: e,
            label: e.label,
            enabled: enabled,
            trailingIcon:
                enabled ? null : const Icon(Icons.lock_outline, size: 18),
          );
        }).toList(),
        onSelected: (value) {
          if (value == null) return;
          controller.setDisplayMode(value);
        },
      ),
    );
  }
}

class _SliderBlock extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double sliderValue;
  final double max;
  final ValueChanged<double> onChanged;
  final String semanticsValue;

  /// ✅ para o espaçamento interno do bloco (entre título e slider)
  final double internalSpacingFactor;

  const _SliderBlock({
    required this.label,
    required this.valueLabel,
    required this.sliderValue,
    required this.max,
    required this.onChanged,
    required this.semanticsValue,
    required this.internalSpacingFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      value: semanticsValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Text(
                valueLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs * internalSpacingFactor),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.minTapArea),
            child: Slider(
              min: 0,
              max: max,
              divisions: max.toInt(),
              value: sliderValue.clamp(0, max),
              onChanged: onChanged,
              semanticFormatterCallback: (_) => semanticsValue,
            ),
          ),
        ],
      ),
    );
  }
}
