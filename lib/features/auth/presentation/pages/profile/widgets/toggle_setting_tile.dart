import 'package:flutter/material.dart';
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
    return Semantics(
      container: true,
      label: semanticsLabel,
      toggled: value,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTapArea),
        child: SwitchListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
