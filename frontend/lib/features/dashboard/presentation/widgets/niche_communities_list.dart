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
      width: 130,
      margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
      child: FarmComCard(
        padding: EdgeInsets.zero,
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: !isDark
            ? Border(top: BorderSide(color: color, width: 3))
            : null, // Colored top border in light mode
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommunityChatPage(
                communityName: name,
                communityId: name.toLowerCase(),
                members: '1.5k',
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  if (newPosts > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: isDark ? Colors.white : color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Text(
                'Active Now',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white60 : AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
