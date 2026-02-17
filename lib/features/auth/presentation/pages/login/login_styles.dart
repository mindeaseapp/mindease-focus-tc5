import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/tokens/app_typography.dart';

class LoginStyles {
  // Typography
  static final TextStyle title = AppTypography.h2.copyWith(
    fontWeight: AppTypography.bold,
  );

  static final TextStyle brand = AppTypography.h1.copyWith(
    color: AppColors.textOnPrimary,
  );

  static final TextStyle subtitle = AppTypography.displaySmall.copyWith(
    color: AppColors.textOnPrimary,
  );

  static final TextStyle description = AppTypography.body.copyWith(
    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
  );

  static final TextStyle formSubtitle = AppTypography.bodySmall.copyWith(
    color: AppColors.textSecondary,
    fontWeight: AppTypography.medium,
  );

  static final TextStyle noAccountText = AppTypography.bodySmall.copyWith(
    color: AppColors.textSecondary,
  );

  static final TextStyle signUpLink = AppTypography.bodySmall.copyWith(
    color: AppColors.primary,
    fontWeight: AppTypography.semiBold,
  );

  // Spacing & Dimensions
  static const double cardPadding = AppSpacing.xl;
  static const double iconContainerRadius = AppSpacing.radiusSm;
  static const double iconContainerPadding = AppSpacing.sm;
  static const EdgeInsets brandIconPadding = EdgeInsets.all(iconContainerPadding);
  static const BoxConstraints desktopCardConstraints = BoxConstraints(maxWidth: 420);
  
  // Decorations
  static BoxDecoration brandIconDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: AppOpacity.medium),
      borderRadius: BorderRadius.circular(iconContainerRadius),
    );
  }
}

class FeatureCardStyles {
  // Dimensions
  static const double minHeight = AppSizes.featureCardMinHeight;
  static const double responsiveWidth = AppSizes.featureCardWidth;

  // Padding
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.lg,
  );
  
  static const EdgeInsets iconPadding = EdgeInsets.all(AppSpacing.sm);

  // Decorations
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.textOnPrimary.withValues(alpha: AppOpacity.soft),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      border: Border.all(
        color: AppColors.textOnPrimary.withValues(alpha: AppOpacity.medium),
        width: 1,
      ),
    );
  }

  static BoxDecoration iconDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.textOnPrimary.withValues(alpha: AppOpacity.medium),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    );
  }

  // Typography & Icons
  static final TextStyle title = AppTypography.bodySmall.copyWith(
    color: AppColors.textOnPrimary,
    fontWeight: AppTypography.medium,
  );

  static const Color iconColor = AppColors.textOnPrimary;
  static const double iconSize = AppSizes.iconLG;
}
