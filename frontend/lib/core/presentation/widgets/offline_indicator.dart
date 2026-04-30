import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/core/infrastructure/connectivity/connectivity_provider.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';

class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    if (isOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            color: AppColors.warning,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'You are offline',
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '• Using cached data',
            style: TextStyle(
              color: AppColors.warning.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SyncStatusPlaceholder extends ConsumerWidget {
  const SyncStatusPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is a placeholder - in a real app, you'd watch a sync status provider
    return const SizedBox.shrink();
  }
}
