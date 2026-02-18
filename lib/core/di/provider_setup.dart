import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controllers
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';

// Repositories & DataSources
import 'package:mindease_focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (_) => ThemeController()),
    
    // Auth & Profile
    ChangeNotifierProvider(create: (_) => AuthController()),
    
    ChangeNotifierProvider(create: (_) {
      final supabase = Supabase.instance.client;
      final remoteDataSource = ProfileRemoteDataSourceImpl(supabase);
      final repository = ProfileRepository(remoteDataSource);
      
      return ProfilePreferencesController(
        repository: repository,
      );
    }),

    // Tasks & Focus
    ChangeNotifierProvider(create: (_) => FocusModeController()),
    ChangeNotifierProvider(create: (_) => PomodoroController()),
    
    ChangeNotifierProvider(
      create: (_) {
        final supabase = Supabase.instance.client;
        final dataSource = TaskRemoteDataSourceImpl(supabase);
        final repository = TaskRepository(dataSource);
        return TaskController(repository: repository);
      },
    ),
  ];
}
