import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:farmlink_ug/core/infrastructure/storage/isar_provider.dart';  // Disabled for AGP 8.x compatibility
import 'package:farmlink_ug/core/routing/router_provider.dart';
import 'package:farmlink_ug/core/theme/app_theme.dart';
import 'package:farmlink_ug/core/theme/theme_provider.dart';
import 'package:farmlink_ug/core/constants/app_strings.dart';
import 'package:farmlink_ug/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar (Stubbed)
  // await initializeIsar();

  Logger.i('🚀 Starting FarmLink UG Mobile...');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeState = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme(themeState.fontSizeMultiplier),
      darkTheme: AppTheme.darkTheme(themeState.fontSizeMultiplier),
      themeMode: themeState.themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // Localization setup
      supportedLocales: const [
        Locale('en', ''),
        Locale('lg', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en', ''),
    );
  }
}
