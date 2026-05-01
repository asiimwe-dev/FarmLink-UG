import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/features/auth/presentation/providers/auth_provider.dart';
import 'package:farmlink_ug/features/settings/presentation/pages/settings_page.dart';
import 'package:farmlink_ug/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_card.dart';
import 'package:farmlink_ug/core/presentation/widgets/offline_indicator.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
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
            expandedHeight: 110,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            scrolledUnderElevation: isDark ? 4 : 2,
            backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
            centerTitle: true,
            title: const SizedBox.shrink(), // Empty - profile info is in header
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
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person_rounded, size: 36, color: AppColors.primary),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  user?.name ?? 'Test Farmer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.phone ?? '+256 701 234 567',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(SpacingConstants.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('About Me', isDark),
                  const SizedBox(height: SpacingConstants.paddingMD),
                  FarmLinkCard(
                    child: Column(
                      children: [
                        _buildProfileStaticItem(Icons.info_outline_rounded, 'Bio', user?.bio ?? 'Passionate about sustainable coffee farming.'),
                        const Divider(height: SpacingConstants.xxl),
                        _buildProfileStaticItem(Icons.location_on_outlined, 'Region', user?.region ?? 'Central Uganda'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: SpacingConstants.xxl),
                  _buildExpandableInterests(user?.interests ?? ['Coffee', 'Maize', 'Poultry'], isDark),
                  
                  const SizedBox(height: SpacingConstants.xxxl),
                  _buildSectionTitle('Performance & Engagement', isDark),
                  const SizedBox(height: SpacingConstants.paddingMD),
                  _buildPerformanceMetrics(isDark),
                  
                  const SizedBox(height: SpacingConstants.xxxl),
                  _buildSectionTitle('Account Settings', isDark),
                  const SizedBox(height: SpacingConstants.paddingMD),
                  FarmLinkCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.settings_outlined,
                          title: 'App Preferences',
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage())),
                        ),
                        const Divider(height: 1),
                        _buildActionTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildActionTile(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          isDestructive: true,
                          onTap: _showLogoutDialog,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
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

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: isDark ? Colors.white : AppColors.grey900,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildExpandableInterests(List<String> interests, bool isDark) {
    return FarmLinkCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            'Farming Interests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
          ),
          leading: const Icon(Icons.favorite_outline_rounded, color: AppColors.primary),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) => _buildInterestChip(interest)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStaticItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.grey500, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, required VoidCallback onTap, bool isDestructive = false}) {
    final color = isDestructive ? AppColors.error : (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.grey900);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey500, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(bool isDark) {
    // Mock performance data - will be replaced with real data from backend
    final metrics = [
      {
        'title': 'Total Posts',
        'value': '24',
        'icon': Icons.article_rounded,
        'color': AppColors.primary,
        'subtitle': 'Shared insights'
      },
      {
        'title': 'Engagement Rate',
        'value': '8.5%',
        'icon': Icons.trending_up_rounded,
        'color': AppColors.success,
        'subtitle': 'This week'
      },
      {
        'title': 'Community Score',
        'value': '92',
        'icon': Icons.star_rounded,
        'color': AppColors.warning,
        'subtitle': '/100'
      },
      {
        'title': 'Followers',
        'value': '156',
        'icon': Icons.people_rounded,
        'color': AppColors.tertiary,
        'subtitle': 'Community members'
      },
    ];

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(
            metrics.length,
            (index) {
              final metric = metrics[index];
              return FarmLinkCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (metric['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        metric['icon'] as IconData,
                        color: metric['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      metric['value'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      metric['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      metric['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : AppColors.grey500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        FarmLinkCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Activity Overview',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.grey900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildActivityStat('Posts This Month', '8', '↑ 2 from last month', AppColors.primary, isDark),
              const SizedBox(height: 12),
              _buildActivityStat('Community Interactions', '34', '↑ Active in 5 communities', AppColors.success, isDark),
              const SizedBox(height: 12),
              _buildActivityStat('Diagnostics Used', '3', 'Last used: 2 days ago', AppColors.tertiary, isDark),
              const SizedBox(height: 12),
              _buildActivityStat('Helpful Answers', '12', 'Upvoted by community', AppColors.warning, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityStat(String label, String value, String detail, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
