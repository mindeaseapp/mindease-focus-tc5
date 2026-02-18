import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controllers
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/login_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/pomodoro_controller.dart';
import 'package:mindease_focus/features/tasks/presentation/controllers/task_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/register_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/update_password_controller.dart';

// UseCases
import 'package:mindease_focus/features/auth/domain/usecases/get_user_usecase.dart';

// Repositories & DataSources
import 'package:mindease_focus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mindease_focus/features/auth/data/repositories/auth_repository.dart';
import 'package:mindease_focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/profile/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/tasks/data/repositories/task_repository.dart';

List<SingleChildWidget> get providers {
  final supabase = Supabase.instance.client;

  // DataSources
  final authDataSource = AuthRemoteDataSource(supabase);
  final profileDataSource = ProfileRemoteDataSourceImpl(supabase);
  final taskDataSource = TaskRemoteDataSourceImpl(supabase);

  // Repositories
  final authRepository = AuthRepository(authDataSource);
  final profileRepository = ProfileRepository(profileDataSource);
  final taskRepository = TaskRepository(taskDataSource);

  // UseCases
  final getUserUseCase = GetUserUseCase(authRepository);

  return [
    ChangeNotifierProvider(create: (_) => ThemeController()),
    
    // Auth & Profile
    ChangeNotifierProvider(
      create: (_) => AuthController(
        getUserUseCase: getUserUseCase,
        authRepository: authRepository,
        supabaseClient: supabase,
      ),
    ),
    
    Provider<AuthRepository>.value(value: authRepository),
    
    ChangeNotifierProvider(
      create: (_) => LoginController(authRepository),
    ),
    ChangeNotifierProvider(
      create: (_) => RegisterController(authRepository),
    ),
    ChangeNotifierProvider(
      create: (_) => ResetPasswordController(authRepository),
    ),
    ChangeNotifierProvider(
      create: (_) => UpdatePasswordController(authRepository),
    ),
    
    ChangeNotifierProvider(
      create: (_) => ProfilePreferencesController(
        repository: profileRepository,
      ),
    ),

    // Tasks & Focus
    ChangeNotifierProvider(create: (_) => FocusModeController()),
    ChangeNotifierProvider(create: (_) => PomodoroController()),
    
    ChangeNotifierProvider(
      create: (_) => TaskController(repository: taskRepository),
    ),
  ];
}
