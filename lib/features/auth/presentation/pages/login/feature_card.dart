import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

/// Card para exibir features do MindEase/// Card para exibir features do MindEase
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
    // Usamos ConstrainedBox em vez de SizedBox com altura fixa
    // Isso garante que o card tenha no MÍNIMO o tamanho padrão, 
    // mas possa crescer se o texto precisar de mais espaço.
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppSizes.featureCardMinHeight,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withValues(
            alpha: AppOpacity.soft,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: AppColors.textOnPrimary.withValues(
              alpha: AppOpacity.medium,
            ),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Importante para não forçar expansão desnecessária
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withValues(
                  alpha: AppOpacity.medium,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                icon,
                color: AppColors.textOnPrimary,
                size: AppSizes.iconLG,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: AppTypography.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget que exibe os três feature cards
class FeatureCardsRow extends StatelessWidget {
  const FeatureCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start, // Garante alinhamento no topo
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
      width: isMobile ? double.infinity : AppSizes.featureCardWidth,
      child: child,
    );
  }
}