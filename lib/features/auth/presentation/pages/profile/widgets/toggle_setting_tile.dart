import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

class ToggleSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticsLabel;

  const ToggleSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Regra Hacka: "Ocultar distrações" remove textos secundários
    // (menos ruído cognitivo)
    final hideDistractions = context.select<ProfilePreferencesController, bool>(
      (c) => c.hideDistractions,
    );

    final Widget? effectiveSubtitle = (subtitle == null || hideDistractions)
        ? null
        : Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall,
          );

    return MergeSemantics(
      child: Semantics(
        container: true,
        label: semanticsLabel,
        toggled: value,
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
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
