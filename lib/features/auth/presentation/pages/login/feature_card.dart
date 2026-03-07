import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/features/auth/presentation/pages/login/login_styles.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: FeatureCardStyles.minHeight,
      ),
      child: Container(
        padding: FeatureCardStyles.contentPadding,
        decoration: FeatureCardStyles.cardDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: FeatureCardStyles.iconPadding,
              decoration: FeatureCardStyles.iconDecoration(context),
              child: Icon(
                icon,
                color: FeatureCardStyles.iconColor,
                size: FeatureCardStyles.iconSize,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              title,
              textAlign: TextAlign.center,
              style: FeatureCardStyles.title,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCardsRow extends StatelessWidget {
  const FeatureCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start, 
      children: [
        _buildResponsiveBox(
          isMobile,
          const FeatureCard(
            icon: Icons.palette_outlined,
            title: 'Interface\nPersonalizável',
          ),
        ),
        _buildResponsiveBox(
          isMobile,
          const FeatureCard(
            icon: Icons.psychology_outlined,
            title: 'Modo Foco',
          ),
        ),
        _buildResponsiveBox(
          isMobile,
          const FeatureCard(
            icon: Icons.notifications_active_outlined,
            title: 'Alertas',
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveBox(bool isMobile, Widget child) {
    return SizedBox(
      width: isMobile ? double.infinity : FeatureCardStyles.responsiveWidth,
      child: child,
    );
  }
}
