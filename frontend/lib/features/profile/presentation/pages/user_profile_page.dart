import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/features/auth/presentation/providers/auth_provider.dart';
import 'package:farmcom/features/settings/presentation/pages/settings_page.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _regionController;
  late List<String> _interests;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? 'Test Farmer');
    _bioController = TextEditingController(text: user?.bio ?? 'Passionate about sustainable coffee farming.');
    _regionController = TextEditingController(text: user?.region ?? 'Central Uganda');
    _interests = List.from(user?.interests ?? ['Coffee', 'Maize', 'Poultry']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: AppColors.primary,
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
                      bottom: 40,
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _nameController.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user?.phone ?? '+256 701 234 567',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                            ),
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
                onPressed: _isEditing ? _saveProfile : _toggleEditMode,
                icon: Icon(_isEditing ? Icons.check_circle_rounded : Icons.edit_rounded, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('General Information'),
                  const SizedBox(height: 12),
                  FarmComCard(
                    child: Column(
                      children: [
                        _buildProfileItem(Icons.person_outline_rounded, 'Full Name', _nameController, _isEditing),
                        const Divider(height: 24),
                        _buildProfileItem(Icons.info_outline_rounded, 'Bio', _bioController, _isEditing, maxLines: 2),
                        const Divider(height: 24),
                        _buildProfileItem(Icons.location_on_outlined, 'Region', _regionController, _isEditing),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Farming Interests'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests.map((interest) => _buildInterestChip(interest)).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionTitle('Account Settings'),
                  const SizedBox(height: 12),
                  FarmComCard(
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.grey900,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, TextEditingController controller, bool isEditing, {int maxLines = 1}) {
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
              if (isEditing)
                TextField(
                  controller: controller,
                  maxLines: maxLines,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: UnderlineInputBorder(),
                  ),
                )
              else
                Text(
                  controller.text,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.grey900),
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
    final color = isDestructive ? AppColors.error : AppColors.grey900;
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
}
