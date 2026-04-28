import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routing/app_routes.dart';
import '../routing/main_shell.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/profile/presentation/pages/user_profile_page.dart';
import '../../features/field_guide/presentation/pages/field_guide_page.dart';
import '../../features/diagnostics/presentation/pages/camera_diagnostic_page.dart';

// Router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isLoggedIn = authState.user?.isLoggedIn ?? false;

  return GoRouter(
    initialLocation: isLoggedIn ? AppRoutes.home : AppRoutes.login,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const OTPPage(),
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // Community branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.community,
                builder: (context, state) => const CommunityPage(),
              ),
            ],
          ),

          // Field Guide branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.fieldGuide,
                builder: (context, state) => const FieldGuidePage(),
              ),
            ],
          ),

          // Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const UserProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // Diagnostics (camera) route
      GoRoute(
        path: AppRoutes.diagnostics,
        builder: (context, state) => const CameraDiagnosticPage(),
      ),
    ],
  );
});
