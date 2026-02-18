import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/cognitive_panel_controller.dart';
import 'package:mindease_focus/features/profile/domain/models/cognitive_panel/cognitive_panel_models.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/cognitive_panel/cognitive_panel_styles.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/app_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/section_header.dart';

import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class CognitivePanelCard extends StatelessWidget {
  final CognitivePanelController controller;

  const CognitivePanelCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // ✅ fatores calculados pelo estado atual do painel
        final spacingFactor = CognitivePanelStyles.spacingFactor(controller.spacing);
        final fontFactor = CognitivePanelStyles.fontFactor(controller.fontSize);

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
                CognitivePanelStyles.vGap(CognitivePanelStyles.sectionSpacing, spacingFactor),

                const _FieldLabel(text: 'Nível de Complexidade da Interface'),
                CognitivePanelStyles.vGap(CognitivePanelStyles.fieldLabelSpacing, spacingFactor),
                _ComplexityDropdown(controller: controller),

                CognitivePanelStyles.vGap(CognitivePanelStyles.sectionSpacing, spacingFactor),
                const _FieldLabel(text: 'Modo de Exibição'),
                CognitivePanelStyles.vGap(CognitivePanelStyles.fieldLabelSpacing, spacingFactor),
                _DisplayModeDropdown(
                  controller: controller,
                  complexity: controller.complexity,
                ),

                CognitivePanelStyles.vGap(CognitivePanelStyles.sectionSpacing, spacingFactor),
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

                CognitivePanelStyles.vGap(CognitivePanelStyles.sectionSpacing, spacingFactor),
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
        style: CognitivePanelStyles.fieldLabelStyle(context),
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
                  style: CognitivePanelStyles.sliderLabelStyle(context),
                ),
              ),
              Text(
                valueLabel,
                style: CognitivePanelStyles.sliderValueStyle(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs * internalSpacingFactor),
          ConstrainedBox(
            constraints: CognitivePanelStyles.sliderConstraints,
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
