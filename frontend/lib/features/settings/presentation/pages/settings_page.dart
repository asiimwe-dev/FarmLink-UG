import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/theme/theme_provider.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _pushNotifications = true;
  bool _marketAlerts = true;
  bool _communityUpdates = true;
  bool _offlineMode = false;
  String _selectedLanguage = 'English';
  String _selectedUnits = 'Metric';

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Preferences', style: TextStyle(fontWeight: FontWeight.w900)),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Appearance', isDark),
          const SizedBox(height: 12),
          FarmComCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildThemeSelectionTile(themeState.themeMode, themeNotifier),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_size_rounded, size: 20, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text('Font Size', style: TextStyle(fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.grey900)),
                        ],
                      ),
                      Slider(
                        value: themeState.fontSizeMultiplier,
                        min: 0.8,
                        max: 1.4,
                        divisions: 3,
                        activeColor: AppColors.primary,
                        onChanged: (val) => themeNotifier.setFontSize(val),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Small', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                          Text('Large', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Notifications', isDark),
          const SizedBox(height: 12),
          FarmComCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildToggleTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push Notifications',
                  subtitle: 'Daily updates and tips',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                  isDark: isDark,
                ),
                const Divider(height: 1),
                _buildToggleTile(
                  icon: Icons.trending_up_rounded,
                  title: 'Market Alerts',
                  subtitle: 'Instant price changes',
                  value: _marketAlerts,
                  onChanged: (val) => setState(() => _marketAlerts = val),
                  isDark: isDark,
                ),
                const Divider(height: 1),
                _buildToggleTile(
                  icon: Icons.groups_rounded,
                  title: 'Community Updates',
                  subtitle: 'Messages from communities',
                  value: _communityUpdates,
                  onChanged: (val) => setState(() => _communityUpdates = val),
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('App Settings', isDark),
          const SizedBox(height: 12),
          FarmComCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildToggleTile(
                  icon: Icons.cloud_off_rounded,
                  title: 'Offline Mode',
                  subtitle: 'Use app without internet',
                  value: _offlineMode,
                  onChanged: (val) => setState(() => _offlineMode = val),
                  isDark: isDark,
                ),
                const Divider(height: 1),
                _buildDropdownTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  value: _selectedLanguage,
                  options: ['English', 'Swahili', 'French', 'Spanish'],
                  onChanged: (val) => setState(() => _selectedLanguage = val ?? 'English'),
                  isDark: isDark,
                ),
                const Divider(height: 1),
                _buildDropdownTile(
                  icon: Icons.straighten_rounded,
                  title: 'Measurement Units',
                  value: _selectedUnits,
                  options: ['Metric', 'Imperial'],
                  onChanged: (val) => setState(() => _selectedUnits = val ?? 'Metric'),
                  isDark: isDark,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('More', isDark),
          const SizedBox(height: 12),
          FarmComCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildActionTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About FarmCom',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
                  isDark: isDark,
                ),
                const Divider(height: 1),
                _buildActionTile(
                  icon: Icons.security_rounded,
                  title: 'Privacy Policy',
                  onTap: () {},
                  isDark: isDark,
                ),
                const Divider(height: 1),
                _buildActionTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'FarmCom v1.0.0',
              style: TextStyle(color: AppColors.grey500, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? Colors.white70 : AppColors.grey700, letterSpacing: 0.5),
    );
  }

  Widget _buildThemeSelectionTile(ThemeMode currentMode, ThemeNotifier notifier) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('System Default', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          value: ThemeMode.system,
          groupValue: currentMode,
          activeColor: AppColors.primary,
          onChanged: (val) => notifier.setThemeMode(val!),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          value: ThemeMode.light,
          groupValue: currentMode,
          activeColor: AppColors.primary,
          onChanged: (val) => notifier.setThemeMode(val!),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          value: ThemeMode.dark,
          groupValue: currentMode,
          activeColor: AppColors.primary,
          onChanged: (val) => notifier.setThemeMode(val!),
        ),
      ],
    );
  }

  Widget _buildToggleTile({required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged, required bool isDark}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : AppColors.grey900)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : AppColors.grey500)),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : AppColors.grey900)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, style: TextStyle(color: isDark ? Colors.white : AppColors.grey900)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, required VoidCallback onTap, required bool isDark}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDark ? Colors.white10 : AppColors.grey100, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isDark ? Colors.white70 : AppColors.grey700, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: isDark ? Colors.white : AppColors.grey900)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text('About FarmCom', style: TextStyle(fontWeight: FontWeight.w900)),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.eco_rounded, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'FarmCom',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary),
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white60 : AppColors.grey500),
            ),
            const SizedBox(height: 40),
            Text(
              'FarmCom is a production-grade AgTech platform designed to bridge the rural agriculture extension gap in East Africa. Our mission is to empower smallholder farmers with AI-driven diagnostics, community-based knowledge sharing, and real-time market insights.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : AppColors.grey800),
            ),
            const SizedBox(height: 48),
            _buildFeatureInfo(Icons.auto_awesome_rounded, 'AI Diagnostics', 'Identify crop and animal diseases instantly using your camera.'),
            const SizedBox(height: 24),
            _buildFeatureInfo(Icons.groups_rounded, 'Community Knowledge', 'Connect with niche farming communities and verified experts.'),
            const SizedBox(height: 24),
            _buildFeatureInfo(Icons.bar_chart_rounded, 'Market Pulse', 'Access real-time price trends for local agricultural products.'),
            const SizedBox(height: 60),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              '© 2026 FarmCom Technologies',
              style: TextStyle(fontSize: 12, color: AppColors.grey400, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureInfo(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
