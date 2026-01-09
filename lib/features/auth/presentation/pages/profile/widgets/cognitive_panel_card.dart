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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AppCard(
          semanticsLabel: 'Painel Cognitivo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.psychology_outlined,
                title: 'Painel Cognitivo',
              ),
              AppSpacing.gapMd,

              // ✅ const (lint)
              const _FieldLabel(text: 'Nível de Complexidade da Interface'),
              AppSpacing.gapXs,
              _ComplexityDropdown(controller: controller),

              AppSpacing.gapMd,
              // ✅ const (lint)
              const _FieldLabel(text: 'Modo de Exibição'),
              AppSpacing.gapXs,
              _DisplayModeDropdown(controller: controller),

              AppSpacing.gapMd,
              _SliderBlock(
                label: 'Espaçamento entre Elementos',
                valueLabel: controller.spacingLabel,
                sliderValue: controller.spacingSliderValue,
                max: (ElementSpacing.values.length - 1).toDouble(),
                onChanged: controller.setSpacingFromSlider,
                semanticsValue: 'Espaçamento: ${controller.spacingLabel}',
              ),

              AppSpacing.gapMd,
              _SliderBlock(
                label: 'Tamanho da Fonte',
                valueLabel: controller.fontSizeLabel,
                sliderValue: controller.fontSizeSliderValue,
                max: (FontSizePreference.values.length - 1).toDouble(),
                onChanged: controller.setFontSizeFromSlider,
                semanticsValue: 'Fonte: ${controller.fontSizeLabel}',
              ),
            ],
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
        expandedInsets: EdgeInsets.zero, // ocupa a largura disponível
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

  const _DisplayModeDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Modo de Exibição',
      hint: 'Selecione o modo de exibição',
      value: controller.displayMode.label,
      child: DropdownMenu<DisplayMode>(
        expandedInsets: EdgeInsets.zero,
        initialSelection: controller.displayMode,
        label: const Text(''),
        requestFocusOnTap: true,
        dropdownMenuEntries: DisplayMode.values
            .map(
              (e) => DropdownMenuEntry<DisplayMode>(
                value: e,
                label: e.label,
              ),
            )
            .toList(),
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

  const _SliderBlock({
    required this.label,
    required this.valueLabel,
    required this.sliderValue,
    required this.max,
    required this.onChanged,
    required this.semanticsValue,
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
          AppSpacing.gapXs,
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
