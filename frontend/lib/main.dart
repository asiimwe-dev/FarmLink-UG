import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:farmcom/core/infrastructure/storage/isar_provider.dart';  // Disabled for AGP 8.x compatibility
import 'package:farmcom/core/routing/router_provider.dart';
import 'package:farmcom/core/theme/app_theme.dart';
import 'package:farmcom/core/theme/theme_provider.dart';
import 'package:farmcom/core/constants/app_strings.dart';
import 'package:farmcom/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar (Stubbed)
  // await initializeIsar();
  
  Logger.i('🚀 Starting FarmCom Mobile...');
  
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
    );
  }
}
