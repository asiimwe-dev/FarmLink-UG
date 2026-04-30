import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/domain/repositories/icommunity_repository.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';
import 'package:farmlink_ug/core/constants/app_strings.dart';

/// Badge showing the sync status of a post or comment
class SyncStatusBadge extends StatelessWidget {
  final SyncStatus status;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool inline;

  const SyncStatusBadge({
    Key? key,
    required this.status,
    this.errorMessage,
    this.onRetry,
    this.inline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.synced && inline) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (color, icon, label) = _getConfig();

    if (inline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Tooltip(
        message: _getTooltip(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == SyncStatus.syncing)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 2,
                ),
              )
            else
              Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: color),
            ),
            if (status == SyncStatus.failed && onRetry != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRetry,
                child: Icon(
                  Icons.refresh,
                  color: color,
                  size: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  (Color, IconData, String) _getConfig() {
    switch (status) {
      case SyncStatus.synced:
        return (AppColors.success, Icons.cloud_done, 'Synced');
      case SyncStatus.pending:
        return (AppColors.warning, Icons.cloud_upload_outlined, 'Pending sync');
      case SyncStatus.syncing:
        return (AppColors.info, Icons.cloud_sync, AppStrings.syncing);
      case SyncStatus.failed:
        return (AppColors.error, Icons.cloud_off, AppStrings.syncError);
    }
  }

  String _getTooltip() {
    switch (status) {
      case SyncStatus.synced:
        return 'Successfully synced to cloud';
      case SyncStatus.pending:
        return 'Waiting to sync when online';
      case SyncStatus.syncing:
        return 'Currently syncing...';
      case SyncStatus.failed:
        return errorMessage ?? 'Failed to sync - tap retry';
    }
  }
}

/// Compact indicator for posts list (shows only icon)
class SyncStatusIndicator extends StatelessWidget {
  final SyncStatus status;
  final VoidCallback? onRetry;

  const SyncStatusIndicator({
    Key? key,
    required this.status,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.synced) {
      return const SizedBox.shrink();
    }

    final (color, icon) = _getConfig();
    final tooltip = _getTooltip();

    return GestureDetector(
      onTap: status == SyncStatus.failed ? onRetry : null,
      child: Tooltip(
        message: tooltip,
        child: status == SyncStatus.syncing
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 2,
                ),
              )
            : Icon(
                icon,
                color: color,
                size: 16,
              ),
      ),
    );
  }

  (Color, IconData) _getConfig() {
    switch (status) {
      case SyncStatus.synced:
        return (AppColors.success, Icons.cloud_done);
      case SyncStatus.pending:
        return (AppColors.warning, Icons.cloud_upload_outlined);
      case SyncStatus.syncing:
        return (AppColors.info, Icons.cloud_sync);
      case SyncStatus.failed:
        return (AppColors.error, Icons.cloud_off);
    }
  }

  String _getTooltip() {
    switch (status) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Pending sync';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.failed:
        return 'Sync failed - tap to retry';
    }
  }
}

/// Header showing overall sync status of the entire feed
class SyncStatusHeader extends StatelessWidget {
  final SyncStatus status;
  final int pendingCount;
  final VoidCallback? onSyncAll;

  const SyncStatusHeader({
    Key? key,
    required this.status,
    this.pendingCount = 0,
    this.onSyncAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.synced || pendingCount == 0) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (color, icon) = _getConfig();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(),
                  style: AppTypography.labelLarge.copyWith(color: color),
                ),
                if (pendingCount > 0)
                  Text(
                    'You have $pendingCount pending ${pendingCount == 1 ? 'item' : 'items'}',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (onSyncAll != null && status == SyncStatus.pending)
            GestureDetector(
              onTap: onSyncAll,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  color: color,
                ),
              ),
            ),
        ],
      ),
    );
  }

  (Color, IconData) _getConfig() {
    switch (status) {
      case SyncStatus.synced:
        return (AppColors.success, Icons.cloud_done);
      case SyncStatus.pending:
        return (AppColors.warning, Icons.cloud_upload_outlined);
      case SyncStatus.syncing:
        return (AppColors.info, Icons.cloud_sync);
      case SyncStatus.failed:
        return (AppColors.error, Icons.cloud_off);
    }
  }

  String _getTitle() {
    switch (status) {
      case SyncStatus.synced:
        return 'All synced';
      case SyncStatus.pending:
        return 'Offline mode - changes will sync when online';
      case SyncStatus.syncing:
        return 'Syncing your changes...';
      case SyncStatus.failed:
        return 'Sync failed';
    }
  }
}
