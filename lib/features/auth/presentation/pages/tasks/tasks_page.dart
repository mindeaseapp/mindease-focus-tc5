import 'package:flutter/material.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:provider/provider.dart';

import 'package:mindease_focus/features/routes.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';

import 'package:mindease_focus/shared/widgets/mindease_header/mindease_header.dart';
import 'package:mindease_focus/shared/widgets/mindease_drawer/mindease_drawer.dart';
import 'package:mindease_focus/shared/tokens/app_sizes.dart';

import 'package:mindease_focus/shared/widgets/focus_mode/mindease_accessibility_fab.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/pomodoro_timer.dart';
import 'package:mindease_focus/features/auth/presentation/pages/tasks/widgets/kanban_board.dart';

import 'package:mindease_focus/features/auth/presentation/pages/tasks/tasks_page_styles.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isFocusMode = context.watch<FocusModeController>().enabled;

    final args = ModalRoute.of(context)?.settings.arguments;
    final initialTab = (args is int) ? args : 0;

    final effectiveInitialTab = isFocusMode ? 0 : initialTab;

    final safeInitialIndex =
        effectiveInitialTab.clamp(0, TasksPageStyles.tabCount - 1).toInt();

    final prefs = context.watch<ProfilePreferencesController>();
    final highContrast = prefs.highContrast;
    final hideDistractions = prefs.hideDistractions;

    final authController = context.watch<AuthController>();
    final userEntity = authController.user;

    final userLabel = (userEntity.name.isNotEmpty)
        ? userEntity.name
        : (userEntity.email.isNotEmpty ? userEntity.email : 'Usuário');

    void goTo(MindEaseNavItem item) {
      switch (item) {
        case MindEaseNavItem.dashboard:
          Navigator.of(context).popUntil((route) => route.settings.name == AppRoutes.dashboard);
          break;
        case MindEaseNavItem.tasks:
          break;
        case MindEaseNavItem.profile:
          Navigator.of(context).pushNamed(AppRoutes.profile);
          break;
      }
    }

    void logout() {
      context.read<AuthController>().logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (_) => false,
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final tabBarBackgroundColor = TasksPageStyles.tabBarBackgroundColor(context);
    final selectedItemColor = TasksPageStyles.tabSelectedItemColor(context, isDarkMode: isDarkMode);
    final unselectedItemColor = TasksPageStyles.tabUnselectedItemColor(context, isDarkMode: isDarkMode);

    return DefaultTabController(
      length: TasksPageStyles.tabCount,
      initialIndex: safeInitialIndex,
      child: Scaffold(
        appBar: MindEaseHeader(
          current: MindEaseNavItem.tasks,
          userLabel: userLabel,
          onNavigate: goTo,
          onLogout: logout,
        ),

        drawer: AppSizes.isMobile(context) && !isFocusMode
            ? MindEaseDrawer(
                current: MindEaseNavItem.tasks,
                onNavigate: goTo,
                onLogout: logout,
              )
            : null,

        floatingActionButton: const MindEaseAccessibilityFab(),

        body: Column(
          children: [
            if (!isFocusMode)
              Container(
                width: double.infinity,
                color: tabBarBackgroundColor,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: selectedItemColor,
                  unselectedLabelColor: unselectedItemColor,
                  indicatorColor: selectedItemColor,
                  indicatorWeight: TasksPageStyles.tabIndicatorWeight,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.timer_outlined, size: TasksPageStyles.tabIconSize),
                      text: 'Foco',
                    ),
                    Tab(
                      icon: Icon(Icons.view_kanban_outlined, size: TasksPageStyles.tabIconSize),
                      text: 'Tarefas',
                    ),
                  ],
                ),
              ),

            Expanded(
              child: TabBarView(
                physics: isFocusMode
                    ? const ClampingScrollPhysics()
                    : const BouncingScrollPhysics(),
                children: [
                  _PomodoroTabContent(
                    highContrast: highContrast,
                    hideDistractions: hideDistractions,
                  ),
                  _KanbanTabContent(
                    highContrast: highContrast,
                    hideDistractions: hideDistractions,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PomodoroTabContent extends StatelessWidget {
  final bool highContrast;
  final bool hideDistractions;

  const _PomodoroTabContent({
    required this.highContrast,
    required this.hideDistractions,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: TasksPageStyles.pomodoroPadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: TasksPageStyles.pomodoroMaxWidth,
              ),
              child: Column(
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Seu tempo de foco',
                      style: TasksPageStyles.pomodoroTitleText,
                    ),
                  ),
                  const SizedBox(height: TasksPageStyles.pomodoroTitleSpacing),
                  PomodoroTimer(
                    highContrast: highContrast,
                    hideDistractions: hideDistractions,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _KanbanTabContent extends StatefulWidget {
  final bool highContrast;
  final bool hideDistractions;

  const _KanbanTabContent({
    required this.highContrast,
    this.hideDistractions = false,
  });

  @override
  State<_KanbanTabContent> createState() => _KanbanTabContentState();
}

class _KanbanTabContentState extends State<_KanbanTabContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < TasksPageStyles.mobileBreakpoint;

        if (taskController.isLoading && taskController.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          color: TasksPageStyles.kanbanBackgroundColor(context),
          child: Padding(
            padding: TasksPageStyles.kanbanPadding(isMobile: isMobile),
            child: Column(
              children: [
                if (taskController.error != null)
                  Container(
                    padding: TasksPageStyles.errorPadding,
                    margin: TasksPageStyles.errorMargin,
                    decoration: BoxDecoration(
                      color: TasksPageStyles.errorBackground(),
                      borderRadius: TasksPageStyles.errorRadius(),
                    ),
                    child: Row(
                      children: [
                        TasksPageStyles.errorIcon,
                        const SizedBox(width: TasksPageStyles.errorIconGap),
                        Expanded(
                          child: Text(
                            taskController.error!,
                            style: TasksPageStyles.errorText,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: KanbanBoard(
                    highContrast: widget.highContrast,
                    hideDistractions: widget.hideDistractions,
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
