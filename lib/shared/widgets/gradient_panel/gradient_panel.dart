import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

class GradientPanel extends StatelessWidget {
  final Widget child;

  const GradientPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // ✅ NÃO quebra se essa tela não tiver o Provider acima dela
    final hideDistractions = context.select<ProfilePreferencesController?, bool>(
      (prefs) => prefs?.hideDistractions ?? false,
    );

    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: hideDistractions
          ? BoxDecoration(
              // ✅ modo foco: reduz estímulo visual (hacka)
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.7),
              ),
            )
          : const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: child,
    );
  }
}
