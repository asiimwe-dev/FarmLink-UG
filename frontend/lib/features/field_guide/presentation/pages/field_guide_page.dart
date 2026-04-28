import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';

class FieldGuidePage extends ConsumerWidget {
  const FieldGuidePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Field Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                Container(
                  color: Colors.white,
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Learning Center'),
                      Tab(text: 'Expert Access'),
                    ],
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.grey500,
                    labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _LearningCenter(),
              _ExpertAccess(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _LearningCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final guides = [
      {
        'title': 'Coffee Growing Guide',
        'subtitle': 'Best practices for coffee production',
        'icon': Icons.spa_rounded,
        'color': Colors.brown,
      },
      {
        'title': 'Maize Cultivation',
        'subtitle': 'Seed selection to harvest',
        'icon': Icons.grass_rounded,
        'color': Colors.amber,
      },
      {
        'title': 'Soil Management',
        'subtitle': 'Soil health and fertility',
        'icon': Icons.landscape_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Pest Control',
        'subtitle': 'Organic and chemical methods',
        'icon': Icons.bug_report_rounded,
        'color': Colors.red,
      },
      {
        'title': 'Irrigation Systems',
        'subtitle': 'Water management techniques',
        'icon': Icons.water_drop_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Crop Rotation',
        'subtitle': 'Sustainable farming practices',
        'icon': Icons.public_rounded,
        'color': Colors.green,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index] as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FarmComCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (guide['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(guide['icon'] as IconData, color: guide['color'] as Color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        guide['subtitle'] as String,
                        style: TextStyle(color: AppColors.grey500, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpertAccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.tertiary, AppColors.tertiaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Direct Expert Access',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect with verified agronomists for professional advice on your farm.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'How it works',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.grey900,
            ),
          ),
          const SizedBox(height: 20),
          _StepItem(
            number: '1',
            title: 'Describe Your Issue',
            description: 'Provide details about your crop or animal health concerns.',
            icon: Icons.edit_note_rounded,
          ),
          const SizedBox(height: 20),
          _StepItem(
            number: '2',
            title: 'Expert Review',
            description: 'A verified agronomist reviews your case and diagnostic photos.',
            icon: Icons.rate_review_rounded,
          ),
          const SizedBox(height: 20),
          _StepItem(
            number: '3',
            title: 'Get Prescription',
            description: 'Receive a detailed treatment plan and recommended inputs.',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 40),
          FarmComButton(
            label: 'Request Expert Access',
            onPressed: () {},
            icon: Icons.support_agent_rounded,
          ),
          const SizedBox(height: 24),
          FarmComCard(
            color: AppColors.tertiarySoft.withValues(alpha: 0.5),
            border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.tertiary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'All experts are certified by the Ministry of Agriculture.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.tertiaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey600,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
