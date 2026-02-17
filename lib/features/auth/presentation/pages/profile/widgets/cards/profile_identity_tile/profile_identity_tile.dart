import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/pages/profile/widgets/cards/profile_identity_tile/profile_identity_tile_styles.dart';

class ProfileIdentityTile extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onTap;

  const ProfileIdentityTile({
    super.key,
    required this.name,
    required this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final interactive = onTap != null;

    return MergeSemantics(
      child: Semantics(
        container: true,
        button: interactive,
        enabled: interactive,
        label: 'Usuário: $name. Email: $email.',
        hint: interactive ? 'Toque para abrir informações pessoais.' : null,
        onTap: interactive ? onTap : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: ProfileIdentityTileStyles.minHeight),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ExcludeSemantics(
              child: _AvatarGradientIcon(
                semanticsLabel: 'Avatar do usuário',
              ),
            ),
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class _AvatarGradientIcon extends StatelessWidget {
  final String semanticsLabel;

  const _AvatarGradientIcon({
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      image: true,
      child: Container(
        width: ProfileIdentityTileStyles.avatarSize,
        height: ProfileIdentityTileStyles.avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: ProfileIdentityTileStyles.avatarGradient,
          ),
          boxShadow: ProfileIdentityTileStyles.avatarShadow(context),
        ),
        child: ProfileIdentityTileStyles.avatarIcon,
      ),
    );
  }
}
