import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header_styles.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';

enum MindEaseNavItem { dashboard, tasks, profile }

class MindEaseHeader extends StatelessWidget implements PreferredSizeWidget {
  final MindEaseNavItem current;
  final ValueChanged<MindEaseNavItem> onNavigate;
  final String userLabel;
  final VoidCallback onLogout;
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
    final w = MediaQuery.sizeOf(context).width;
    return w < 600;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileByWidth(context);

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: MindEaseHeaderStyles.toolbarHeight(context),
      elevation: MindEaseHeaderStyles.elevation,
      centerTitle: MindEaseHeaderStyles.centerTitle,
      backgroundColor: MindEaseHeaderStyles.backgroundColor(context),
      surfaceTintColor: MindEaseHeaderStyles.surfaceTintColor,
      titleSpacing: isMobile ? 0 : MindEaseHeaderStyles.titleSpacing,
      title: isMobile
          ? _BrandTitle(logo: logo, label: '')
          : Row(
              children: [
                _BrandTitle(logo: logo, label: 'MindEase'),
                Expanded(
                  child: Center(
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: _WebNavBar(
                          current: current,
                          onNavigate: onNavigate,
                        ),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: MindEaseHeaderStyles.userMaxWidth + 60,
                  ),
                  child: _UserMenu(
                    userLabel: userLabel,
                    onNavigate: onNavigate,
                    onLogout: onLogout,
                  ),
                ),
                MindEaseHeaderStyles.rightGap,
              ],
            ),
      actions: isMobile
          ? <Widget>[
              // Sininho com contador — mobile
              Consumer<NotificationController>(
                builder: (_, nc, __) => _NotificationBell(
                  unreadCount: nc.unreadCount,
                  onTap: () => nc.markAllAsRead(),
                ),
              ),
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

// ── Brand ──────────────────────────────────────────────────────────────────────

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

// ── Nav bar desktop ─────────────────────────────────────────────────────────────

class _WebNavBar extends StatelessWidget {
  final MindEaseNavItem current;
  final ValueChanged<MindEaseNavItem> onNavigate;

  const _WebNavBar({required this.current, required this.onNavigate});

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

// ── User Menu (desktop) ─────────────────────────────────────────────────────────

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
    final nc = context.watch<NotificationController>();

    return Semantics(
      label: 'Menu do usuário: $userLabel',
      button: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sininho com contador ao lado do nome (desktop)
          _NotificationBell(
            unreadCount: nc.unreadCount,
            onTap: () => nc.markAllAsRead(),
          ),
          const SizedBox(width: AppSpacing.xs),
          PopupMenuButton<String>(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: MindEaseHeaderStyles.userIconSize,
                      color: MindEaseHeaderStyles.userIconColor(context),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        userLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MindEaseHeaderStyles.userLabelStyle(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sininho com contador ────────────────────────────────────────────────────────

class _NotificationBell extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBell({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          key: const Key('notification_bell'),
          onPressed: onTap,
          icon: const Icon(Icons.notifications_none_outlined),
          tooltip: 'Notificações',
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
