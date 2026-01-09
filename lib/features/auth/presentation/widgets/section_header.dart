import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        children: [
          Icon(icon, size: 18),
          AppSpacing.hGapSm,
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
