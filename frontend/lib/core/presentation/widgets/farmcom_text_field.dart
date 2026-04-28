import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/theme/app_typography.dart';

/// Professional text input component with validation support
/// Handles both light and dark modes seamlessly
class FarmComTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final dynamic prefixIcon; // IconData or Widget
  final dynamic suffixIcon; // IconData or Widget
  final Widget? customSuffixWidget;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final TextAlign textAlign;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;
  final bool showCharacterCount;
  final bool isRequired;

  const FarmComTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.customSuffixWidget,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.style,
    this.showCharacterCount = false,
    this.isRequired = false,
  });

  @override
  State<FarmComTextField> createState() => _FarmComTextFieldState();
}

class _FarmComTextFieldState extends State<FarmComTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _toggleObscureText() {
    setState(() => _isObscured = !_isObscured);
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;

    if (widget.prefixIcon is IconData) {
      return Icon(
        widget.prefixIcon as IconData,
        color: _isFocused
            ? AppColors.primary
            : (Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary),
        size: 20,
      );
    }
    return widget.prefixIcon as Widget;
  }

  Widget? _buildSuffixIcon() {
    if (widget.customSuffixWidget != null) return widget.customSuffixWidget;

    if (widget.obscureText) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: Icon(
          _isObscured
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextSecondary
              : AppColors.textSecondary,
          size: 20,
        ),
      );
    }

    if (widget.suffixIcon != null) {
      if (widget.suffixIcon is IconData) {
        return Icon(
          widget.suffixIcon as IconData,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextSecondary
              : AppColors.textSecondary,
          size: 20,
        );
      }
      return widget.suffixIcon as Widget;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with required indicator
        if (widget.labelText != null) ...[
          Row(
            children: [
              Text(
                widget.labelText!,
                style: AppTypography.labelLarge.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Text field with enhanced styling
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText ? _isObscured : false,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          textAlign: widget.textAlign,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          style: widget.style ??
              AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.textTertiary,
            ),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(),
            errorText: null, // Handled separately below
            counterText: widget.showCharacterCount ? null : '',
            counterStyle: AppTypography.labelSmall.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.textTertiary,
            ),
            filled: true,
            fillColor: widget.enabled
                ? (isDark ? AppColors.darkSurfaceVariant : AppColors.grey50)
                : (isDark ? AppColors.darkGrey300 : AppColors.grey100),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : AppColors.grey300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.error
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppColors.grey300),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            isDense: false,
          ),
        ),

        // Helper text or error message
        if (widget.helperText != null || hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText ?? widget.helperText ?? '',
            style: AppTypography.labelSmall.copyWith(
              color: hasError
                  ? AppColors.error
                  : (isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.textTertiary),
              fontWeight: hasError ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
