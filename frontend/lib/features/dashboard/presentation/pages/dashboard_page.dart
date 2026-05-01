import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmlink_ug/core/infrastructure/connectivity/connectivity_provider.dart';
import 'package:farmlink_ug/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:farmlink_ug/features/community/presentation/pages/community_chat_page.dart';
import 'package:farmlink_ug/core/utils/time_greeting_helper.dart';
import 'package:farmlink_ug/features/auth/presentation/providers/auth_provider.dart';
import 'package:farmlink_ug/core/routing/app_routes.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_card.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_button.dart';
import 'package:farmlink_ug/core/presentation/widgets/offline_indicator.dart';
import '../widgets/personalized_greeting_header.dart';

part '../widgets/niche_communities_list.dart';
part '../widgets/ai_quick_scan_button.dart';
part '../widgets/market_pulse_list.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final userName = user?.name ?? 'Farmer';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate data refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.primary,
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
          // ============ Modern Header with Gradient ============
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            scrolledUnderElevation: 2,
            backgroundColor: isDark
                ? AppColors.darkSurfaceBright
                : AppColors.white,
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAppLogoSmall(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go(AppRoutes.notifications),
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications_none_rounded, size: 24),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '2',
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildConnectivityStatus(ref),
                  ],
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Icon(
                        Icons.agriculture_rounded,
                        size: 240,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 20),
                        child: Text(
                          'Welcome back,\nlet\'s grow together',
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ============ Communities Section ============
          SliverToBoxAdapter(
            child: UIRefinementKit.buildSectionHeader(
              context: context,
              title: 'My Communities',
              subtitle: '3 Active',
              onViewAll: () => context.go(AppRoutes.community),
              viewAllLabel: 'View All',
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SpacingConstants.paddingLG),
                child: NicheCommunitiesList(),
              ),
            ),
          ),

          // ============ Quick Scan CTA ============
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SpacingConstants.paddingLG,
                vertical: SpacingConstants.paddingXL,
              ),
              child: AIQuickScanButton(),
            ),
          ),

          // ============ Market Pulse Section ============
          SliverToBoxAdapter(
            child: UIRefinementKit.buildSectionHeader(
              context: context,
              title: 'Market Pulse',
              subtitle: 'Live Updates',
            ),
          ),

          const MarketPulseList(),

          // ============ Professional Help Section ============
          SliverToBoxAdapter(
            child: UIRefinementKit.buildSectionHeader(
              context: context,
              title: 'Professional Help',
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(SpacingConstants.paddingLG),
              child: _ExpertAccessCard(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: SpacingConstants.xxxxl)),
            ],
            ),
            // Offline indicator
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: OfflineIndicator(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AIChatPage(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.forum_rounded),
        label: const Text(
          'AI Assistant',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildAppLogoSmall() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.eco_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'FarmLink UG',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectivityStatus(WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOnline
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? AppColors.success : AppColors.error,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertAccessCard extends StatelessWidget {
  const _ExpertAccessCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FarmLinkCard(
      variant: CardVariant.elevated,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_add_rounded,
              color: AppColors.tertiary,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Get Expert Help',
            style: AppTypography.titleMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect with agricultural experts for personalized guidance on your crops and farming practices.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          FarmLinkButton(
            label: 'Browse Experts',
            onPressed: () {},
            variant: FarmLinkButtonVariant.primary,
            size: FarmLinkButtonSize.medium,
          ),
        ],
      ),
    );
  }
}
