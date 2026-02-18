import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/routes.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';

import 'package:mindease_focus/shared/layout/centered_constrained.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';
import 'package:mindease_focus/shared/tokens/app_spacing.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';
import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';

import 'package:mindease_focus/shared/widgets/focus_mode/mindease_accessibility_fab.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';

import 'package:mindease_focus/features/dashboard/presentation/pages/dashboard_styles.dart';
import 'package:mindease_focus/features/profile/presentation/widgets/cards/modal/welcome_modal.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/tasks/domain/models/task_model.dart';

class DashboardRouteArgs {
  final bool showWelcome;
  const DashboardRouteArgs({this.showWelcome = false});
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _welcomeHandled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleWelcomeModal();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  void _handleWelcomeModal() {
    if (_welcomeHandled) return;
    _welcomeHandled = true;

    final args = ModalRoute.of(context)?.settings.arguments;

    final shouldShowWelcome =
        (args is DashboardRouteArgs && args.showWelcome) ||
        (args is Map && args['showWelcome'] == true);

    if (!shouldShowWelcome) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const WelcomeModal(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final userEntity = authController.user;

    final isFocusMode = context.watch<FocusModeController>().enabled;

    final prefs = context.watch<ProfilePreferencesController>();
    final highContrast = prefs.highContrast;
    final hideDistractions = prefs.hideDistractions;

    final userLabel = (userEntity.name.isNotEmpty)
        ? userEntity.name
        : (userEntity.email.isNotEmpty ? userEntity.email : 'Usuário');

    void goTo(MindEaseNavItem item) {
      switch (item) {
        case MindEaseNavItem.dashboard:
          return;
        case MindEaseNavItem.tasks:
          Navigator.of(context).pushNamed(
            AppRoutes.tasks,
            arguments: 1,
          );
          return;
        case MindEaseNavItem.profile:
          Navigator.of(context).pushNamed(AppRoutes.profile);
          return;
      }
    }

    void logout() {
      context.read<AuthController>().logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
    }

    final metrics = <_MetricData>[
      const _MetricData(
        kind: DashboardMetricKind.done,
        title: 'Tarefas Concluídas',
        value: '12',
        subtitle: 'Esta semana',
        icon: Icons.checklist_rounded,
      ),
      const _MetricData(
        kind: DashboardMetricKind.focus,
        title: 'Tempo de Foco',
        value: '3h 45m',
        subtitle: 'Hoje',
        icon: Icons.timer_outlined,
      ),
      const _MetricData(
        kind: DashboardMetricKind.productivity,
        title: 'Produtividade',
        value: '+24%',
        subtitle: 'vs. semana passada',
        icon: Icons.trending_up_rounded,
      ),
    ];

    final taskController = context.watch<TaskController>();
    final recentTasks = taskController.tasks.take(3).map((task) {
      DashboardTaskPillKind pillKind;
      String pillLabel;

      switch (task.status) {
        case TaskStatus.done:
          pillKind = DashboardTaskPillKind.done;
          pillLabel = 'concluída';
          break;
        case TaskStatus.inProgress:
          pillKind = DashboardTaskPillKind.inProgress;
          pillLabel = 'em andamento';
          break;
        case TaskStatus.todo:
          pillKind = DashboardTaskPillKind.pending;
          pillLabel = 'pendente';
          break;
      }

      return _RecentTaskData(
        title: task.title,
        pill: pillKind,
        pillLabel: pillLabel,
        meta: task.timeSpent ?? '',
      );
    }).toList();

    return Scaffold(
      appBar: MindEaseHeader(
        current: MindEaseNavItem.dashboard,
        userLabel: userLabel,
        onNavigate: goTo,
        onLogout: logout,
      ),

      drawer: AppSizes.isMobile(context) && !isFocusMode
          ? MindEaseDrawer(
              current: MindEaseNavItem.dashboard,
              onNavigate: goTo,
              onLogout: logout,
            )
          : null,

      backgroundColor: DashboardPageStyles.pageBg(context),

      floatingActionButton: const MindEaseAccessibilityFab(),

      body: SafeArea(
        top: false,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: CenteredConstrained(
            maxWidth: DashboardPageStyles.maxWidth,
            padding: DashboardPageStyles.contentPadding(context),
            child: SingleChildScrollView(
              physics: DashboardPageStyles.scrollPhysics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Dashboard',
                      style: DashboardPageStyles.pageTitleStyle(context),
                    ),
                  ),
                  if (!hideDistractions) ...[
                    AppSpacing.gapSm,
                    Text(
                      'Bem-vindo de volta! Aqui está seu resumo de hoje.',
                      style: DashboardPageStyles.pageSubtitleStyle(context),
                    ),
                  ],
                  AppSpacing.gapXl,

                  if (!isFocusMode) ...[
                    _MetricsGrid(
                      metrics: metrics,
                      highContrast: highContrast,
                      hideDistractions: hideDistractions,
                    ),
                    AppSpacing.gapXl,
                  ],

                  _FocusModeBanner(
                    onConfigure: () => Navigator.of(context).pushNamed(
                      AppRoutes.tasks,
                      arguments: 0,
                    ),
                    hideDistractions: hideDistractions,
                  ),
                  AppSpacing.gapXl,

                  if (!isFocusMode) ...[
                    _RecentTasksCard(
                      tasks: recentTasks,
                      highContrast: highContrast,
                      onSeeAll: () => Navigator.of(context).pushNamed(
                        AppRoutes.tasks,
                        arguments: 1,
                      ),
                    ),
                    
                    AppSpacing.gapXl,
                    _TipOfDayCard(
                      highContrast: highContrast,
                      hideDistractions: hideDistractions,
                    ),

                    AppSpacing.gapXl,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricData {
  final DashboardMetricKind kind;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _MetricData({
    required this.kind,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}

class _MetricsGrid extends StatelessWidget {
  final List<_MetricData> metrics;
  final bool highContrast;
  final bool hideDistractions;

  const _MetricsGrid({
    required this.metrics,
    required this.highContrast,
    required this.hideDistractions,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= DashboardPageStyles.metricsWideBreakpoint;
        final gap = AppSpacing.lg.toDouble();
        final cardWidth = isWide ? (c.maxWidth - (gap * 2)) / 3 : c.maxWidth;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: cardWidth,
                child: _MetricCard(
                  data: metric,
                  highContrast: highContrast,
                  hideDistractions: hideDistractions,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;
  final bool highContrast;
  final bool hideDistractions;

  const _MetricCard({
    required this.data,
    required this.highContrast,
    required this.hideDistractions,
  });

  @override
  Widget build(BuildContext context) {
    final accent = DashboardPageStyles.metricAccent(data.kind, context, highContrast: highContrast);

    return Semantics(
      container: true,
      label: '${data.title}. ${data.value}. ${data.subtitle}.',
      child: Card(
        elevation: DashboardPageStyles.cardElevation,
        shape: DashboardPageStyles.cardShape(context, highContrast: highContrast),
        color: DashboardPageStyles.cardBg(context, highContrast: highContrast),
        child: Padding(
          padding: DashboardPageStyles.cardPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      style: DashboardPageStyles.metricTitleStyle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    width: DashboardPageStyles.metricIconBox,
                    height: DashboardPageStyles.metricIconBox,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: DashboardPageStyles.metricIconRadius(),
                    ),
                    child: Icon(
                      data.icon,
                      size: 18,
                      color: DashboardPageStyles.metricIconFg(context, highContrast: highContrast),
                      semanticLabel: '',
                    ),
                  ),
                ],
              ),
              AppSpacing.gapLg,
              Text(
                data.value,
                style: DashboardPageStyles.metricValueStyle(context),
              ),
              
              if (!hideDistractions) ...[
                AppSpacing.gapXs,
                Text(
                  data.subtitle,
                  style: DashboardPageStyles.metricSubtitleStyle(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusModeBanner extends StatelessWidget {
  final VoidCallback onConfigure;
  final bool hideDistractions;

  const _FocusModeBanner({
    required this.onConfigure,
    this.hideDistractions = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isMobile = c.maxWidth < DashboardPageStyles.mobileBreakpoint;

        final titleText = isMobile ? 'Modo Foco\nAtivo' : 'Modo Foco Ativo';
        final subtitleText = hideDistractions
            ? ''
            : (isMobile
                ? 'Interface simplificada\npara máxima\nconcentração'
                : 'Interface simplificada para máxima concentração');

        return Semantics(
          container: true,
          label: 'Modo foco ativo. Configurar.',
          child: Container(
            decoration: BoxDecoration(
              color: DashboardPageStyles.focusBannerBg(context),
              borderRadius: DashboardPageStyles.focusBannerRadius(),
              border: Border.all(
                color: DashboardPageStyles.focusBannerBorder(context),
                width: 1,
              ),
            ),
            padding: DashboardPageStyles.focusBannerPadding(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.psychology_alt_rounded,
                  size: DashboardPageStyles.focusBannerIconSize,
                  color: DashboardPageStyles.focusBannerIconColor(context),
                  semanticLabel: '',
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleText,
                        style: DashboardPageStyles.focusBannerTitleStyle(context),
                      ),
                      if (subtitleText.isNotEmpty) ...[
                        AppSpacing.gapSm,
                        Text(
                          subtitleText,
                          style: DashboardPageStyles.focusBannerSubtitleStyle(context),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Semantics(
                  button: true,
                  label: 'Configurar modo foco',
                  child: ElevatedButton(
                    onPressed: onConfigure,
                    style: ElevatedButton.styleFrom(
                      padding: DashboardPageStyles.focusBannerButtonPadding(),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text('Configurar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentTaskData {
  final String title;
  final DashboardTaskPillKind pill;
  final String pillLabel;
  final String meta;

  const _RecentTaskData({
    required this.title,
    required this.pill,
    required this.pillLabel,
    required this.meta,
  });
}

class _RecentTasksCard extends StatelessWidget {
  final List<_RecentTaskData> tasks;
  final VoidCallback onSeeAll;
  final bool highContrast;

  const _RecentTasksCard({
    required this.tasks,
    required this.onSeeAll,
    required this.highContrast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: DashboardPageStyles.cardElevation,
      shape: DashboardPageStyles.cardShape(context, highContrast: highContrast),
      color: DashboardPageStyles.cardBg(context, highContrast: highContrast),
      child: Padding(
        padding: DashboardPageStyles.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Tarefas Recentes',
                      style: DashboardPageStyles.sectionTitleStyle(context),
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Ver todas as tarefas',
                  child: TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'Ver todas',
                    style: DashboardPageStyles.sectionLinkStyle(context),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                'Não há tarefas cadastradas',
                style: DashboardPageStyles.metricSubtitleStyle(context),
              ),
            )
          else
            for (int i = 0; i < tasks.length; i++) ...[
              _RecentTaskTile(
                data: tasks[i],
                highContrast: highContrast,
              ),
              if (i < tasks.length - 1) AppSpacing.gapMd,
            ],
        ],
      ),
    ),
    );
  }
}

class _RecentTaskTile extends StatelessWidget {
  final _RecentTaskData data;
  final bool highContrast;

  const _RecentTaskTile({
    required this.data,
    required this.highContrast,
  });

  @override
  Widget build(BuildContext context) {
    final pillBg = DashboardPageStyles.pillBg(data.pill, highContrast: highContrast);
 

    return Semantics(
      container: true,
      label: 'Tarefa: ${data.title}. Status: ${data.pillLabel}. '
          '${data.meta.isEmpty ? '' : data.meta}.',
      child: Container(
        decoration: BoxDecoration(
          color: DashboardPageStyles.taskTileBg(context),
          borderRadius: DashboardPageStyles.taskTileRadius(),
        ),
        padding: DashboardPageStyles.taskTilePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: DashboardPageStyles.taskTitleStyle(context),
            ),
            AppSpacing.gapSm,
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.md.toDouble(),
              runSpacing: AppSpacing.sm.toDouble(),
              children: [
                Container(
                  padding: DashboardPageStyles.pillPadding(),
                  decoration: BoxDecoration(
                    color: pillBg,
                    borderRadius: DashboardPageStyles.pillRadius(),
                    border: DashboardPageStyles.pillBorder(context, highContrast: highContrast),
                  ),
                  child: Text(
                    data.pillLabel,
                    style: DashboardPageStyles.pillTextStyle(
                      context,
                      data.pill,
                      highContrast: highContrast,
                    ),
                  ),
                ),
                if (data.meta.isNotEmpty)
                  Text(
                    data.meta,
                    style: DashboardPageStyles.taskMetaStyle(context).copyWith(
                      color: highContrast
                          ? Theme.of(context).colorScheme.onSurface 
                          : null, 
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TipOfDayCard extends StatelessWidget {
  final bool highContrast;
  final bool hideDistractions;

  const _TipOfDayCard({
    this.highContrast = false,
    this.hideDistractions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Dica do dia. Faça pausas regulares. O método Pomodoro sugere '
          '5 minutos de descanso a cada 25 minutos de trabalho focado.',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: DashboardPageStyles.tipBg(context, highContrast: highContrast),
          borderRadius: DashboardPageStyles.cardRadius,
          border: Border.all(
            color: DashboardPageStyles.tipBorder(context, highContrast: highContrast),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: DashboardPageStyles.tipIconSize,
                  color: highContrast ? Theme.of(context).colorScheme.onSurface : Colors.orange,
                  semanticLabel: '',
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Dica do Dia',
                    style: DashboardPageStyles.tipTitleStyle(context),
                  ),
                ),
              ],
            ),
            if (!hideDistractions) ...[
              AppSpacing.gapMd,
              Text(
                'Faça pausas regulares! O método Pomodoro sugere 5 minutos de descanso '
                'a cada 25 minutos de trabalho focado. Isso ajuda a manter a '
                'concentração e reduzir a fadiga mental.',
                style: DashboardPageStyles.tipBodyStyle(context),
                softWrap: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
