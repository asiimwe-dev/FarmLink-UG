part of '../pages/dashboard_page.dart';

class NicheCommunitiesList extends ConsumerWidget {
  const NicheCommunitiesList({super.key}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communities = [
      {'name': 'Coffee', 'posts': 5, 'color': Colors.brown.shade400, 'icon': Icons.coffee_rounded},
      {'name': 'Maize', 'posts': 0, 'color': Colors.yellow.shade700, 'icon': Icons.agriculture_rounded},
      {'name': 'Poultry', 'posts': 12, 'color': Colors.orange.shade400, 'icon': Icons.egg_rounded},
      {'name': 'Cocoa', 'posts': 3, 'color': Colors.brown.shade700, 'icon': Icons.bakery_dining_rounded},
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
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
      child: FarmComCard(
        padding: const EdgeInsets.all(16),
        color: AppColors.white,
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
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
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Active Now',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.grey500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
