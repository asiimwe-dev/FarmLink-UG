import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_text_field.dart';
import 'community_chat_page.dart';

class AllCommunitiesPage extends StatelessWidget {
  const AllCommunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Communities', style: TextStyle(fontWeight: FontWeight.w900)),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: FarmComTextField(
              hintText: 'Search for a niche (e.g. Pigs, Rice)',
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSectionHeader('Recommended for You', isDark),
                _buildCommunityTile(context, 'Coffee Growers', '1.2k members', Icons.coffee_rounded, const Color(0xFF6D4C41)),
                _buildCommunityTile(context, 'Maize Network', '850 members', Icons.agriculture_rounded, const Color(0xFFFBC02D)),
                _buildCommunityTile(context, 'Poultry Hub', '2.1k members', Icons.egg_rounded, const Color(0xFFFB8C00)),
                const SizedBox(height: 24),
                _buildSectionHeader('Trending Now', isDark),
                _buildCommunityTile(context, 'Pig Farming UG', '500 members', Icons.pets_rounded, Colors.pink.shade300),
                _buildCommunityTile(context, 'Dairy Excellence', '420 members', Icons.water_drop_rounded, Colors.blue.shade400),
                _buildCommunityTile(context, 'Urban Gardening', '1.1k members', Icons.yard_rounded, Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: isDark ? Colors.white70 : AppColors.grey900),
      ),
    );
  }

  Widget _buildCommunityTile(BuildContext context, String name, String members, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FarmComCard(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommunityChatPage(
                communityName: name,
                communityId: name.toLowerCase(),
                members: members.split(' ')[0],
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: isDark ? Colors.white : AppColors.grey900)),
                  Text(members, style: const TextStyle(color: AppColors.grey500, fontSize: 12, fontWeight: FontWeight.w600)),
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
