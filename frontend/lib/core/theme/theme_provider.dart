import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme state with font size and mode configuration
class ThemeState {
  final ThemeMode themeMode;
  final double fontSizeMultiplier;

  ThemeState({
    required this.themeMode,
    required this.fontSizeMultiplier,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    double? fontSizeMultiplier,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
    );
  }
}

/// Theme notifier for state management and persistence
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
      : super(ThemeState(
          themeMode: ThemeMode.system,
          fontSizeMultiplier: 1.0,
        ));

  /// Set the theme mode (light, dark, or system)
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// Set the font size multiplier for accessibility
  void setFontSize(double multiplier) {
    // Clamp multiplier between 0.8 and 1.4 for reasonable bounds
    final clampedMultiplier = multiplier.clamp(0.8, 1.4);
    state = state.copyWith(fontSizeMultiplier: clampedMultiplier);
  }

  /// Reset to default theme settings
  void resetToDefaults() {
    state = ThemeState(
      themeMode: ThemeMode.system,
      fontSizeMultiplier: 1.0,
    );
  }

  /// Toggle between light and dark mode
  void toggleThemeMode() {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    setThemeMode(newMode);
  }
}

/// Riverpod provider for theme state management
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
