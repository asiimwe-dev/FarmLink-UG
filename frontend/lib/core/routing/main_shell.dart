import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/theme/app_typography.dart';

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit FarmCom',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text('Are you sure you want to exit the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.grey500,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Exit',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        // If not on home tab (index 0), go back to home instead of exiting
        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(
            0,
            initialLocation: true,
          );
          return;
        }
        
        // If on home tab, show exit confirmation
        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: _buildBottomNav(context, isDark),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceBright.withValues(alpha: 0.95)
                : Colors.white.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.2 : 0.08,
                ),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _NavItem(
                    icon: _getIcon(index, false),
                    selectedIcon: _getIcon(index, true),
                    label: _getLabel(index),
                    isSelected: navigationShell.currentIndex == index,
                    onTap: () {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index, bool selected) {
    final icons = [
      (Icons.home_outlined, Icons.home_rounded),
      (Icons.groups_outlined, Icons.groups_rounded),
      (Icons.menu_book_outlined, Icons.menu_book_rounded),
      (Icons.person_outline_rounded, Icons.person_rounded),
    ];
    return selected ? icons[index].$2 : icons[index].$1;
  }

  String _getLabel(int index) {
    const labels = ['Home', 'Communities', 'Guide', 'Profile'];
    return labels[index];
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated background
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 + (8 * _controller.value),
                    vertical: 10 + (2 * _controller.value),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: 0.12 * _controller.value,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.isSelected ? widget.selectedIcon : widget.icon,
                    size: 24 + (2 * _controller.value),
                    color: Color.lerp(
                      isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                      AppColors.primary,
                      _controller.value,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Label with smooth transition
                ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                  ),
                  child: Text(
                    widget.label,
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Color.lerp(
                        isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary,
                        AppColors.primary,
                        _controller.value,
                      ),
                      fontSize: 10 + (1 * _controller.value),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
