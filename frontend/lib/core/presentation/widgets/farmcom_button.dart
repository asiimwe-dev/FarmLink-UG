import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/theme/app_typography.dart';

enum FarmComButtonVariant { primary, secondary, tertiary, outline, ghost }

enum FarmComButtonSize { small, medium, large }

/// Professional FarmComButton with comprehensive state management
/// Supports multiple variants, sizes, and accessibility features
class FarmComButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final FarmComButtonVariant variant;
  final FarmComButtonSize size;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final IconData? suffixIcon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const FarmComButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FarmComButtonVariant.primary,
    this.size = FarmComButtonSize.medium,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.suffixIcon,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<FarmComButton> createState() => _FarmComButtonState();
}

class _FarmComButtonState extends State<FarmComButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  (double, double) _getSizeParameters() {
    switch (widget.size) {
      case FarmComButtonSize.small:
        return (44, 12);
      case FarmComButtonSize.medium:
        return (56, 16);
      case FarmComButtonSize.large:
        return (64, 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (height, horizontalPadding) = _getSizeParameters();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? height,
      child: _buildButtonByVariant(context, isDark, horizontalPadding),
    );
  }

  Widget _buildButtonByVariant(
    BuildContext context,
    bool isDark,
    double horizontalPadding,
  ) {
    switch (widget.variant) {
      case FarmComButtonVariant.primary:
        return _buildPrimaryButton(horizontalPadding);

      case FarmComButtonVariant.secondary:
        return _buildSecondaryButton(horizontalPadding);

      case FarmComButtonVariant.tertiary:
        return _buildTertiaryButton(horizontalPadding);

      case FarmComButtonVariant.outline:
        return _buildOutlineButton(horizontalPadding);

      case FarmComButtonVariant.ghost:
        return _buildGhostButton(context, isDark, horizontalPadding);
    }
  }

  Widget _buildPrimaryButton(double horizontalPadding) {
    return ElevatedButton(
      onPressed: widget.isLoading || !widget.enabled ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.enabled
            ? AppColors.primary
            : AppColors.grey400,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        elevation: 3,
        shadowColor: AppColors.primaryShadow,
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildSecondaryButton(double horizontalPadding) {
    return ElevatedButton(
      onPressed: widget.isLoading || !widget.enabled ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.enabled
            ? AppColors.secondary
            : AppColors.grey400,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        elevation: 2,
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildTertiaryButton(double horizontalPadding) {
    return ElevatedButton(
      onPressed: widget.isLoading || !widget.enabled ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.enabled
            ? AppColors.primarySoft
            : AppColors.grey100,
        foregroundColor: widget.enabled ? AppColors.primary : AppColors.grey500,
        disabledBackgroundColor: AppColors.grey100,
        disabledForegroundColor: AppColors.grey400,
        elevation: 0,
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildOutlineButton(double horizontalPadding) {
    return OutlinedButton(
      onPressed: widget.isLoading || !widget.enabled ? null : widget.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: widget.enabled ? AppColors.primary : AppColors.grey500,
        disabledForegroundColor: AppColors.grey400,
        side: BorderSide(
          color: widget.enabled ? AppColors.primary : AppColors.grey300,
          width: 1.5,
        ),
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildGhostButton(
    BuildContext context,
    bool isDark,
    double horizontalPadding,
  ) {
    return TextButton(
      onPressed: widget.isLoading || !widget.enabled ? null : widget.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: widget.enabled
            ? AppColors.primary
            : AppColors.grey500,
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(
            widget.variant == FarmComButtonVariant.outline ||
                    widget.variant == FarmComButtonVariant.ghost
                ? AppColors.primary
                : Colors.white,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: _getTextStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.suffixIcon, size: _getIconSize()),
        ],
      ],
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case FarmComButtonSize.small:
        return 16;
      case FarmComButtonSize.medium:
        return 18;
      case FarmComButtonSize.large:
        return 20;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case FarmComButtonSize.small:
        return AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: _getTextColor(),
        );
      case FarmComButtonSize.medium:
        return AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w700,
          color: _getTextColor(),
        );
      case FarmComButtonSize.large:
        return AppTypography.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: _getTextColor(),
        );
    }
  }

  Color _getTextColor() {
    if (widget.variant == FarmComButtonVariant.primary ||
        widget.variant == FarmComButtonVariant.secondary) {
      return Colors.white;
    } else if (widget.variant == FarmComButtonVariant.tertiary) {
      return AppColors.primary;
    } else if (widget.variant == FarmComButtonVariant.outline) {
      return AppColors.primary;
    } else {
      return AppColors.primary;
    }
  }
}
