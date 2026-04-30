import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Displays confidence level with visual progress bar and threshold indicator (85%)
class ConfidenceIndicator extends StatelessWidget {
  final double confidence; // 0.0 - 1.0
  final double thresholdPercentage; // Default 85%
  final VoidCallback? onAskExpert;

  const ConfidenceIndicator({
    Key? key,
    required this.confidence,
    this.thresholdPercentage = 0.85,
    this.onAskExpert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (confidence * 100).toInt();
    final isHighConfidence = confidence >= thresholdPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with confidence label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidence Level',
              style: AppTypography.labelLarge.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(isHighConfidence).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$percentage%',
                style: AppTypography.labelMedium.copyWith(
                  color: _getStatusColor(isHighConfidence),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Progress bar with threshold marker
        Stack(
          children: [
            // Background bar
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkGrey300 : AppColors.grey200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Progress fill
            FractionallySizedBox(
              widthFactor: confidence.clamp(0.0, 1.0),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHighConfidence
                        ? [AppColors.success, AppColors.successLight]
                        : [AppColors.warning, AppColors.warningLight],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Threshold marker line (85%)
            Positioned(
              left: '${thresholdPercentage * 100}%'.replaceFirst('%', '').isEmpty
                  ? 0
                  : (thresholdPercentage * 100) / 100 * 1,
              top: 0,
              bottom: 0,
              child: Transform.translate(
                offset: const Offset(-1, 0),
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Status label and explanation
        Row(
          children: [
            if (isHighConfidence) ...[
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'High Confidence - Diagnosis is reliable',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            ] else ...[
              Icon(
                Icons.info,
                color: AppColors.warning,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Low Confidence - Below 85% threshold',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Threshold explanation
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.info.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'The threshold line shows 85% confidence. Diagnoses above this level are considered reliable.',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.info,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Ask expert button (show only if low confidence)
        if (!isHighConfidence && onAskExpert != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAskExpert,
              icon: const Icon(Icons.person),
              label: const Text('Ask a Verified Agronomist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(bool isHighConfidence) {
    return isHighConfidence ? AppColors.success : AppColors.warning;
  }
}

/// Compact confidence badge for history list
class ConfidenceBadge extends StatelessWidget {
  final double confidence;
  final double thresholdPercentage;

  const ConfidenceBadge({
    Key? key,
    required this.confidence,
    this.thresholdPercentage = 0.85,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (confidence * 100).toInt();
    final isHighConfidence = confidence >= thresholdPercentage;
    final color =
        isHighConfidence ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHighConfidence ? Icons.check_circle : Icons.warning,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Threshold visualization for comparing multiple diagnoses
class ConfidenceComparison extends StatelessWidget {
  final List<(String label, double confidence)> items;
  final double thresholdPercentage;

  const ConfidenceComparison({
    Key? key,
    required this.items,
    this.thresholdPercentage = 0.85,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: items
          .map((item) {
            final label = item.$1;
            final confidence = item.$2;
            final percentage = (confidence * 100).toInt();
            final isAboveThreshold = confidence >= thresholdPercentage;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: AppTypography.labelMedium,
                      ),
                      Text(
                        '$percentage%',
                        style: AppTypography.labelSmall.copyWith(
                          color: isAboveThreshold
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          color: isDark
                              ? AppColors.darkGrey300
                              : AppColors.grey200,
                        ),
                        FractionallySizedBox(
                          widthFactor: confidence.clamp(0.0, 1.0),
                          child: Container(
                            height: 8,
                            color: isAboveThreshold
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(),
    );
  }
}
