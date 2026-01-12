import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mindease_focus/features/routes.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/theme_controller.dart';
import 'package:mindease_focus/features/auth/presentation/controllers/profile_preferences_controller.dart';
import 'package:mindease_focus/shared/tokens/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pbdhxxixktekjzgfucwm.supabase.co',
    anonKey: 'sb_publishable_mHOOBibYEftti209CvA_dg_4NG4atPg',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>(create: (_) => ThemeController()),
        ChangeNotifierProvider<ProfilePreferencesController>(
          create: (_) => ProfilePreferencesController(),
        ),
      ],
      child: const MindEaseApp(),
    ),
  );
}

class MindEaseApp extends StatelessWidget {
  const MindEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final prefs = context.watch<ProfilePreferencesController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',

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
          data: mq.copyWith(disableAnimations: prefs.hideDistractions),
          child: child ?? const SizedBox.shrink(),
        );
      },

      // ✅ Mantém seu fluxo normal
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,

      // ✅ NOVO: fallback quando a rota não existir + regras logado/deslogado
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
