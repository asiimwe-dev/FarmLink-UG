import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/utils/time_greeting_helper.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Dashboard header with personalized time-aware greeting
class PersonalizedGreetingHeader extends StatelessWidget {
  final String userName;
  final String? userProfileImage;
  final VoidCallback? onProfileTap;
  final Widget? trailingWidget;

  const PersonalizedGreetingHeader({
    Key? key,
    required this.userName,
    this.userProfileImage,
    this.onProfileTap,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (greeting, _) = TimeGreetingHelper.getGreeting();
    final gradient = TimeGreetingHelper.getGreetingGradient();
    final actionSuggestion = TimeGreetingHelper.getActionSuggestion();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with profile and trailing
          Row(
            children: [
              // Profile section
              if (userProfileImage != null)
                GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userProfileImage!),
                  ),
                )
              else
                GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              const SizedBox(width: 12),

              // Greeting text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $userName! 👋',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      TimeGreetingHelper.getTimePeriod(),
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing widget (notifications, settings, etc)
              if (trailingWidget != null) trailingWidget!,
            ],
          ),
          const SizedBox(height: 12),

          // Action suggestion card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getActionIcon(),
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    actionSuggestion,
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActionIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return Icons.camera_alt;
    } else if (hour >= 12 && hour < 16) {
      return Icons.trending_up;
    } else if (hour >= 16 && hour < 18) {
      return Icons.calendar_today;
    } else {
      return Icons.summarize;
    }
  }
}

/// Compact greeting banner for minimal space
class CompactGreetingBanner extends StatelessWidget {
  final String userName;

  const CompactGreetingBanner({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greeting = TimeGreetingHelper.getPersonalizedGreeting(userName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: TimeGreetingHelper.getGreetingColor(context).withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            _getTimeIcon(),
            color: TimeGreetingHelper.getGreetingColor(context),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              greeting,
              style: AppTypography.labelLarge.copyWith(
                color: TimeGreetingHelper.getGreetingColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTimeIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return Icons.wb_sunny;
    if (hour >= 12 && hour < 17) return Icons.cloud;
    if (hour >= 17 && hour < 20) return Icons.cloud_queue;
    return Icons.nights_stay;
  }
}

/// Greeting card with motivational phrase
class GreetingMotivationalCard extends StatelessWidget {
  final String userName;
  final VoidCallback? onActionTap;

  const GreetingMotivationalCard({
    Key? key,
    required this.userName,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greeting = TimeGreetingHelper.getPersonalizedGreeting(userName);
    final motivationalPhrase = TimeGreetingHelper.getMotivationalPhrase();
    final gradient = TimeGreetingHelper.getGreetingGradient();

    return GestureDetector(
      onTap: onActionTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: AppTypography.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              motivationalPhrase,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getWeatherEmoji(),
                  style: const TextStyle(fontSize: 24),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWeatherEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return '🌅';
    if (hour >= 12 && hour < 17) return '🌤';
    if (hour >= 17 && hour < 20) return '🌆';
    return '🌙';
  }
}
