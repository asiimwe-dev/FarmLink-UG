import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Enhanced error states and recovery UI patterns
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final String? retryLabel;
  final String? dismissLabel;

  const ErrorStateWidget({
    Key? key,
    required this.title,
    this.description,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.onDismiss,
    this.retryLabel,
    this.dismissLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            // Error title
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              const SizedBox(height: 12),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onDismiss != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDismiss,
                      child: Text(dismissLabel ?? 'Dismiss'),
                    ),
                  ),
                if (onRetry != null) ...[
                  if (onDismiss != null) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onRetry,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh, size: 16),
                          const SizedBox(width: 6),
                          Text(retryLabel ?? 'Retry'),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Network error state with recovery options
class NetworkErrorState extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;

  const NetworkErrorState({
    Key? key,
    this.onRetry,
    this.onOpenSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Connection Error',
      description:
          'Unable to connect to the network. Check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      retryLabel: 'Try Again',
      onDismiss: onOpenSettings,
      dismissLabel: 'Settings',
    );
  }
}

/// Timeout error state
class TimeoutErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const TimeoutErrorState({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Request Timeout',
      description:
          'The request took too long to complete. Please check your connection and try again.',
      icon: Icons.hourglass_empty,
      onRetry: onRetry,
      retryLabel: 'Retry',
    );
  }
}

/// Server error state (5xx)
class ServerErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorState({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Server Error',
      description:
          'The server is experiencing issues. Our team has been notified. Please try again later.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
      retryLabel: 'Retry',
    );
  }
}

/// Validation error inline widget
class ValidationErrorField extends StatelessWidget {
  final String errorMessage;
  final String? fieldLabel;

  const ValidationErrorField({
    Key? key,
    required this.errorMessage,
    this.fieldLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.error, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (fieldLabel != null)
                  Text(
                    fieldLabel!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Text(
                  errorMessage,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.error,
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

/// Retry toast/snackbar for transient errors
class RetryableErrorSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
    Duration duration = const Duration(seconds: 6),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        action: SnackBarAction(
          label: 'RETRY',
          onPressed: onRetry,
          textColor: Colors.white,
        ),
        duration: duration,
      ),
    );
  }
}

/// Loading state with cancellation option
class CancellableLoadingState extends StatelessWidget {
  final String message;
  final VoidCallback onCancel;
  final double? progress; // 0.0 - 1.0 for progress indication

  const CancellableLoadingState({
    Key? key,
    required this.message,
    required this.onCancel,
    this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (progress != null && progress! > 0)
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            )
          else
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            message,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (progress != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${(progress! * 100).toStringAsFixed(0)}%',
                style: AppTypography.labelSmall,
              ),
            ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Offline data state with update option
class OfflineDataState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onSyncNow;

  const OfflineDataState({
    Key? key,
    required this.title,
    required this.description,
    required this.onSyncNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_off, color: AppColors.info, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSyncNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, size: 16),
                  SizedBox(width: 8),
                  Text('Sync Now'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error boundary wrapper that catches and displays errors
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, FlutterErrorDetails error)?
      errorBuilder;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.errorBuilder,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      setState(() => _error = details);
    };
  }

  @override
  void dispose() {
    FlutterError.onError = FlutterError.presentError;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && widget.errorBuilder != null) {
      return widget.errorBuilder!(context, _error!);
    }

    if (_error != null) {
      return ErrorStateWidget(
        title: 'Something went wrong',
        description: _error!.exceptionAsString(),
        onDismiss: () => setState(() => _error = null),
        dismissLabel: 'Dismiss',
      );
    }

    return widget.child;
  }
}
