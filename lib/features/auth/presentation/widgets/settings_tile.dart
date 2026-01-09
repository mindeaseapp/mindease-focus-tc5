import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

class SettingsTileData {
  final Key? key;
  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  const SettingsTileData({
    this.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.semanticsLabel,
  });

  bool get isInteractive => onTap != null;
}

class SettingsTile extends StatelessWidget {
  final SettingsTileData data;

  const SettingsTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ListTile já respeita alvos de toque grandes (>= 48dp).
    // Mesmo assim garantimos altura mínima.
    return Semantics(
      button: data.isInteractive,
      enabled: data.isInteractive,
      label: data.semanticsLabel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTapArea),
        child: ListTile(
          key: data.key,
          contentPadding: EdgeInsets.zero,
          leading: data.leading,
          title: Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: data.subtitle == null
              ? null
              : Text(
                  data.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          onTap: data.onTap,
        ),
      ),
    );
  }
}
