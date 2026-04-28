import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_colors.dart';

/// Card variant styles
enum CardVariant {
  /// Elevated card with shadow
  elevated,

  /// Filled card with solid background
  filled,

  /// Outlined card with border only
  outlined,

  /// Tonal card with subtle background
  tonal,
}

/// Professional FarmComCard component with multiple variants
/// Supports light and dark modes seamlessly
class FarmComCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final CardVariant variant;
  final bool isLoading;
  final bool enabled;

  const FarmComCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 16,
    this.onTap,
    this.boxShadow,
    this.border,
    this.variant = CardVariant.elevated,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  State<FarmComCard> createState() => _FarmComCardState();
}

class _FarmComCardState extends State<FarmComCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onEnter() {
    if (!widget.enabled || widget.onTap == null) return;
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _onExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(widget.borderRadius ?? 16);

    // Determine colors based on variant and brightness
    final (backgroundColor, borderColor, shadowList) = _getVariantColors(
      context: context,
      isDark: isDark,
      variant: widget.variant,
      customColor: widget.color,
    );

    final cardChild = Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: widget.border ??
            (widget.variant == CardVariant.outlined
                ? Border.all(color: borderColor, width: 1)
                : null),
        boxShadow: widget.boxShadow ??
            (widget.variant == CardVariant.elevated ? shadowList : null),
      ),
      child: widget.isLoading
          ? SizedBox(
              height: 48,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              ),
            )
          : widget.child,
    );

    final wrappedCard = Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: _isHovered && widget.onTap != null
          ? ScaleTransition(
              scale: Tween<double>(begin: 1, end: 1.02).animate(
                CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
              ),
              child: cardChild,
            )
          : cardChild,
    );

    if (widget.onTap != null && widget.enabled) {
      return MouseRegion(
        onEnter: (_) => _onEnter(),
        onExit: (_) => _onExit(),
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onTap,
          borderRadius: radius,
          child: wrappedCard,
        ),
      );
    }

    return wrappedCard;
  }

  (Color, Color, List<BoxShadow>) _getVariantColors({
    required BuildContext context,
    required bool isDark,
    required CardVariant variant,
    Color? customColor,
  }) {
    switch (variant) {
      case CardVariant.elevated:
        return (
          customColor ?? (isDark ? AppColors.darkSurfaceBright : Colors.white),
          isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.grey200,
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case CardVariant.filled:
        return (
          customColor ??
              (isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.grey100),
          Colors.transparent,
          [],
        );

      case CardVariant.outlined:
        return (
          Colors.transparent,
          isDark ? AppColors.darkOutline : AppColors.grey300,
          [],
        );

      case CardVariant.tonal:
        return (
          customColor ??
              (isDark
                  ? AppColors.primaryDark.withValues(alpha: 0.12)
                  : AppColors.primarySoft),
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          [],
        );
    }
  }
}
