part of '../pages/dashboard_page.dart';

class NicheCommunitiesList extends ConsumerWidget {
  const NicheCommunitiesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communities = [
      {'name': 'Coffee', 'posts': 5, 'color': const Color(0xFF6D4C41), 'icon': Icons.coffee_rounded},
      {'name': 'Maize', 'posts': 0, 'color': const Color(0xFFFBC02D), 'icon': Icons.agriculture_rounded},
      {'name': 'Poultry', 'posts': 12, 'color': const Color(0xFFFB8C00), 'icon': Icons.egg_rounded},
      {'name': 'Cocoa', 'posts': 3, 'color': const Color(0xFF3E2723), 'icon': Icons.bakery_dining_rounded},
      {'name': 'Vanilla', 'posts': 8, 'color': const Color(0xFF8D6E63), 'icon': Icons.vaping_rooms_rounded},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return _CommunityCard(
          name: community['name'] as String,
          newPosts: community['posts'] as int,
          color: community['color'] as Color,
          icon: community['icon'] as IconData,
        );
      },
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final String name;
  final int newPosts;
  final Color color;
  final IconData icon;

  const _CommunityCard({
    required this.name,
    required this.newPosts,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 140, // Increased for better text breathing room
      margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
      child: FarmComCard(
        padding: EdgeInsets.zero,
        color: isDark ? AppColors.darkSurfaceBright : Colors.white,
        border: !isDark
            ? Border(top: BorderSide(color: color, width: 3))
            : null,
        onTap: () {
          context.push(
            AppRoutes.communityDetail.replaceAll(':id', name.toLowerCase()),
            extra: {
              'name': name,
              'members': '1.5k',
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (newPosts > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? AppColors.darkSurfaceBright : Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        newPosts.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                AppTypography.titleSmall,
                color: isDark ? Colors.white : color.withValues(alpha: 0.8),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Active Now',
              style: TextStyle(
                AppTypography.captionSmall,
                color: isDark ? Colors.white38 : AppColors.grey500,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
