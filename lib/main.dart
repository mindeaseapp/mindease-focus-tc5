import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Rotas e Temas
import 'package:mindease_focus/features/routes.dart';
import 'package:mindease_focus/shared/tokens/app_theme.dart';

// Controllers Globais
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
// ✅ Profile Integration (Refatorado)
import 'package:mindease_focus/features/auth/data/datasources/profile_remote_datasource.dart';
import 'package:mindease_focus/features/auth/data/repositories/profile_repository.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart'; // Keep this import for the controller itself
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/data/datasources/task_remote_datasource.dart';
import 'package:mindease_focus/features/auth/data/repositories/task_repository.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/task_controller.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize( 
      url: 'https://pbdhxxixktekjzgfucwm.supabase.co', 
      anonKey: 'sb_publishable_mHOOBibYEftti209CvA_dg_4NG4atPg', 
    );

runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        
        // ✅ INJEÇÃO DO PROFILE PREFERENCES CONTROLLER (REFATORADO)
        ChangeNotifierProvider(create: (_) {
          final supabase = Supabase.instance.client;
          final remoteDataSource = ProfileRemoteDataSourceImpl(supabase);
          final repository = ProfileRepository(remoteDataSource);
          
          return ProfilePreferencesController(
            repository: repository,
          );
        }),

        ChangeNotifierProvider(create: (_) => AuthController()),
        
        // ✅ INJEÇÃO DO TASK CONTROLLER
        ChangeNotifierProvider(
          create: (_) {
            // 1. Pega o cliente do Supabase
            final supabase = Supabase.instance.client;
            // 2. Cria o DataSource
            final dataSource = TaskRemoteDataSourceImpl(supabase);
            // 3. Cria o Repositório (na pasta Data)
            final repository = TaskRepository(dataSource);
            // 4. Cria o Controller
            return TaskController(repository: repository);
          },
        ),
      ],
      child: const MindEaseApp(),
    ),
  );
}

class MindEaseApp extends StatefulWidget {
  const MindEaseApp({super.key});

  @override
  State<MindEaseApp> createState() => _MindEaseAppState();
}

class _MindEaseAppState extends State<MindEaseApp> {
  // Chave global para navegação
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        // Usa microtask para garantir que o Navigator já está pronto
        Future.microtask(() {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/update-password', 
            (route) => false // Limpa a pilha para o usuário não voltar
          );
        });
      } 
      // Opcional: Se o usuário já estiver logado (session != null) e não for recovery,
      // o AuthController e o initialRoute já cuidam disso.
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final prefs = context.watch<ProfilePreferencesController>();
    final authController = context.watch<AuthController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',
      
      // Conecta a chave de navegação
      navigatorKey: _navigatorKey,

      theme: themeController.highContrast ? AppTheme.lightHighContrast : AppTheme.light,
      darkTheme: themeController.highContrast ? AppTheme.darkHighContrast : AppTheme.dark,
      themeMode: themeController.mode,

      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(disableAnimations: prefs.hideDistractions),
          child: child ?? const SizedBox.shrink(),
        );
      },

      // Lógica de Rota Inicial
      // O listener acima (passwordRecovery) tem prioridade sobre isso aqui.
      initialRoute: authController.isAuthenticated 
          ? AppRoutes.dashboard 
          : AppRoutes.login,
      
      routes: AppRoutes.routes,

      // ✅ NOVO: fallback quando a rota não existir + regras logado/deslogado
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}