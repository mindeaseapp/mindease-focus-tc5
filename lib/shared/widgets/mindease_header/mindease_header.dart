import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header_styles.dart';

enum MindEaseNavItem { dashboard, tasks, profile }

class MindEaseHeader extends StatelessWidget implements PreferredSizeWidget {
  final MindEaseNavItem current;
  final ValueChanged<MindEaseNavItem> onNavigate;

  /// Texto exibido no canto direito (web) e usado em Semantics
  final String userLabel;

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

  bool _isMobileByWidth(BuildContext context) {
    // ✅ garante comportamento correto no Flutter Web em viewport pequena
    final w = MediaQuery.sizeOf(context).width;
    return w < 600;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileByWidth(context);

    return AppBar(
      // remove seta de voltar padrão
      automaticallyImplyLeading: false,

      toolbarHeight: MindEaseHeaderStyles.toolbarHeight(context),
      elevation: MindEaseHeaderStyles.elevation,
      centerTitle: MindEaseHeaderStyles.centerTitle,
      backgroundColor: MindEaseHeaderStyles.backgroundColor(context),
      surfaceTintColor: MindEaseHeaderStyles.surfaceTintColor,

      // ✅ no mobile, encosta mais o logo na esquerda (igual sua imagem)
      titleSpacing: isMobile ? 0 : MindEaseHeaderStyles.titleSpacing,

      // ✅ MOBILE: só logo (sem texto)
      // ✅ WEB: logo + navbar + menu do usuário
      title: isMobile
          ? _BrandTitle(
              logo: logo,
              label: '', // não renderiza texto
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

      // ✅ MOBILE: hambúrguer na direita abre Drawer (igual sua imagem)
      actions: isMobile
          ? <Widget>[
              Builder(
                builder: (ctx) => IconButton(
                  tooltip: 'Abrir menu',
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
              ),
              MindEaseHeaderStyles.mobileActionsGap,
            ]
          : const <Widget>[],
    );
  }
}

class _BrandTitle extends StatelessWidget {
  final Widget? logo;
  final String label;

  const _BrandTitle({required this.logo, required this.label});

  @override
  Widget build(BuildContext context) {
    final hasLabel = label.trim().isNotEmpty;

    return Semantics(
      container: true,
      header: true,
      label: 'Cabeçalho do app: MindEase',
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
          if (hasLabel) ...[
            MindEaseHeaderStyles.brandGap,
            Text(
              label,
              style: MindEaseHeaderStyles.brandTextStyle(context),
            ),
          ],
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
