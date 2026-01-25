import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/shared/widgets/focus_mode/mindease_accessibility_fab_styles.dart';

class MindEaseAccessibilityFab extends StatefulWidget {
  const MindEaseAccessibilityFab({super.key, this.showHelp = true});

  final bool showHelp;

  @override
  State<MindEaseAccessibilityFab> createState() => _MindEaseAccessibilityFabState();
}

class _MindEaseAccessibilityFabState extends State<MindEaseAccessibilityFab> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  void _togglePopover() {
    if (_entry == null) {
      _show();
    } else {
      _hide();
    }
  }

  void _show() {
    final overlay = Overlay.of(context, rootOverlay: true);
    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hide,
                child: const SizedBox.shrink(),
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: Alignment.topRight,
              followerAnchor: Alignment.bottomRight,
              offset: MindEaseAccessibilityFabStyles.popoverOffset,
              child: _AccessibilityPopover(onClose: _hide),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expandFab = CompositedTransformTarget(
      link: _link,
      child: Semantics(
        button: true,
        label: 'Expandir',
        child: FloatingActionButton.small(
          heroTag: 'fab_expand',
          tooltip: 'Expandir',
          elevation: 2,
          backgroundColor: MindEaseAccessibilityFabStyles.fabBg(context),
          foregroundColor: MindEaseAccessibilityFabStyles.fabFg(context),
          onPressed: _togglePopover,
          child: const Icon(Icons.open_in_full_rounded),
        ),
      ),
    );

    final helpFab = Semantics(
      button: true,
      label: 'Ajuda',
      child: FloatingActionButton.small(
        heroTag: 'fab_help',
        tooltip: 'Ajuda',
        elevation: 2,
        backgroundColor: MindEaseAccessibilityFabStyles.fabBg(context),
        foregroundColor: MindEaseAccessibilityFabStyles.fabFg(context),
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Ajuda'),
              content: const Text('Acessibilidade e modo foco.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.help_outline_rounded),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        expandFab,
        if (widget.showHelp) ...[
          const SizedBox(height: 10),
          helpFab,
        ],
      ],
    );
  }
}

class _AccessibilityPopover extends StatelessWidget {
  const _AccessibilityPopover({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusModeController>();
    final enabled = focus.enabled;

    final maxW = MindEaseAccessibilityFabStyles.popoverMaxWidthFor(context);

    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Card(
          elevation: MindEaseAccessibilityFabStyles.cardElevation,
          shadowColor: MindEaseAccessibilityFabStyles.shadowColor(),
          shape: RoundedRectangleBorder(
            borderRadius: MindEaseAccessibilityFabStyles.cardRadius(),
          ),
          child: Padding(
            padding: MindEaseAccessibilityFabStyles.cardPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Acessibilidade',
                        style: MindEaseAccessibilityFabStyles.popoverTitle(context),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fechar',
                      onPressed: onClose,
                      icon: const Icon(Icons.close_fullscreen_rounded, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _FocusModeTile(
                  enabled: enabled,
                  onTap: () => context.read<FocusModeController>().toggle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusModeTile extends StatelessWidget {
  const _FocusModeTile({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = enabled ? 'Modo Foco Ativo' : 'Ativar Modo Foco';
    final icon = enabled ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    return Semantics(
      button: true,
      label: enabled ? 'Desativar modo foco' : 'Ativar modo foco',
      child: InkWell(
        borderRadius: MindEaseAccessibilityFabStyles.tileRadius(),
        onTap: onTap,
        child: Container(
          padding: MindEaseAccessibilityFabStyles.tilePadding(),
          decoration: BoxDecoration(
            color: MindEaseAccessibilityFabStyles.tileBg(context, enabled: enabled),
            borderRadius: MindEaseAccessibilityFabStyles.tileRadius(),
            border: Border.all(
              color: MindEaseAccessibilityFabStyles.tileBorder(context, enabled: enabled),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: MindEaseAccessibilityFabStyles.tileTitleColor(
                      context,
                      enabled: enabled,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MindEaseAccessibilityFabStyles.tileTitle(
                        context,
                        enabled: enabled,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!enabled)
                Text(
                  'Remova distrações da interface',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: MindEaseAccessibilityFabStyles.tileBody(context, alpha: 0.65),
                ),
              if (enabled)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: MindEaseAccessibilityFabStyles.checkColor(context),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Elementos não essenciais ocultos',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: MindEaseAccessibilityFabStyles.tileBody(context, alpha: 0.7),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
