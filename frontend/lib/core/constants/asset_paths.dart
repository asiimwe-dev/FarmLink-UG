/// Asset paths
class AssetPaths {
  // Images
  static const String logoMain = 'assets/images/logo_main.png';
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String logoLight = 'assets/images/logo_light.png';

  // Illustrations
  static const String illustrationNoConnection =
      'assets/images/illustration_no_connection.png';
  static const String illustrationEmpty = 'assets/images/illustration_empty.png';
  static const String illustrationError = 'assets/images/illustration_error.png';

  // Icons (if not using Flutter's built-in icons)
  static const String iconCommunity = 'assets/icons/community.svg';
  static const String iconExplore = 'assets/icons/explore.svg';
  static const String iconCamera = 'assets/icons/camera.svg';
  static const String iconProfile = 'assets/icons/profile.svg';
  static const String iconHome = 'assets/icons/home.svg';
  static const String iconSearch = 'assets/icons/search.svg';
  static const String iconNotification = 'assets/icons/notification.svg';
  static const String iconSettings = 'assets/icons/settings.svg';

  // Lottie Animations
  static const String lottieLoading = 'assets/lottie/loading.json';
  static const String lottieSuccess = 'assets/lottie/success.json';
  static const String lottieError = 'assets/lottie/error.json';
  static const String lottieSync = 'assets/lottie/sync.json';

  // Ensure assets folders exist:
  static const List<String> requiredAssetFolders = [
    'assets/images/',
    'assets/images/community/',
    'assets/images/explore/',
    'assets/images/diagnostics/',
    'assets/images/auth/',
    'assets/icons/',
    'assets/lottie/',
    'assets/fonts/',
  ];
}

/// Community feature asset paths
class CommunityAssets {
  static const String emptyFeed = 'assets/images/community/empty_feed.png';
}

/// Explore feature asset paths
class ExploreAssets {
  static const String emptyGuide = 'assets/images/explore/empty.png';
}

/// Diagnostics feature asset paths
class DiagnosticsAssets {
  static const String cameraPlaceholder =
      'assets/images/diagnostics/camera_placeholder.png';
  static const String healthyPlant =
      'assets/images/diagnostics/healthy_plant.png';
  static const String diseasedPlant =
      'assets/images/diagnostics/diseased_plant.png';
}

/// Auth feature asset paths
class AuthAssets {
  static const String phoneVerification =
      'assets/images/auth/phone_verification.png';
}
