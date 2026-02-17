import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';

class ProfileIdentityTileStyles {
  // Avatar
  static const double minHeight = 48; // AppSizes.minTapArea
  static const double avatarSize = 44;
  static const double avatarIconSize = 24; // Default icon size, usually 24
  
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
