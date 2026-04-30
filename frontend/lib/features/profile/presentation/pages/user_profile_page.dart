import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/features/auth/presentation/providers/auth_provider.dart';
import 'package:farmcom/features/settings/presentation/pages/settings_page.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'edit_profile_page.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            scrolledUnderElevation: 1,
            backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
            centerTitle: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final isCollapsed = top < (MediaQuery.of(context).padding.top + 70);
                final contentColor = isDark 
                    ? Colors.white 
                    : (isCollapsed ? AppColors.grey900 : Colors.white);

                return FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  titlePadding: const EdgeInsets.only(bottom: 14),
                  title: Text(
                    user?.name ?? 'Test Farmer',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: contentColor,
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 60,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? AppColors.darkSurfaceBright : Colors.white,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.3), 
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_rounded, 
                              size: 40, 
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
                icon: Icon(
                  Icons.edit_note_rounded, 
                  size: 28, 
                  color: isDark ? Colors.white : null, // Uses theme color in light
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============ Profile Details ============
                  const _ProfileSectionTitle(title: 'Farm Information'),
                  const SizedBox(height: 16),
                  _buildInfoTile(context, Icons.location_on_rounded, 'Region', user?.region ?? 'Central Uganda'),
                  _buildInfoTile(context, Icons.agriculture_rounded, 'Farm Size', '2.5 Acres'),
                  _buildInfoTile(context, Icons.grass_rounded, 'Primary Crop', 'Robusta Coffee'),
                  
                  const SizedBox(height: 32),
                  const _ProfileSectionTitle(title: 'Account Settings'),
                  const SizedBox(height: 16),
                  FarmComCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildMenuAction(
                          context, 
                          Icons.settings_rounded, 
                          'App Settings', 
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                        ),
                        Divider(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : null),
                        _buildMenuAction(context, Icons.help_outline_rounded, 'Support & FAQ', () {}),
                        Divider(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : null),
                        _buildMenuAction(
                          context, 
                          Icons.logout_rounded, 
                          'Log Out', 
                          () {
                            ref.read(authProvider.notifier).logout();
                          },
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  const _ProfileSectionTitle(title: 'Farm Stats'),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Consultations',
                          value: '12',
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          label: 'Forum Posts',
                          value: '48',
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isDark ? AppColors.primaryLight : AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label, 
                style: AppTypography.labelMedium.copyWith(color: isDark ? Colors.white60 : AppColors.grey500, 
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value, 
                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuAction(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon, 
        color: isDestructive 
            ? AppColors.error 
            : (isDark ? Colors.white70 : AppColors.grey700),
      ),
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(
          fontWeight: FontWeight.w700,
          color: isDestructive 
              ? AppColors.error 
              : (isDark ? Colors.white : AppColors.grey900),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  const _ProfileSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: AppTypography.titleLarge.copyWith(
        
        fontWeight: FontWeight.w900,
        letterSpacing: 0.3,
        color: isDark ? Colors.white : AppColors.grey900,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FarmComCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: isDark ? Colors.white60 : AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
