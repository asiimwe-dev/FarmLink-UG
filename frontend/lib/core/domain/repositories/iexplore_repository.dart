/// Explore repository contract
/// Implemented by features/explore/data/repositories/explore_repository.dart
abstract class IExploreRepository {
  /// Fetch all crops with disease info
  Future<List<Crop>> fetchAllCrops();

  /// Search crops by name or keyword
  Future<List<Crop>> searchCrops(String query);

  /// Get single crop details with diseases and tips
  Future<Crop?> getCropDetails(String cropId);

  /// Watch crops stream for real-time updates
  Stream<List<Crop>> watchCrops();

  /// Get diseases for a specific crop
  Future<List<Disease>> getCropDiseases(String cropId);

  /// Search diseases by name or symptoms
  Future<List<Disease>> searchDiseases(String query);

  /// Get growing tips for a crop
  Future<List<GrowingTip>> getGrowingTips(String cropId);

  /// Save crop to user's favorites (offline)
  Future<void> addToFavorites(String cropId);

  /// Remove crop from favorites
  Future<void> removeFromFavorites(String cropId);

  /// Get user's favorite crops
  Future<List<Crop>> getFavoriteCrops();

  /// Add personal note to a crop
  Future<void> addNote(String cropId, String note);

  /// Get notes for a crop
  Future<List<CropNote>> getNotesForCrop(String cropId);
}

/// Crop entity
class Crop {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String? imageUrl;
  final List<String> growingSeasons;
  final String optimalTemperature;
  final String soilType;
  final int waterRequirement; // mm per month
  final List<Disease> diseases;
  final List<GrowingTip> tips;
  final DateTime? lastUpdated;

  Crop({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    this.imageUrl,
    this.growingSeasons = const [],
    required this.optimalTemperature,
    required this.soilType,
    required this.waterRequirement,
    this.diseases = const [],
    this.tips = const [],
    this.lastUpdated,
  });
}

/// Disease entity
class Disease {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatment;
  final List<String> prevention;
  final String? imageUrl;
  final String severity; // low, medium, high

  Disease({
    required this.id,
    required this.name,
    required this.description,
    this.symptoms = const [],
    this.causes = const [],
    this.treatment = const [],
    this.prevention = const [],
    this.imageUrl,
    required this.severity,
  });
}

/// Growing tip entity
class GrowingTip {
  final String id;
  final String title;
  final String content;
  final String season; // e.g., "Planting", "Growing", "Harvesting"
  final DateTime? datePosted;

  GrowingTip({
    required this.id,
    required this.title,
    required this.content,
    required this.season,
    this.datePosted,
  });
}

/// User's personal crop note
class CropNote {
  final String id;
  final String cropId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CropNote({
    required this.id,
    required this.cropId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });
}
