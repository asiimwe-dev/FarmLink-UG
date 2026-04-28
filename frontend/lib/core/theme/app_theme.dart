import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// FarmCom Material 3 Professional Theme
/// Implements comprehensive design system with proper dark mode support
class AppTheme {
  static ThemeData lightTheme(double multiplier) {
    return _buildTheme(Brightness.light, multiplier);
  }

  static ThemeData darkTheme(double multiplier) {
    return _buildTheme(Brightness.dark, multiplier);
  }

  static ThemeData _buildTheme(Brightness brightness, double multiplier) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: isDark ? AppColors.primaryDark : AppColors.primarySoft,
      onPrimaryContainer: isDark ? AppColors.primaryLight : AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: isDark ? AppColors.secondaryDark : AppColors.secondarySoft,
      onSecondaryContainer: isDark ? AppColors.secondaryLight : AppColors.secondaryDark,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.white,
      surface: isDark ? AppColors.darkSurface : AppColors.surface,
      onSurface: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      surfaceVariant: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
      onSurfaceVariant: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      error: AppColors.error,
      onError: AppColors.white,
      outline: isDark ? AppColors.darkOutline : AppColors.divider,
    );

    // Base theme data
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.background,

      // ============ Typography ============
      textTheme: AppTypography.getTextTheme().apply(
        fontSizeFactor: multiplier,
        bodyColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        displayColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),

      // ============ AppBar Theme ============
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontSize: (AppTypography.titleLarge.fontSize ?? 22) * multiplier,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        surfaceTintColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
      ),

      // ============ Card Theme ============
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurfaceBright : AppColors.white,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.grey200,
            width: 1,
          ),
        ),
        surfaceTintColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
      ),

      // ============ Divider Theme ============
      dividerTheme: DividerThemeData(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.grey200,
        thickness: 1,
        space: 16,
      ),

      // ============ Input Decoration Theme ============
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceVariant : AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.grey300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        errorStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.error,
        ),
      ),

      // ============ Elevated Button Theme ============
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.primaryShadow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTypography.titleMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============ Outlined Button Theme ============
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTypography.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============ Text Button Theme ============
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTypography.labelLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============ Icon Button Theme ============
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          hoverColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),

      // ============ FloatingActionButton Theme ============
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ============ Chip Theme ============
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.grey100,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : AppColors.grey300,
        ),
      ),

      // ============ Bottom Navigation Theme ============
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ============ Bottom Sheet Theme ============
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        elevation: 8,
        surfaceTintColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
      ),

      // ============ Dialog Theme ============
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        surfaceTintColor: isDark ? AppColors.darkSurfaceBright : AppColors.white,
      ),

      // ============ Snackbar Theme ============
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),

      // ============ Progress Indicator Theme ============
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearMinHeight: 4,
      ),

      // ============ List Tile Theme ============
      listTileTheme: ListTileThemeData(
        textColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        iconColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        tileColor: isDark ? AppColors.darkSurfaceVariant : AppColors.grey50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ============ Tooltip Theme ============
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGrey500 : AppColors.grey800,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.white,
        ),
        preferBelow: true,
      ),

      // ============ Search Bar Theme ============
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(
          isDark ? AppColors.darkSurfaceVariant : AppColors.grey100,
        ),
        shadowColor: const WidgetStatePropertyAll(AppColors.shadow),
        elevation: const WidgetStatePropertyAll(2),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // ============ Slider Theme ============
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : AppColors.grey300,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.primary,
        trackHeight: 4,
      ),
    );

    return baseTheme;
  }
}
