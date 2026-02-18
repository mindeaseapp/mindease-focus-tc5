import 'package:flutter/material.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';

class WelcomeModal extends StatelessWidget {
  const WelcomeModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const features = <_FeatureData>[
      _FeatureData(
        icon: '🎨',
        title: 'Interface Personalizável',
        desc: 'Ajuste complexidade, contraste,\nespaçamento e tamanho da fonte',
        bg: Color(0xFFF0F6FF),
        border: Color(0xFFBFD6FF),
      ),
      _FeatureData(
        icon: '🎯',
        title: 'Modo Foco',
        desc: 'Oculte distrações e mantenha-se\nconcentrado',
        bg: Color(0xFFF6F0FF),
        border: Color(0xFFD8BFFF),
      ),
      _FeatureData(
        icon: '📋',
        title: 'Kanban Simplificado',
        desc: 'Organize tarefas visualmente com arrastar\ne soltar',
        bg: Color(0xFFF0FFF6),
        border: Color(0xFFBFEBD0),
      ),
      _FeatureData(
        icon: '⏰',
        title: 'Timer Pomodoro',
        desc: 'Técnica de foco com pausas programadas',
        bg: Color(0xFFFFF6EF),
        border: Color(0xFFFFD7B8),
      ),
    ];

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(onClose: () => Navigator.of(context).pop(true)),
                AppSpacing.gapLg,

                LayoutBuilder(
                  builder: (_, c) {
                    final isNarrow = c.maxWidth < 720;
                    const gap = 16.0;

                    final cardWidth = isNarrow
                        ? c.maxWidth
                        : (c.maxWidth - gap) / 2; 

                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final f in features)
                          SizedBox(
                            width: cardWidth,
                            child: _FeatureCard(data: f),
                          ),
                      ],
                    );
                  },
                ),

                AppSpacing.gapLg,
                _TipBox(theme: theme),
                AppSpacing.gapXl,

                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 220, height: 44),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Começar a usar'),
                    ),
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

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.psychology_alt_rounded,
            color: theme.colorScheme.onPrimary,
            size: 22,
            semanticLabel: '',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo ao MindEase!',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Vamos conhecer as funcionalidades',
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Fechar',
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

class _TipBox extends StatelessWidget {
  final ThemeData theme;
  const _TipBox({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
          children: const [
            TextSpan(text: '💡  '),
            TextSpan(text: 'Dica: ', style: TextStyle(fontWeight: FontWeight.w800)),
            TextSpan(
              text:
                  'Acesse o seu Perfil para personalizar a interface de acordo com suas necessidades cognitivas. '
                  'Todas as suas preferências são salvas automaticamente.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  final String icon;
  final String title;
  final String desc;
  final Color bg;
  final Color border;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.desc,
    required this.bg,
    required this.border,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  const _FeatureCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
          Text(data.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 10),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            data.desc,
            softWrap: true,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }
}
