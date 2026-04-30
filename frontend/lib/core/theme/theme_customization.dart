import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Theme customization provider with light/dark mode support
class ThemeCustomizationProvider {
  /// Get light theme with customized colors
  static ThemeData lightTheme({
    Color? primary,
    Color? secondary,
    Color? tertiary,
  }) {
    final primaryColor = primary ?? AppColors.primary;
    final secondaryColor = secondary ?? AppColors.secondary;
    final tertiaryColor = tertiary ?? AppColors.tertiary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.grey[600],
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.grey[400],
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200],
        labelStyle: AppTypography.labelSmall,
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerTheme: DividerThemeData(color: Colors.grey[200], thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }

  /// Get dark theme with customized colors
  static ThemeData darkTheme({
    Color? primary,
    Color? secondary,
    Color? tertiary,
  }) {
    final primaryColor = primary ?? AppColors.primary;
    final secondaryColor = secondary ?? AppColors.secondary;
    final tertiaryColor = tertiary ?? AppColors.tertiary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: const Color(0xFF121212),
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.grey[600],
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        labelStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        side: BorderSide(color: Colors.grey[700]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      dividerTheme: DividerThemeData(color: Colors.grey[800], thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }

  /// Build consistent text theme
  static TextTheme _buildTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primaryColor),
      displayMedium: AppTypography.displayMedium.copyWith(color: primaryColor),
      displaySmall: AppTypography.displaySmall.copyWith(color: primaryColor),
      headlineLarge: AppTypography.headlineLarge.copyWith(color: primaryColor),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: primaryColor),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: primaryColor),
      titleLarge: AppTypography.titleLarge.copyWith(color: primaryColor),
      titleMedium: AppTypography.titleMedium.copyWith(color: primaryColor),
      titleSmall: AppTypography.titleSmall.copyWith(color: primaryColor),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primaryColor),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: primaryColor),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondaryColor),
      labelLarge: AppTypography.labelLarge.copyWith(color: primaryColor),
      labelMedium: AppTypography.labelMedium.copyWith(color: primaryColor),
      labelSmall: AppTypography.labelSmall.copyWith(color: secondaryColor),
    );
  }
}

/// High contrast color scheme for accessibility
class HighContrastColorScheme {
  static const primary = Color(0xFF1B5E20);
  static const secondary = Color(0xFFBF360C);
  static const tertiary = Color(0xFF0D47A1);
  static const error = Color(0xFFB71C1C);

  static ThemeData lightTheme() =>
      ThemeCustomizationProvider.lightTheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );

  static ThemeData darkTheme() =>
      ThemeCustomizationProvider.darkTheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );
}

/// Sepia tone color scheme for eye comfort
class SepiaColorScheme {
  static const primary = Color(0xFF8B7355);
  static const secondary = Color(0xFFD2B48C);
  static const tertiary = Color(0xFF6B4423);
  static const error = Color(0xFFDC143C);

  static ThemeData lightTheme() =>
      ThemeCustomizationProvider.lightTheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );

  static ThemeData darkTheme() =>
      ThemeCustomizationProvider.darkTheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );
}

/// Cool blue color scheme for relaxation
class CoolBlueColorScheme {
  static const primary = Color(0xFF0277BD);
  static const secondary = Color(0xFF00BCD4);
  static const tertiary = Color(0xFF1A237E);
  static const error = Color(0xFFD32F2F);

  static ThemeData lightTheme() =>
      ThemeCustomizationProvider.lightTheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );

  static ThemeData darkTheme() =>
      ThemeCustomizationProvider.darkTheme(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      );
}

/// System theme mode
enum SystemThemeMode {
  light,
  dark,
  system,
}

/// Theme persistence service
class ThemePersistenceService {
  static const String _key = 'app_theme_mode';
  static const String _colorSchemeKey = 'app_color_scheme';

  Future<SystemThemeMode> loadThemeMode() async {
    // Implementation would use shared_preferences or local storage
    return SystemThemeMode.system;
  }

  Future<void> saveThemeMode(SystemThemeMode mode) async {
    // Implementation would use shared_preferences or local storage
  }

  Future<String> loadColorScheme() async {
    // Implementation would use shared_preferences or local storage
    return 'default';
  }

  Future<void> saveColorScheme(String scheme) async {
    // Implementation would use shared_preferences or local storage
  }
}
