import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_colors.dart';
import 'package:mindease_focus/shared/tokens/app_opacity.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

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
          constraints: const BoxConstraints(minHeight: AppSizes.minTapArea),
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: AppOpacity.soft),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}
