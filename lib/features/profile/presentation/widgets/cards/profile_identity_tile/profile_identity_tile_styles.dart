import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';

class ProfileIdentityTileStyles {
  // Avatar
  static const double minHeight = AppSizes.minTapArea; // AppSizes.minTapArea
  static const double avatarSize = AppSizes.avatarMD;
  static const double avatarIconSize = AppSizes.iconMD; // Default icon size, usually 24
  
  static const List<Color> avatarGradient = [
    AppColors.gradientStart,
    AppColors.gradientEnd,
  ];

  static List<BoxShadow> avatarShadow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: AppOpacity.soft),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static const Icon avatarIcon = Icon(Icons.person, color: Colors.white);
}
