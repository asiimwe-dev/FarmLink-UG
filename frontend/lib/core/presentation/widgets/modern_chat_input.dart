import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:farmcom/core/theme/app_colors.dart';

/// Professional, modern floating chat input area
class ModernChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onMic;
  final String hintText;

  const ModernChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.onMic,
    this.hintText = 'Message...',
  });

  @override
  State<ModernChatInput> createState() => _ModernChatInputState();
}

class _ModernChatInputState extends State<ModernChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateTextState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextState);
    super.dispose();
  }

  void _updateTextState() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding > 0 ? bottomPadding : 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? const Color(0xFF2C2C2E).withValues(alpha: 0.8) 
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isDark 
                          ? Colors.white.withValues(alpha: 0.1) 
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Attachment button
                      _InputButton(
                        icon: Icons.add_rounded,
                        onTap: widget.onAttach,
                        isPrimary: true,
                      ),
                      const SizedBox(width: 8),
                      // Input field
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: TextField(
                            controller: widget.controller,
                            maxLines: 5,
                            minLines: 1,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.grey900,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.hintText,
                              hintStyle: TextStyle(
                                color: isDark ? Colors.white38 : AppColors.grey500,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Send/Mic button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                        child: _InputButton(
                          key: ValueKey(_hasText),
                          icon: _hasText ? Icons.send_rounded : Icons.mic_rounded,
                          onTap: _hasText ? widget.onSend : widget.onMic,
                          isPrimary: _hasText,
                          color: _hasText ? AppColors.primary : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final Color? color;

  const _InputButton({
    super.key,
    required this.icon,
    this.onTap,
    this.isPrimary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? (isPrimary ? AppColors.primary : Colors.transparent);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPrimary ? effectiveColor : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isPrimary ? Colors.white : (isDark ? Colors.white60 : AppColors.grey600),
            size: 22,
          ),
        ),
      ),
    );
  }
}
