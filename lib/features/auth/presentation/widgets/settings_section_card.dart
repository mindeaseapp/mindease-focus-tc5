import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/app_card.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/section_header.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class SettingsSectionCard extends StatelessWidget {
  final String semanticsLabel;
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SettingsSectionCard({
    super.key,
    required this.semanticsLabel,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      semanticsLabel: semanticsLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: icon, title: title),
          AppSpacing.gapMd,
          ...children,
        ],
      ),
    );
  }
}
