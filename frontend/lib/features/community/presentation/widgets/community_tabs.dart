import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/domain/repositories/icommunity_repository.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Post category enum for community feed segmentation
enum PostCategory {
  discussion,    // General discussion/questions
  marketPrice,   // Market prices and trading info
  expertTip,     // Tips from verified agronomists
  all,           // All posts
}

extension PostCategoryExtension on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.discussion:
        return 'Discussions';
      case PostCategory.marketPrice:
        return 'Market Prices';
      case PostCategory.expertTip:
        return 'Expert Tips';
      case PostCategory.all:
        return 'All Posts';
    }
  }

  IconData get icon {
    switch (this) {
      case PostCategory.discussion:
        return Icons.forum;
      case PostCategory.marketPrice:
        return Icons.trending_up;
      case PostCategory.expertTip:
        return Icons.lightbulb;
      case PostCategory.all:
        return Icons.dashboard;
    }
  }

  Color get color {
    switch (this) {
      case PostCategory.discussion:
        return AppColors.primary;
      case PostCategory.marketPrice:
        return AppColors.tertiary;
      case PostCategory.expertTip:
        return AppColors.warning;
      case PostCategory.all:
        return AppColors.secondary;
    }
  }
}

/// Tabbed community feed with category segmentation
class CommunityTabView extends StatefulWidget {
  final List<Post> allPosts;
  final ValueChanged<PostCategory> onCategoryChanged;
  final ValueChanged<Post> onPostTap;
  final VoidCallback onNewPost;

  const CommunityTabView({
    Key? key,
    required this.allPosts,
    required this.onCategoryChanged,
    required this.onPostTap,
    required this.onNewPost,
  }) : super(key: key);

  @override
  State<CommunityTabView> createState() => _CommunityTabViewState();
}

class _CommunityTabViewState extends State<CommunityTabView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  PostCategory _selectedCategory = PostCategory.discussion;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: PostCategory.values.length - 1, // Exclude 'all'
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    final categories = [
      PostCategory.discussion,
      PostCategory.marketPrice,
      PostCategory.expertTip,
    ];
    final newCategory = categories[_tabController.index];
    setState(() => _selectedCategory = newCategory);
    widget.onCategoryChanged(newCategory);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Tab bar with indicators
        Container(
          color: isDark ? AppColors.darkSurface : Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
            labelStyle: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTypography.labelMedium,
            tabs: [
              _buildTab(
                PostCategory.discussion,
                _getPostCountForCategory(PostCategory.discussion),
              ),
              _buildTab(
                PostCategory.marketPrice,
                _getPostCountForCategory(PostCategory.marketPrice),
              ),
              _buildTab(
                PostCategory.expertTip,
                _getPostCountForCategory(PostCategory.expertTip),
              ),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryView(PostCategory.discussion),
              _buildCategoryView(PostCategory.marketPrice),
              _buildCategoryView(PostCategory.expertTip),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(PostCategory category, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 16),
          const SizedBox(width: 6),
          Text(category.label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: AppTypography.labelSmall.copyWith(
                  color: category.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryView(PostCategory category) {
    final postsInCategory = _filterPostsByCategory(category);

    if (postsInCategory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 64,
              color: category.color.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${category.label.toLowerCase()} yet',
              style: AppTypography.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share!',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onNewPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: postsInCategory.length,
      itemBuilder: (context, index) {
        final post = postsInCategory[index];
        return GestureDetector(
          onTap: () => widget.onPostTap(post),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: category.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          post.title,
                          style: AppTypography.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    style: AppTypography.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.thumb_up, size: 14, color: AppColors.grey500),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: AppTypography.labelSmall,
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.comment, size: 14, color: AppColors.grey500),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentCount}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Post> _filterPostsByCategory(PostCategory category) {
    return widget.allPosts
        .where((post) => _determinePostCategory(post) == category)
        .toList();
  }

  int _getPostCountForCategory(PostCategory category) {
    return widget.allPosts
        .where((post) => _determinePostCategory(post) == category)
        .length;
  }

  PostCategory _determinePostCategory(Post post) {
    // Logic to determine post category based on content
    // In production, this would use actual post.category field
    final content = post.content.toLowerCase();

    if (content.contains('price') ||
        content.contains('market') ||
        content.contains('sell') ||
        content.contains('buy')) {
      return PostCategory.marketPrice;
    } else if (content.contains('tip') ||
        content.contains('advice') ||
        content.contains('expert') ||
        content.contains('treat')) {
      return PostCategory.expertTip;
    }

    return PostCategory.discussion;
  }
}

/// Simple tab selector without TabController
class CategoryTabBar extends StatelessWidget {
  final PostCategory selectedCategory;
  final ValueChanged<PostCategory> onCategoryChanged;
  final Map<PostCategory, int> postCounts;

  const CategoryTabBar({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.postCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = [
      PostCategory.discussion,
      PostCategory.marketPrice,
      PostCategory.expertTip,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          final count = postCounts[category] ?? 0;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onCategoryChanged(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isSelected ? category.color : Colors.transparent,
                      width: isSelected ? 2 : 0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 16,
                      color: isSelected
                          ? category.color
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.label,
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected
                            ? category.color
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          count.toString(),
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
