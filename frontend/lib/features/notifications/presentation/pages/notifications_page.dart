import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/routing/app_routes.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Market Price Alert',
      'message': 'Coffee prices increased by 2.5% in your region',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.trending_up_rounded,
      'color': AppColors.success,
      'isRead': true,
    },
    {
      'id': 2,
      'title': 'Community Update',
      'message': 'New post from Kampala Farmers: Tips for drought-resistant crops',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.groups_rounded,
      'color': AppColors.primary,
      'isRead': true,
    },
    {
      'id': 3,
      'title': 'Field Guide Recommendation',
      'message': 'New guide available: Managing soil nutrients during rainy season',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'icon': Icons.library_books_rounded,
      'color': AppColors.info,
      'isRead': false,
    },
    {
      'id': 4,
      'title': 'Weather Alert',
      'message': 'Heavy rainfall expected tomorrow. Prepare your crops accordingly.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.cloud_rounded,
      'color': AppColors.warning,
      'isRead': false,
    },
    {
      'id': 5,
      'title': 'Diagnostic Result',
      'message': 'Your tomato leaf spot analysis is ready. View results now.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.health_and_safety_rounded,
      'color': AppColors.error,
      'isRead': true,
    },
    {
      'id': 6,
      'title': 'Payment Confirmation',
      'message': 'Successfully purchased premium seeds package - UGX 50,000',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.payment_rounded,
      'color': Colors.green,
      'isRead': true,
    },
  ];

  void _markAsRead(int id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((n) => n['id'] == id);
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.grey50,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w900)),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in notifications) {
                    notification['isRead'] = true;
                  }
                });
              },
              child: const Text('Mark All Read', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_rounded, size: 64, color: AppColors.grey300),
                  const SizedBox(height: 16),
                  Text(
                    'No Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.grey900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re all caught up! Check back later.',
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : AppColors.grey500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification['id'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteNotification(notification['id']),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
                  ),
                  child: GestureDetector(
                    onTap: notification['isRead'] ? null : () => _markAsRead(notification['id']),
                    child: FarmComCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (notification['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              notification['icon'],
                              color: notification['color'],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: notification['isRead'] ? FontWeight.w600 : FontWeight.w800,
                                          color: isDark ? Colors.white : AppColors.grey900,
                                        ),
                                      ),
                                    ),
                                    if (!notification['isRead'])
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification['message'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.white70 : AppColors.grey600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatTime(notification['timestamp']),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white54 : AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
