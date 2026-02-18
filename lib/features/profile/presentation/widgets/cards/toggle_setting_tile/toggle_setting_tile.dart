import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

class ToggleSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticsLabel;

  // ✅ NOVO (opcional): permite travar o switch
  final bool enabled;

  // ✅ NOVO (opcional): texto a mostrar quando estiver travado
  // (ex.: "Disponível no modo Médio/Avançado")
  final String? disabledReason;

  const ToggleSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.semanticsLabel,
    this.enabled = true,
    this.disabledReason,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Regra Hacka: "Ocultar distrações" remove textos secundários
    final hideDistractions = context.select<ProfilePreferencesController, bool>(
      (c) => c.hideDistractions,
    );

    // ✅ se estiver desabilitado, prioriza o motivo (quando existir)
    final String? effectiveSubtitleText = enabled ? subtitle : (disabledReason ?? subtitle);

    final Widget? effectiveSubtitle =
        (effectiveSubtitleText == null || hideDistractions)
            ? null
            : Text(
                effectiveSubtitleText,
                style: Theme.of(context).textTheme.bodySmall,
              );

    return MergeSemantics(
      child: Semantics(
        container: true,
        enabled: enabled,
        label: semanticsLabel,
        toggled: value,
        // opcional: dá uma dica pro leitor de tela quando estiver travado
        hint: enabled ? null : (disabledReason ?? 'Opção desativada'),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapArea),
          child: SwitchListTile.adaptive(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: effectiveSubtitle,
            value: value,
            onChanged: enabled ? onChanged : null, // ✅ trava de verdade
          ),
        ),
      ),
    );
  }
}
