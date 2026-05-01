import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_card.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_text_field.dart';
import 'community_chat_page.dart';

class AllCommunitiesPage extends StatelessWidget {
  const AllCommunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: UIRefinementKit.buildGradientAppBar(
        context: context,
        title: 'All Communities',
        showLeading: true,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(SpacingConstants.paddingLG),
            child: const FarmLinkTextField(
              hintText: 'Search for a niche (e.g. Pigs, Rice)',
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.paddingLG),
              children: [
                UIRefinementKit.buildSectionHeader(
                  context: context,
                  title: 'Recommended for You',
                ),
                _buildCommunityTile(context, 'Coffee Growers', '1.2k members', Icons.coffee_rounded, const Color(0xFF6D4C41)),
                _buildCommunityTile(context, 'Maize Network', '850 members', Icons.agriculture_rounded, const Color(0xFFFBC02D)),
                _buildCommunityTile(context, 'Poultry Hub', '2.1k members', Icons.egg_rounded, const Color(0xFFFB8C00)),
                const SizedBox(height: SpacingConstants.xxl),
                UIRefinementKit.buildSectionHeader(
                  context: context,
                  title: 'Trending Now',
                ),
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

  Widget _buildCommunityTile(BuildContext context, String name, String members, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingConstants.paddingMD),
      child: FarmLinkCard(
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
              padding: const EdgeInsets.all(SpacingConstants.paddingMD),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: SpacingConstants.paddingLG),
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
