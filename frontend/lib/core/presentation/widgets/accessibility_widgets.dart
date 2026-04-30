import 'package:flutter/material.dart';
import 'dart:math';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Accessibility audit and compliance utilities for WCAG 2.1 AA
class AccessibilityAudit {
  /// Verify text contrast ratio meets WCAG AA standard (4.5:1 minimum)
  static bool verifyContrastRatio(Color foreground, Color background) {
    final fgLuminance = _getRelativeLuminance(foreground);
    final bgLuminance = _getRelativeLuminance(background);

    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;

    final contrastRatio = (lighter + 0.05) / (darker + 0.05);
    return contrastRatio >= 4.5; // WCAG AA standard
  }

  /// Get relative luminance of a color
  static double _getRelativeLuminance(Color color) {
    // Extract ARGB components from the color value
    final value = color.value;
    final r = _linearizeChannel(((value >> 16) & 0xFF) / 255.0);
    final g = _linearizeChannel(((value >> 8) & 0xFF) / 255.0);
    final b = _linearizeChannel((value & 0xFF) / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize RGB channel for luminance calculation
  static double _linearizeChannel(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    }
    return pow((value + 0.055) / 1.055, 2).toDouble();
  }

  /// Check if text is readable with minimum font size
  static bool verifyMinimumFontSize(double fontSize) {
    return fontSize >= 14; // Minimum readable size
  }

  /// Check if touch target meets minimum size (48x48 dp)
  static bool verifyTouchTargetSize(Size size) {
    return size.width >= 48 && size.height >= 48;
  }
}

/// Semantic wrapper for icon buttons with proper accessibility and tooltip
class SemanticIconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const SemanticIconButton({
    Key? key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.color,
    this.size = 24,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      onTap: onPressed,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: IconButton(
          icon: Icon(icon),
          color: color,
          iconSize: size,
          onPressed: onPressed,
          tooltip: tooltip ?? semanticLabel,
        ),
      ),
    );
  }
}

/// Semantic wrapper for text with proper labeling
class SemanticText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? semanticLabel;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SemanticText(
    this.text, {
    Key? key,
    this.style,
    this.semanticLabel,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// Focus indicator widget for keyboard navigation
class FocusIndicator extends StatefulWidget {
  final Widget child;
  final Color focusColor;
  final Color normalColor;
  final double borderRadius;

  const FocusIndicator({
    Key? key,
    required this.child,
    this.focusColor = AppColors.primary,
    this.normalColor = Colors.transparent,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  State<FocusIndicator> createState() => _FocusIndicatorState();
}

class _FocusIndicatorState extends State<FocusIndicator> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) => KeyEventResult.handled,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasFocus ? widget.focusColor : widget.normalColor,
            width: _hasFocus ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: widget.child,
      ),
    );
  }
}

/// High contrast text for better readability
class HighContrastText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? backgroundColor;

  const HighContrastText(
    this.text, {
    Key? key,
    this.style,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.surface);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: style?.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Semantic container for form sections
class AccessibleFormSection extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;

  const AccessibleFormSection({
    Key? key,
    this.title,
    this.description,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: title ?? 'Form section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: AppTypography.labelLarge,
              semanticsLabel: title,
            ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: AppTypography.labelSmall,
              semanticsLabel: description,
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Accessibility header for sections
class AccessibilityHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int headerLevel; // 1-6 for semantic levels

  const AccessibilityHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.headerLevel = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final semanticsLevel = headerLevel.clamp(1, 6);

    return Semantics(
      header: true,
      label: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: _getHeaderStyle(semanticsLevel),
            semanticsLabel: title,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.bodySmall,
              semanticsLabel: subtitle,
            ),
          ],
        ],
      ),
    );
  }

  TextStyle _getHeaderStyle(int level) {
    switch (level) {
      case 1:
        return AppTypography.displayLarge;
      case 2:
        return AppTypography.headlineLarge;
      case 3:
        return AppTypography.headlineMedium;
      case 4:
        return AppTypography.titleLarge;
      case 5:
      case 6:
        return AppTypography.labelLarge;
      default:
        return AppTypography.headlineMedium;
    }
  }
}

/// Screen reader announcement widget
class ScreenReaderAnnouncement extends StatelessWidget {
  final String message;
  final bool force;

  const ScreenReaderAnnouncement({
    Key? key,
    required this.message,
    this.force = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      enabled: force,
      child: const SizedBox.shrink(),
    );
  }
}

/// Accessible badge with proper contrast
class AccessibleBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const AccessibleBadge({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verify contrast ratio
    final hasGoodContrast =
        AccessibilityAudit.verifyContrastRatio(textColor, backgroundColor);

    if (!hasGoodContrast) {
      debugPrint(
        'Warning: Badge "$label" has poor contrast ratio. '
        'Please verify text/background colors for WCAG AA compliance.',
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Semantics(
        label: label,
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: textColor),
        ),
      ),
    );
  }
}
