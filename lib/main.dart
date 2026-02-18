import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/core/navigation/routes.dart';
import 'package:mindease_focus/shared/tokens/app_theme.dart';

import 'package:mindease_focus/core/di/provider_setup.dart';
import 'package:mindease_focus/core/navigation/navigation_service.dart';

import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/profile/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/focus_mode_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ...providers,
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
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final prefs = context.watch<ProfilePreferencesController>();
    final authController = context.watch<AuthController>();
    final navigationService = context.watch<NavigationService>();

    // Redirecionamento de Password Recovery (Clean Arch: Centralizado no Controller)
    if (authController.needsPasswordReset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.updatePassword,
          (route) => false,
        );
        authController.resetPasswordResetFlag();
      });
    }

    final focusMode = context.watch<FocusModeController>().enabled;
    final disableAnimations = prefs.hideDistractions || focusMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',
      navigatorKey: navigationService.navigatorKey,
      theme: themeController.highContrast
          ? AppTheme.lightHighContrast
          : AppTheme.light,
      darkTheme: themeController.highContrast
          ? AppTheme.darkHighContrast
          : AppTheme.dark,
      themeMode: themeController.mode,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(disableAnimations: disableAnimations),
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute:
          authController.isAuthenticated ? AppRoutes.dashboard : AppRoutes.login,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
