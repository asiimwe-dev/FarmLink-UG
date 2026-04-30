import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmcom/core/infrastructure/connectivity/connectivity_provider.dart';
import 'package:farmcom/features/auth/presentation/providers/auth_provider.dart';
import 'package:farmcom/core/routing/app_routes.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';
import 'package:farmcom/core/presentation/widgets/offline_indicator.dart';

part '../widgets/niche_communities_list.dart';
part '../widgets/ai_quick_scan_button.dart';
part '../widgets/market_pulse_list.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late ScrollController _scrollController;
  double _scrollOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final newOpacity = (_scrollController.offset / (200 - kToolbarHeight)).clamp(0.0, 1.0);
    if (newOpacity != _scrollOpacity) {
      setState(() {
        _scrollOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final userName = user?.name ?? 'Farmer';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pixel-perfect alignment colors
    final collapsedTextColor = isDark ? Colors.white : AppColors.grey900;
    final expandedTextColor = Colors.white;
    final contentColor = Color.lerp(expandedTextColor, collapsedTextColor, _scrollOpacity)!;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.primary,
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // ============ Branded Header ============
                SliverAppBar(
                  expandedHeight: 220,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  stretch: true,
                  scrolledUnderElevation: 1,
                  backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  // Fixed AppBar Content
                  title: Padding(
                    padding: const EdgeInsets.only(top: 4), // Fine-tuned vertical alignment
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLogo(contentColor),
                        Row(
                          children: [
                            _buildNotificationButton(context, contentColor),
                            _buildConnectivityStatus(ref, contentColor),
                          ],
                        ),
                      ],
                    ),
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
                            top: -20,
                            right: -20,
                            child: Icon(
                              Icons.agriculture_rounded,
                              size: 200,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 70, 24, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Opacity(
                                    opacity: (1.0 - _scrollOpacity).clamp(0.0, 1.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello, $userName!',
                                          style: AppTypography.headlineMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Your farm is doing great today',
                                          style: AppTypography.bodyLarge.copyWith(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Communities',
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : AppColors.grey900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildTag('3 Active', AppColors.secondary),
                          ],
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.community),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Row(
                            children: [
                              Text('View All'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 180, // Optimized height
                    child: NicheCommunitiesList(),
                  ),
                ),

                // ============ Quick Scan CTA ============
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: AIQuickScanButton(),
                  ),
                ),

                // ============ Market Pulse Section ============
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Market Pulse',
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildTag('Live Updates', AppColors.primary),
                      ],
                    ),
                  ),
                ),

                const MarketPulseList(),

                // ============ Professional Help Section ============
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      'Professional Help',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: _ExpertAccessCard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            // Floating Status Indicator (Optional, but useful for offline)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: OfflineIndicator(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.aiChat),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.forum_rounded),
        label: const Text(
          'AI Assistant',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLogo(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.eco_rounded, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          'FarmCom',
          style: TextStyle(
            AppTypography.titleMedium,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context, Color color) {
    return IconButton(
      onPressed: () => context.push(AppRoutes.notifications),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
      icon: Stack(
        children: [
          Icon(Icons.notifications_none_rounded, size: 22, color: color),
          Positioned(
            right: 1,
            top: 1,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectivityStatus(WidgetRef ref, Color color) {
    final isOnline = ref.watch(isOnlineProvider);

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (isOnline ? AppColors.success : AppColors.error).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isOnline ? AppColors.success : AppColors.error).withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: color,
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

    return FarmComCard(
      variant: CardVariant.elevated,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.support_agent_rounded, color: AppColors.tertiary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Expert Access',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Connect with verified agricultural experts for personalized advice and crop management tips.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : AppColors.grey700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          FarmComButton(
            label: 'Find an Expert',
            onPressed: () {},
            variant: FarmComButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
