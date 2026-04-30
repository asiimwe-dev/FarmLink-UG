import 'package:flutter/material.dart';

/// Utility class for time-aware greetings
class TimeGreetingHelper {
  /// Get greeting based on current time
  /// Returns (greeting, emoji) tuple
  static (String, String) getGreeting({DateTime? customTime}) {
    final now = customTime ?? DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return ('Good Morning', '🌅');
    } else if (hour >= 12 && hour < 17) {
      return ('Good Afternoon', '🌤');
    } else if (hour >= 17 && hour < 20) {
      return ('Good Evening', '🌆');
    } else {
      return ('Good Night', '🌙');
    }
  }

  /// Get greeting with farmer name
  static String getPersonalizedGreeting(String farmerName, {DateTime? customTime}) {
    final (greeting, emoji) = getGreeting(customTime: customTime);
    return '$emoji $greeting, $farmerName!';
  }

  /// Get time period label
  static String getTimePeriod({DateTime? customTime}) {
    final (greeting, _) = getGreeting(customTime: customTime);
    return greeting;
  }

  /// Get emoji based on time
  static String getTimeEmoji({DateTime? customTime}) {
    final (_, emoji) = getGreeting(customTime: customTime);
    return emoji;
  }

  /// Get color based on time period for theme adaptation
  static Color getGreetingColor(BuildContext context) {
    final hour = DateTime.now().hour;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (hour >= 5 && hour < 12) {
      // Morning - use energy colors (orange/yellow)
      return isDark ? Colors.orange.shade300 : Colors.orange;
    } else if (hour >= 12 && hour < 17) {
      // Afternoon - use bright colors
      return isDark ? Colors.amber.shade300 : Colors.amber;
    } else if (hour >= 17 && hour < 20) {
      // Evening - use warm colors
      return isDark ? Colors.deepOrange.shade300 : Colors.deepOrange;
    } else {
      // Night - use cool colors
      return isDark ? Colors.indigo.shade300 : Colors.indigo;
    }
  }

  /// Get background gradient based on time period
  static LinearGradient getGreetingGradient({DateTime? customTime}) {
    final hour = customTime?.hour ?? DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      // Morning gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.amber.shade200,
          Colors.orange.shade300,
        ],
      );
    } else if (hour >= 12 && hour < 17) {
      // Afternoon gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.yellow.shade200,
          Colors.amber.shade300,
        ],
      );
    } else if (hour >= 17 && hour < 20) {
      // Evening gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrange.shade200,
          Colors.orange.shade400,
        ],
      );
    } else {
      // Night gradient
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.indigo.shade300,
          Colors.blue.shade500,
        ],
      );
    }
  }

  /// Get motivational phrase based on time
  static String getMotivationalPhrase({DateTime? customTime}) {
    final hour = customTime?.hour ?? DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Rise and shine! Let\'s grow today.';
    } else if (hour >= 12 && hour < 17) {
      return 'Keep growing! You\'re doing great.';
    } else if (hour >= 17 && hour < 20) {
      return 'Winding down? Let\'s wrap up your day.';
    } else {
      return 'Rest well. See you tomorrow!';
    }
  }

  /// Check if currently in farming hours (6 AM - 6 PM)
  static bool isInFarmingHours({DateTime? customTime}) {
    final hour = customTime?.hour ?? DateTime.now().hour;
    return hour >= 6 && hour < 18;
  }

  /// Get time-appropriate action suggestion
  static String getActionSuggestion({DateTime? customTime}) {
    final hour = customTime?.hour ?? DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      return 'Perfect time to check your fields or take a diagnostic photo';
    } else if (hour >= 12 && hour < 16) {
      return 'Browse market prices and connect with your community';
    } else if (hour >= 16 && hour < 18) {
      return 'Time to plan tomorrow\'s farm activities';
    } else {
      return 'Review your day\'s activities and updates';
    }
  }
}
