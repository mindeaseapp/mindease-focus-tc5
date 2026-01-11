import 'package:flutter/material.dart';

import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer_styles.dart';

class MindEaseDrawer extends StatelessWidget {
  final MindEaseNavItem current;
  final ValueChanged<MindEaseNavItem> onNavigate;
  final VoidCallback onLogout;

  final Widget? logo;

  const MindEaseDrawer({
    super.key,
    required this.current,
    required this.onNavigate,
    required this.onLogout,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MindEaseDrawerStyles.drawerWidth,
      child: SafeArea(
        child: Column(
          children: [
            // ✅ topo: logo + MindEase + botão X
            Padding(
              padding: MindEaseDrawerStyles.topPadding,
              child: Row(
                children: [
                  SizedBox(
                    height: MindEaseDrawerStyles.logoBox,
                    width: MindEaseDrawerStyles.logoBox,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: logo ??
                          Icon(
                            Icons.psychology_alt_rounded,
                            color: MindEaseDrawerStyles.brandIconColor(context),
                          ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'MindEase',
                    style: MindEaseDrawerStyles.brandTextStyle(context),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Fechar menu',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            Divider(color: MindEaseDrawerStyles.dividerColor(context)),

            _DrawerItem(
              label: 'Dashboard',
              icon: Icons.grid_view_outlined,
              selected: current == MindEaseNavItem.dashboard,
              onTap: () {
                Navigator.of(context).pop();
                onNavigate(MindEaseNavItem.dashboard);
              },
            ),
            _DrawerItem(
              label: 'Tarefas',
              icon: Icons.checklist_outlined,
              selected: current == MindEaseNavItem.tasks,
              onTap: () {
                Navigator.of(context).pop();
                onNavigate(MindEaseNavItem.tasks);
              },
            ),

            Divider(color: MindEaseDrawerStyles.dividerColor(context)),

            _DrawerItem(
              label: 'Perfil',
              icon: Icons.person_outline,
              selected: current == MindEaseNavItem.profile,
              onTap: () {
                Navigator.of(context).pop();
                onNavigate(MindEaseNavItem.profile);
              },
            ),

            const SizedBox(height: AppSpacing.sm),

            // ✅ "Sair" vermelho
            Semantics(
              button: true,
              label: 'Sair da conta',
              child: ListTile(
                contentPadding: MindEaseDrawerStyles.logoutPadding,
                minVerticalPadding: 0,
                minLeadingWidth: AppSizes.minTapArea,
                onTap: () {
                  Navigator.of(context).pop();
                  onLogout();
                },
                title: Text(
                  'Sair',
                  style: MindEaseDrawerStyles.logoutTextStyle(context),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = MindEaseDrawerStyles.itemBg(context, selected: selected);
    final fg = MindEaseDrawerStyles.itemFg(context, selected: selected);

    return Semantics(
      button: true,
      selected: selected,
      label: 'Ir para $label',
      child: Padding(
        padding: MindEaseDrawerStyles.itemOuterPadding,
        child: InkWell(
          onTap: onTap,
          borderRadius: MindEaseDrawerStyles.itemRadius,
          child: Container(
            constraints: MindEaseDrawerStyles.itemConstraints,
            padding: MindEaseDrawerStyles.itemInnerPadding,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: MindEaseDrawerStyles.itemRadius,
            ),
            child: Row(
              children: [
                Icon(icon, size: MindEaseDrawerStyles.itemIconSize, color: fg),
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: MindEaseDrawerStyles.itemTextStyle(
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
