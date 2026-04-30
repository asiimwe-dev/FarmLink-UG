import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/domain/entities/user.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Verification badge widget for displaying user verification status
class VerificationBadge extends StatelessWidget {
  final VerificationStatus status;
  final double size;
  final bool showLabel;

  const VerificationBadge({
    Key? key,
    required this.status,
    this.size = 20,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == VerificationStatus.unverified) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBadgeIcon(isDark),
        if (showLabel) ...[
          const SizedBox(width: 4),
          _buildLabel(isDark),
        ],
      ],
    );
  }

  Widget _buildBadgeIcon(bool isDark) {
    final (color, icon) = _getStatusConfig();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  Widget _buildLabel(bool isDark) {
    final (color, label) = _getLabelConfig();
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Tooltip(
      message: label,
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Returns (color, icon) for the badge
  (Color, IconData) _getStatusConfig() {
    switch (status) {
      case VerificationStatus.agronomist:
        return (AppColors.success, Icons.verified); // Green checkmark
      case VerificationStatus.verifiedTrader:
        return (AppColors.tertiary, Icons.verified_user); // Blue shield
      case VerificationStatus.unverified:
        return (AppColors.grey400, Icons.help_outline);
    }
  }

  /// Returns (color, label) for the badge text
  (Color, String) _getLabelConfig() {
    switch (status) {
      case VerificationStatus.agronomist:
        return (AppColors.success, 'Agronomist');
      case VerificationStatus.verifiedTrader:
        return (AppColors.tertiary, 'Verified Trader');
      case VerificationStatus.unverified:
        return (AppColors.grey500, 'Unverified');
    }
  }
}

/// Display verification badge inline within post/comment
class InlineVerificationBadge extends StatelessWidget {
  final VerificationStatus status;
  final bool mini;

  const InlineVerificationBadge({
    Key? key,
    required this.status,
    this.mini = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == VerificationStatus.unverified) {
      return const SizedBox.shrink();
    }

    final (color, icon) = _getConfig();

    return Tooltip(
      message: _getLabel(),
      child: Icon(
        icon,
        color: color,
        size: mini ? 12 : 16,
      ),
    );
  }

  (Color, IconData) _getConfig() {
    switch (status) {
      case VerificationStatus.agronomist:
        return (AppColors.success, Icons.verified);
      case VerificationStatus.verifiedTrader:
        return (AppColors.tertiary, Icons.verified_user);
      case VerificationStatus.unverified:
        return (AppColors.grey400, Icons.help_outline);
    }
  }

  String _getLabel() {
    switch (status) {
      case VerificationStatus.agronomist:
        return 'Verified Agronomist';
      case VerificationStatus.verifiedTrader:
        return 'Verified Trader';
      case VerificationStatus.unverified:
        return 'Unverified User';
    }
  }
}
