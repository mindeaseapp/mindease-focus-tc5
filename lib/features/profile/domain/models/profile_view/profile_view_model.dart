import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/widgets/settings_tile.dart';

@immutable
class SettingsSectionData {
  final String title;
  final IconData icon;
  final List<SettingsTileData> tiles;

  const SettingsSectionData({
    required this.title,
    required this.icon,
    required this.tiles,
  });
}

@immutable
class ProfileViewModel {
  final String pageTitle;
  final String pageSubtitle;
  final List<SettingsSectionData> sections;

  const ProfileViewModel({
    required this.pageTitle,
    required this.pageSubtitle,
    required this.sections,
  });

  static ProfileViewModel demo({
    required String name,
    required String email,
    VoidCallback? onOpenPersonalInfo,
  }) {
    return ProfileViewModel(
      pageTitle: 'Perfil & Configurações',
      pageSubtitle: 'Personalize sua experiência no MindEase',
      sections: [
        SettingsSectionData(
          title: 'Informações Pessoais',
          icon: Icons.person_outline,
          tiles: [
            SettingsTileData(
              leading: const _AvatarBadge(
                semanticsLabel: 'Avatar do usuário',
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: name,
              subtitle: email,
              onTap: onOpenPersonalInfo,
              semanticsLabel: 'Informações do usuário: $name, $email',
            ),
          ],
        ),
      ],
    );
  }
}

@immutable
class _AvatarBadge extends StatelessWidget {
  final Widget child;
  final String semanticsLabel;

  const _AvatarBadge({
    required this.child,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      image: true,
      child: ExcludeSemantics(
        child: CircleAvatar(
          radius: 22,
          child: child,
        ),
      ),
    );
  }
}
