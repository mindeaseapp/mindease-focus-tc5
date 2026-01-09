import 'package:flutter/material.dart';

@immutable
sealed class ProfileSectionData {
  const ProfileSectionData();
}

@immutable
class ProfileIdentitySectionData extends ProfileSectionData {
  final String title;
  final IconData icon;

  final String name;
  final String email;

  final VoidCallback? onTap;

  const ProfileIdentitySectionData({
    required this.title,
    required this.icon,
    required this.name,
    required this.email,
    this.onTap,
  });
}

@immutable
class ProfileWidgetSectionData extends ProfileSectionData {
  final Widget child;

  const ProfileWidgetSectionData({required this.child});
}

@immutable
class SwitchTileData {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticsLabel;

  const SwitchTileData({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.semanticsLabel,
  });
}

@immutable
class ProfileSwitchesSectionData extends ProfileSectionData {
  final String title;
  final IconData icon;
  final List<SwitchTileData> tiles;

  const ProfileSwitchesSectionData({
    required this.title,
    required this.icon,
    required this.tiles,
  });
}
