import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header_styles.dart';

enum MindEaseNavItem { dashboard, tasks, profile }

class MindEaseHeader extends StatelessWidget implements PreferredSizeWidget {
  final MindEaseNavItem current;
  final ValueChanged<MindEaseNavItem> onNavigate;

  /// Texto exibido no canto direito (web) e usado em Semantics
  final String userLabel;

  /// Se você já tem logout em outro lugar, só passa aqui.
  final VoidCallback onLogout;

  /// Widget do logo (se você tiver asset). Se não passar, usa ícone padrão.
  final Widget? logo;

  const MindEaseHeader({
    super.key,
    required this.current,
    required this.onNavigate,
    required this.userLabel,
    required this.onLogout,
    this.logo,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(MindEaseHeaderStyles.preferredHeight);

  bool _isMobile(BuildContext context) => AppSizes.isMobile(context);

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return AppBar(
      // ✅ REMOVE o botão de voltar automático (seta do header)
      automaticallyImplyLeading: false,

      toolbarHeight: MindEaseHeaderStyles.toolbarHeight(context),
      elevation: MindEaseHeaderStyles.elevation,
      centerTitle: MindEaseHeaderStyles.centerTitle,
      backgroundColor: MindEaseHeaderStyles.backgroundColor(context),
      surfaceTintColor: MindEaseHeaderStyles.surfaceTintColor,

      // mantém seu espaçamento padrão
      titleSpacing: MindEaseHeaderStyles.titleSpacing,

      // ✅ MOBILE: Brand no title
      // ✅ WEB: Brand + Nav + Usuário (tudo dentro do title)
      title: isMobile
          ? _BrandTitle(
              logo: logo,
              label: 'MindEase',
            )
          : Row(
              children: [
                _BrandTitle(
                  logo: logo,
                  label: 'MindEase',
                ),
                Expanded(
                  child: Center(
                    child: _WebNavBar(
                      current: current,
                      onNavigate: onNavigate,
                    ),
                  ),
                ),
                _UserMenu(
                  userLabel: userLabel,
                  onNavigate: onNavigate,
                  onLogout: onLogout,
                ),
                MindEaseHeaderStyles.rightGap,
              ],
            ),

      // ✅ MOBILE: ícone do usuário nas actions
      // ✅ WEB: vazio (já está no title)
      actions: isMobile
          ? <Widget>[
              IconButton(
                tooltip: 'Abrir opções do usuário',
                onPressed: () => _openUserMenu(context),
                icon: const Icon(Icons.account_circle_outlined),
              ),
              MindEaseHeaderStyles.mobileActionsGap,
            ]
          : const <Widget>[],
    );
  }

  void _openUserMenu(BuildContext context) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final topRight = box.localToGlobal(
      Offset(box.size.width, 0),
      ancestor: overlay,
    );

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        topRight.dx,
        topRight.dy + AppSizes.appBarHeightFor(context),
        AppSpacing.md,
        0,
      ),
      items: const [
        PopupMenuItem(value: 'profile', child: Text('Perfil')),
        PopupMenuItem(value: 'logout', child: Text('Sair')),
      ],
    ).then((value) {
      if (value == 'profile') {
        onNavigate(MindEaseNavItem.profile);
      } else if (value == 'logout') {
        onLogout();
      }
    });
  }
}

class _BrandTitle extends StatelessWidget {
  final Widget? logo;
  final String label;

  const _BrandTitle({required this.logo, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      label: 'Cabeçalho do app: $label',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MindEaseHeaderStyles.brandLogoBox,
            width: MindEaseHeaderStyles.brandLogoBox,
            child: FittedBox(
              fit: BoxFit.contain,
              child: logo ??
                  Icon(
                    Icons.psychology_alt_rounded,
                    color: MindEaseHeaderStyles.brandIconColor(context),
                  ),
            ),
          ),
          MindEaseHeaderStyles.brandGap,
          Text(
            label,
            style: MindEaseHeaderStyles.brandTextStyle(context),
          ),
        ],
      ),
    );
  }
}

class _WebNavBar extends StatelessWidget {
  final MindEaseNavItem current;
  final ValueChanged<MindEaseNavItem> onNavigate;

  const _WebNavBar({
    required this.current,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WebNavItem(
          label: 'Dashboard',
          icon: Icons.grid_view_outlined,
          selected: current == MindEaseNavItem.dashboard,
          onTap: () => onNavigate(MindEaseNavItem.dashboard),
        ),
        const SizedBox(width: AppSpacing.sm),
        _WebNavItem(
          label: 'Tarefas',
          icon: Icons.checklist_outlined,
          selected: current == MindEaseNavItem.tasks,
          onTap: () => onNavigate(MindEaseNavItem.tasks),
        ),
        const SizedBox(width: AppSpacing.sm),
        _WebNavItem(
          label: 'Perfil',
          icon: Icons.person_outline,
          selected: current == MindEaseNavItem.profile,
          onTap: () => onNavigate(MindEaseNavItem.profile),
        ),
      ],
    );
  }
}

class _WebNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = MindEaseHeaderStyles.navBg(context, selected: selected);
    final fg = MindEaseHeaderStyles.navFg(context, selected: selected);

    return Semantics(
      button: true,
      selected: selected,
      label: 'Ir para $label',
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: MindEaseHeaderStyles.inkRadius,
          overlayColor: MindEaseHeaderStyles.overlayColor(context),
          child: Container(
            constraints: MindEaseHeaderStyles.navItemConstraints,
            padding: MindEaseHeaderStyles.navItemPadding,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: MindEaseHeaderStyles.inkRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: MindEaseHeaderStyles.navIconSize, color: fg),
                MindEaseHeaderStyles.navLabelGap,
                Text(
                  label,
                  style: MindEaseHeaderStyles.navTextStyle(
                    context,
                    selected: selected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserMenu extends StatelessWidget {
  final String userLabel;
  final ValueChanged<MindEaseNavItem> onNavigate;
  final VoidCallback onLogout;

  const _UserMenu({
    required this.userLabel,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Menu do usuário: $userLabel',
      button: true,
      child: PopupMenuButton<String>(
        tooltip: 'Abrir menu do usuário',
        onSelected: (value) {
          if (value == 'profile') onNavigate(MindEaseNavItem.profile);
          if (value == 'logout') onLogout();
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'profile', child: Text('Perfil')),
          PopupMenuItem(value: 'logout', child: Text('Sair')),
        ],
        child: InkWell(
          borderRadius: MindEaseHeaderStyles.inkRadius,
          overlayColor: MindEaseHeaderStyles.overlayColor(context),
          child: Padding(
            padding: MindEaseHeaderStyles.userPadding,
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: MindEaseHeaderStyles.userIconSize,
                  color: MindEaseHeaderStyles.userIconColor(context),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  userLabel,
                  style: MindEaseHeaderStyles.userLabelStyle(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
