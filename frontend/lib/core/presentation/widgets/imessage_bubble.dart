import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_colors.dart';

/// iMessage-style chat bubble for modern messaging experience
class iMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final VoidCallback? onLongPress;

  const iMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.onLongPress,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = _formatTime(timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primarySoft.withValues(alpha: 0.5),
                child: const Icon(Icons.smart_toy_rounded, size: 16, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onLongPress: onLongPress,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF2C2C2E) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : (isDark ? Colors.white : AppColors.grey900),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        timeStr,
                        style: TextStyle(
                          color: isUser ? Colors.white.withValues(alpha: 0.6) : (isDark ? Colors.white38 : AppColors.grey500),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

/// Community chat bubble with sender info
class CommunityChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String senderName;
  final String? senderRole;
  final DateTime? timestamp;
  final bool isExpert;
  final VoidCallback? onLongPress;

  const CommunityChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.senderName,
    this.senderRole,
    this.timestamp,
    this.isExpert = false,
    this.onLongPress,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = _formatTime(timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    senderName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isExpert ? AppColors.tertiary : (isDark ? Colors.white70 : AppColors.grey700),
                    ),
                  ),
                  if (isExpert) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EXPERT',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: AppColors.tertiary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorForName(senderName).withValues(alpha: 0.2),
                  child: Text(
                    senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: colorForName(senderName),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              GestureDetector(
                onLongPress: onLongPress,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : (isDark ? const Color(0xFF2C2C2E) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isUser ? Colors.white : (isDark ? Colors.white : AppColors.grey900),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      if (timeStr.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            timeStr,
                            style: TextStyle(
                              color: isUser ? Colors.white.withValues(alpha: 0.6) : (isDark ? Colors.white38 : AppColors.grey500),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color colorForName(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[name.length % colors.length];
  }
}

