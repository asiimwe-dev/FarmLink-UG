import 'package:flutter/material.dart';

/// FarmCom Professional Color System
/// Implements Material 3 with comprehensive dark mode support
class AppColors {
  // ============ Primary: Farm Green ============
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySoft = Color(0xFFE8F5E9);
  static const Color primaryContainer = Color(0xFFC8E6C9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0B3D1F);

  // ============ Secondary: Soil Orange ============
  static const Color secondary = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFE65100);
  static const Color secondarySoft = Color(0xFFFFF3E0);
  static const Color secondaryContainer = Color(0xFFFFE0B2);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF663800);

  // ============ Tertiary: Water Blue ============
  static const Color tertiary = Color(0xFF0277BD);
  static const Color tertiaryLight = Color(0xFF039BE5);
  static const Color tertiaryDark = Color(0xFF01579B);
  static const Color tertiarySoft = Color(0xFFE1F5FE);
  static const Color tertiaryContainer = Color(0xFFB3E5FC);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF004D73);

  // ============ Status Colors ============
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorContainer = Color(0xFFFFCDD2);
  static const Color info = Color(0xFF1976D2);
  static const Color infoLight = Color(0xFF42A5F5);

  // ============ Light Mode: Neutral Colors ============
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============ Dark Mode: Neutral Colors ============
  static const Color darkGrey50 = Color(0xFF1F1F1F);
  static const Color darkGrey100 = Color(0xFF2C2C2C);
  static const Color darkGrey150 = Color(0xFF333333);
  static const Color darkGrey200 = Color(0xFF3A3A3A);
  static const Color darkGrey300 = Color(0xFF424242);
  static const Color darkGrey400 = Color(0xFF4A4A4A);
  static const Color darkGrey500 = Color(0xFF616161);
  static const Color darkGrey600 = Color(0xFF757575);

  // ============ Light Mode: Semantic ============
  static const Color surface = Color(0xFFFEFEFE);
  static const Color surfaceDim = Color(0xFFEEEEEE);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundVariant = Color(0xFFF9F9F9);
  static const Color divider = Color(0xFFEEEEEE);

  // ============ Dark Mode: Semantic ============
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceDim = Color(0xFF0F0F0F);
  static const Color darkSurfaceBright = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkBackgroundVariant = Color(0xFF1A1A1A);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkOutline = Color(0xFF3F3F3F);

  // ============ Container Colors ============
  static const Color containerLight = Color(0xFFEEEEEE);
  static const Color containerDark = Color(0xFF2C2C2C);
  static const Color containerLightHover = Color(0xFFE0E0E0);
  static const Color containerDarkHover = Color(0xFF3A3A3A);

  // ============ Text Colors ============
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkTextTertiary = Color(0xFF9E9E9E);

  // ============ Special UI Colors ============
  static const Color glassStart = Color(0x1FFFFFFF);
  static const Color glassEnd = Color(0x0FFFFFFF);
  static const Color glassStartDark = Color(0x1AFFFFFF);
  static const Color glassEndDark = Color(0x08FFFFFF);

  // ============ Shadows ============
  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x33000000);
  static const Color primaryShadow = Color(0x402E7D32);

  // ============ Utility Methods ============
  /// Get semantic colors based on brightness
  static Color surfaceForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurface : surface;
  }

  static Color onSurfaceForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextPrimary : textPrimary;
  }

  static Color containerForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? containerDark : containerLight;
  }

  static Color outlineForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? darkOutline : divider;
  }
}
