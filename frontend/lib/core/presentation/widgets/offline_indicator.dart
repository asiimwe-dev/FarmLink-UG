import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/core/infrastructure/connectivity/connectivity_provider.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';

class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return AnimatedOpacity(
      opacity: isOnline ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isOnline ? 0 : 40,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isOnline ? 0 : 8,
        ),
        decoration: BoxDecoration(
          color: isOnline 
              ? Colors.transparent
              : AppColors.warning.withValues(alpha: 0.15),
          border: Border(
            bottom: BorderSide(
              color: isOnline
                  ? Colors.transparent
                  : AppColors.warning.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
        child: isOnline
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    color: AppColors.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Offline • Using cached data',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
