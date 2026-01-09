import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/app_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/section_header.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

@immutable
class SettingsSwitchItemData {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  /// A11y (opcional)
  final String? semanticsLabel;
  final String? semanticsHint;

  const SettingsSwitchItemData({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.semanticsLabel,
    this.semanticsHint,
  });
}

class SettingsSwitchesCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SettingsSwitchItemData> items;

  const SettingsSwitchesCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      // ✅ CORRETO: "semanticsLabel" (com S)
      semanticsLabel: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: icon,
            title: title,
          ),
          AppSpacing.gapMd,
          ..._buildTiles(context),
        ],
      ),
    );
  }

  List<Widget> _buildTiles(BuildContext context) {
    final children = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      children.add(
        MergeSemantics(
          child: Semantics(
            container: true,
            label: item.semanticsLabel ?? item.title,
            hint: item.semanticsHint ?? item.subtitle,
            value: item.value ? 'Ativado' : 'Desativado',
            toggled: item.value,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSizes.minTapArea),
              child: SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                subtitle: Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: item.value,
                onChanged: item.onChanged,
              ),
            ),
          ),
        ),
      );

      if (i != items.length - 1) {
        children.add(const Divider());
      }
    }

    return children;
  }
}
