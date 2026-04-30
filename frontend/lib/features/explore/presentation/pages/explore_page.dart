import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/routing/app_routes.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';
import 'package:farmcom/core/presentation/widgets/offline_indicator.dart';

class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4, // Crops, Learn, Experts, Favorites
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 1,
                    backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    leading: LayoutBuilder(
                      builder: (context, constraints) {
                        return IconButton(
                          onPressed: () => context.go(AppRoutes.home),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: isDark ? Colors.white : (innerBoxIsScrolled ? AppColors.grey900 : Colors.white),
                          ),
                        );
                      },
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final top = constraints.biggest.height;
                        final isCollapsed = top < (MediaQuery.of(context).padding.top + 70);
                        final contentColor = isDark 
                            ? Colors.white 
                            : (isCollapsed ? AppColors.grey900 : Colors.white);

                        return FlexibleSpaceBar(
                          titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
                          title: Text(
                            'Explore',
                            style: AppTypography.titleMedium.copyWith(
                            color: contentColor,
                            fontWeight: FontWeight.w900,
                            ),
                          ),
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryDark, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _ExploreTabDelegate(
                      isDark: isDark,
                      tabBar: TabBar(
                        isScrollable: true,
                        indicatorColor: AppColors.primary,
                        indicatorWeight: 3,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: isDark ? Colors.white60 : AppColors.grey500,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w800, AppTypography.titleSmall),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, AppTypography.titleSmall),
                        tabs: const [
                          Tab(text: 'Crops'),
                          Tab(text: 'Learning'),
                          Tab(text: 'Experts'),
                          Tab(text: 'Favorites'),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    _CropsListView(isDark: isDark),
                    _LearningListView(isDark: isDark),
                    _ExpertsListView(isDark: isDark),
                    const _FavoritesView(),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: OfflineIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _ExploreTabDelegate({required this.tabBar, required this.isDark});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.darkSurface : Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_ExploreTabDelegate oldDelegate) {
    return false;
  }
}

class _CropsListView extends StatelessWidget {
  final bool isDark;
  const _CropsListView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final crops = [
      ('Coffee', 'Coffea arabica', 'Most exported cash crop in Uganda.', const Color(0xFF6D4C41)),
      ('Maize', 'Zea mays', 'Primary food security crop.', const Color(0xFFFBC02D)),
      ('Beans', 'Phaseolus vulgaris', 'Main source of protein for rural areas.', const Color(0xFFE53935)),
      ('Cassava', 'Manihot esculenta', 'Drought-resistant root crop.', const Color(0xFF81C784)),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: crops.length,
      itemBuilder: (context, index) {
        final crop = crops[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FarmComCard(
            onTap: () {},
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: crop.$4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(Icons.eco_rounded, color: crop.$4, size: 28)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(crop.$1, style: const AppTypography.titleMedium.copyWith( fontWeight: FontWeight.w800)),
                      Text(crop.$2, style: AppTypography.labelMedium.copyWith(fontStyle: FontStyle.italic, color: isDark ? Colors.white60 : AppColors.grey500)),
                      const SizedBox(height: 4),
                      Text(crop.$3, style: AppTypography.bodySmall.copyWith( color: isDark ? Colors.white70 : AppColors.grey700), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LearningListView extends StatelessWidget {
  final bool isDark;
  const _LearningListView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final guides = [
      ('Sustainable Irrigation', 'Learn how to manage water resources efficiently.', Icons.water_drop_rounded, AppColors.tertiary),
      ('Organic Fertilizers', 'Make your own compost and boost soil health.', Icons.science_rounded, AppColors.primary),
      ('Post-Harvest Handling', 'Reduce losses after harvest with these tips.', Icons.inventory_2_rounded, AppColors.secondary),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FarmComCard(
            onTap: () {},
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: guide.$4.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(guide.$3, color: guide.$4, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guide.$1, style: const AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(guide.$2, style: AppTypography.bodySmall.copyWith( color: isDark ? Colors.white70 : AppColors.grey600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpertsListView extends StatelessWidget {
  final bool isDark;
  const _ExpertsListView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final experts = [
      ('Dr. Samuel Okello', 'Agronomist • 12yrs Exp', 'Specializes in soil health and coffee.'),
      ('Eng. Prossy Namukasa', 'Irrigation Specialist', 'Expert in low-cost solar pump systems.'),
      ('Moses Batte', 'Poultry Consultant', 'Focuses on sustainable layer management.'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: experts.length,
      itemBuilder: (context, index) {
        final expert = experts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FarmComCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primarySoft,
                      child: const Icon(Icons.person_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(expert.$1, style: const AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w800)),
                          Text(expert.$2, style: AppTypography.labelMedium.copyWith( color: AppColors.primary, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(expert.$3, style: AppTypography.bodySmall.copyWith( color: isDark ? Colors.white70 : AppColors.grey700)),
                const SizedBox(height: 16),
                FarmComButton(
                  label: 'Book Consultation',
                  onPressed: () {},
                  size: FarmComButtonSize.small,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 48, color: AppColors.grey300),
          const SizedBox(height: 16),
          const Text('No favorites yet', style: AppTypography.titleMedium.copyWith( fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Saved content will appear here', style: TextStyle(color: AppColors.grey500, AppTypography.bodySmall)),
        ],
      ),
    );
  }
}
