import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmcom/core/routing/app_routes.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_text_field.dart';
import 'package:farmcom/core/presentation/widgets/offline_indicator.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              // Simulate data refresh
              await Future.delayed(const Duration(seconds: 1));
            },
            color: AppColors.primary,
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 140,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 1,
                  backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
                  centerTitle: false,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final top = constraints.biggest.height;
                      final isCollapsed = top < (MediaQuery.of(context).padding.top + 70);
                      final contentColor = isDark 
                          ? Colors.white 
                          : (isCollapsed ? AppColors.grey900 : Colors.white);

                      return FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
                        title: Text(
                          'Community Network',
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
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FarmComTextField(
                          hintText: 'Search communities (e.g. Coffee, Poultry)',
                          prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(height: 32),
                        
                        // ============ My Communities ============
                        Text(
                          'My Communities',
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ForumTile(
                          title: 'Coffee Farmers Uganda',
                          members: '1.2k',
                          lastPost: 'Best fertilizers for Robusta?',
                          color: const Color(0xFF6D4C41),
                          icon: Icons.coffee_rounded,
                          isDark: isDark,
                          onTap: () {
                            context.push(
                              AppRoutes.communityDetail.replaceAll(':id', 'coffee_ug'),
                              extra: {
                                'name': 'Coffee Farmers Uganda',
                                'members': '1.2k',
                              },
                            );
                          },
                        ),
                        _ForumTile(
                          title: 'Poultry & Layers',
                          members: '2.1k',
                          lastPost: 'Vaccination schedule for new layers',
                          color: const Color(0xFFFB8C00),
                          icon: Icons.egg_rounded,
                          isDark: isDark,
                          onTap: () {
                            context.push(
                              AppRoutes.communityDetail.replaceAll(':id', 'poultry_ug'),
                              extra: {
                                'name': 'Poultry Network',
                                'members': '2.1k',
                              },
                            );
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // ============ Recommended for you ============
                        Text(
                          'Recommended for you',
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ForumTile(
                          title: 'Maize Growers Network',
                          members: '850',
                          lastPost: 'Armyworm outbreak in Gulu district',
                          color: const Color(0xFFFBC02D),
                          icon: Icons.agriculture_rounded,
                          isDark: isDark,
                          onTap: () {
                            context.push(
                              AppRoutes.communityDetail.replaceAll(':id', 'maize_ug'),
                              extra: {
                                'name': 'Maize Growers',
                                'members': '850',
                              },
                            );
                          },
                        ),
                        _ForumTile(
                          title: 'Dairy Excellence',
                          members: '420',
                          lastPost: 'Increasing milk yield in dry season',
                          color: Colors.blue.shade400,
                          icon: Icons.water_drop_rounded,
                          isDark: isDark,
                          onTap: () {},
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // ============ Trending ============
                        Text(
                          'Trending Communities',
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ForumTile(
                          title: 'Fish Farming Collective',
                          members: '680',
                          lastPost: 'Pond preparation for tilapia breeding',
                          color: Colors.cyan.shade400,
                          icon: Icons.water_rounded,
                          isDark: isDark,
                          onTap: () {},
                        ),
                        _ForumTile(
                          title: 'Organic Farming Advocates',
                          members: '1.5k',
                          lastPost: 'Composting techniques & soil health',
                          color: Colors.green.shade400,
                          icon: Icons.eco_rounded,
                          isDark: isDark,
                          onTap: () {},
                        ),
                        _ForumTile(
                          title: 'Bee Keeping Society',
                          members: '390',
                          lastPost: 'Honey harvesting season preparations',
                          color: Colors.amber.shade600,
                          icon: Icons.bug_report_rounded,
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Offline indicator
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: OfflineIndicator(),
          ),
        ],
      ),
    );
  }
}

class _ForumTile extends StatelessWidget {
  final String title;
  final String members;
  final String lastPost;
  final Color color;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _ForumTile({
    required this.title,
    required this.members,
    required this.lastPost,
    required this.color,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FarmComCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$members members • Active now',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.grey500, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lastPost,
                          style: AppTypography.labelMedium.copyWith(fontStyle: FontStyle.italic, color: isDark ? Colors.white70 : AppColors.grey700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
          ],
        ),
      ),
    );
  }
}
