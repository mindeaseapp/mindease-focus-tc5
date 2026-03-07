import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/core/navigation/navigation_service.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/login_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/update_password_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';
import 'package:mindease_focus/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';

import 'package:mindease_focus/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:mindease_focus/features/auth/domain/usecases/register_usecase.dart';
import 'package:mindease_focus/features/auth/domain/usecases/login_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/load_tasks_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:mindease_focus/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:mindease_focus/features/profile/domain/usecases/get_preferences_usecase.dart';
import 'package:mindease_focus/features/profile/domain/usecases/update_preferences_usecase.dart';

import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';

List<SingleChildWidget> get providers {
  final supabase = Supabase.instance.client;

  final navigationService = NavigationService();

  final authDataSource = AuthRemoteDataSource(supabase);
  final profileDataSource = ProfileRemoteDataSourceImpl(supabase);
  final taskDataSource = TaskRemoteDataSourceImpl(supabase);

  final authRepository = AuthRepository(authDataSource);
  final profileRepository = ProfileRepository(profileDataSource);
  final taskRepository = TaskRepository(taskDataSource);

  final getUserUseCase = GetUserUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final loginUseCase = LoginUseCase(authRepository);
  final loadTasksUseCase = LoadTasksUseCase(taskRepository);
  final addTaskUseCase = AddTaskUseCase(taskRepository);
  final updateTaskUseCase = UpdateTaskUseCase(taskRepository);
  final deleteTaskUseCase = DeleteTaskUseCase(taskRepository);
  final getPreferencesUseCase = GetPreferencesUseCase(profileRepository);
  final updatePreferencesUseCase = UpdatePreferencesUseCase(profileRepository);

  return [
    Provider<NavigationService>.value(value: navigationService),
    
    ChangeNotifierProvider(
      create: (_) => AuthController(
        getUserUseCase: getUserUseCase,
        authRepository: authRepository,
        supabaseClient: supabase,
      ),
    ),
    
    Provider<AuthRepository>.value(value: authRepository),
    
    ChangeNotifierProvider(
      create: (_) => LoginController(loginUseCase),
    ),
    ChangeNotifierProvider(
      create: (_) => RegisterController(registerUseCase),
    ),
    ChangeNotifierProvider(
      create: (_) => ResetPasswordController(authRepository),
    ),
    ChangeNotifierProvider(
      create: (_) => UpdatePasswordController(authRepository),
    ),
    
    ChangeNotifierProxyProvider<AuthController, ProfilePreferencesController>(
      create: (_) => ProfilePreferencesController(
        getPreferencesUseCase: getPreferencesUseCase,
        updatePreferencesUseCase: updatePreferencesUseCase,
      ),
      update: (_, authCtrl, previous) {
        final controller = previous ?? ProfilePreferencesController(
          getPreferencesUseCase: getPreferencesUseCase,
          updatePreferencesUseCase: updatePreferencesUseCase,
        );
        controller.updateDependencies(authController: authCtrl);
        return controller;
      },
    ),

    ChangeNotifierProxyProvider<ProfilePreferencesController, ThemeController>(
      create: (_) => ThemeController(),
      update: (_, prefsCtrl, previous) {
        final controller = previous ?? ThemeController();
        controller.updateFromPreferences(prefsCtrl);
        return controller;
      },
    ),

    ChangeNotifierProvider(create: (_) => NotificationController()),

    ChangeNotifierProvider(
      create: (_) => TaskController(
        loadTasksUseCase: loadTasksUseCase,
        addTaskUseCase: addTaskUseCase,
        updateTaskUseCase: updateTaskUseCase,
        deleteTaskUseCase: deleteTaskUseCase,
      ),
    ),
    ChangeNotifierProvider(create: (_) => DashboardController()),

    ChangeNotifierProvider(create: (_) => FocusModeController()),
    ChangeNotifierProxyProvider3<NotificationController, ProfilePreferencesController, TaskController, PomodoroController>(
      create: (_) => PomodoroController(),
      update: (_, notifCtrl, prefsCtrl, taskCtrl, previous) {
        previous?.updateDependencies(
          notificationController: notifCtrl,
          preferencesController: prefsCtrl,
          taskController: taskCtrl,
        );
        return previous ??
            PomodoroController(
              notificationController: notifCtrl,
              preferencesController: prefsCtrl,
              taskController: taskCtrl,
            );
      },
    ),
  ];
}
