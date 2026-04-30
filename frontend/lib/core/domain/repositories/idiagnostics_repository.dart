import 'package:farmlink_ug/core/domain/repositories/icommunity_repository.dart';

/// Diagnostics (AI Camera) repository contract
/// Implemented by features/diagnostics/data/repositories/diagnostics_repository.dart
abstract class IDiagnosticsRepository {
  /// Analyze plant image for diseases
  /// Returns diagnosis with disease info, confidence, and treatment
  Future<Diagnosis> analyzePlantImage(String imagePath);

  /// Get diagnosis history
  Future<List<Diagnosis>> getDiagnosisHistory({
    int page = 1,
    int pageSize = 20,
  });

  /// Watch diagnosis history stream
  Stream<List<Diagnosis>> watchDiagnosisHistory();

  /// Save diagnosis result locally
  Future<void> saveDiagnosis(Diagnosis diagnosis);

  /// Delete diagnosis record
  Future<void> deleteDiagnosis(String diagnosisId);

  /// Get single diagnosis details
  Future<Diagnosis?> getDiagnosis(String diagnosisId);

  /// Get remedy details for a disease
  Future<Remedy?> getRemedy(String diseaseId);

  /// Report diagnosis accuracy (for model improvement)
  Future<void> reportFeedback({
    required String diagnosisId,
    required bool isAccurate,
    String? correctDisease,
    String? notes,
  });

  /// Get pending diagnoses (not yet synced)
  Future<List<Diagnosis>> getPendingDiagnoses();

  /// Sync pending diagnoses
  Future<void> syncPendingDiagnoses();
}

/// Diagnosis result entity
class Diagnosis {
  final String id;
  final String userId;
  final String imagePath; // Local path or URL
  final String? imageThumbnailUrl;
  final List<DiseaseDetection> detections; // Can be multiple diseases
  final String plantHealth; // "healthy", "diseased", "unknown"
  final DateTime analyzedAt;
  final String? apiReference; // Plant.id reference
  final bool isPending; // Not yet synced
  final bool isSynced;
  final SyncStatus syncStatus;
  final String? syncErrorMessage;

  Diagnosis({
    required this.id,
    required this.userId,
    required this.imagePath,
    this.imageThumbnailUrl,
    this.detections = const [],
    this.plantHealth = 'unknown',
    required this.analyzedAt,
    this.apiReference,
    this.isPending = false,
    this.isSynced = false,
    this.syncStatus = SyncStatus.synced,
    this.syncErrorMessage,
  });

  /// Copy with modifications
  Diagnosis copyWith({
    String? id,
    String? userId,
    String? imagePath,
    String? imageThumbnailUrl,
    List<DiseaseDetection>? detections,
    String? plantHealth,
    DateTime? analyzedAt,
    String? apiReference,
    bool? isPending,
    bool? isSynced,
    SyncStatus? syncStatus,
    String? syncErrorMessage,
  }) {
    return Diagnosis(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      imageThumbnailUrl: imageThumbnailUrl ?? this.imageThumbnailUrl,
      detections: detections ?? this.detections,
      plantHealth: plantHealth ?? this.plantHealth,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      apiReference: apiReference ?? this.apiReference,
      isPending: isPending ?? this.isPending,
      isSynced: isSynced ?? this.isSynced,
      syncStatus: syncStatus ?? this.syncStatus,
      syncErrorMessage: syncErrorMessage ?? this.syncErrorMessage,
    );
  }
}

/// Single disease detection from the AI model
class DiseaseDetection {
  final String diseaseId;
  final String diseaseName;
  final double confidence; // 0.0 - 1.0
  final String? description;
  final Remedy? suggestedRemedy;

  DiseaseDetection({
    required this.diseaseId,
    required this.diseaseName,
    required this.confidence,
    this.description,
    this.suggestedRemedy,
  });
}

/// Treatment/remedy for a disease
class Remedy {
  final String id;
  final String diseaseId;
  final String title;
  final String description;
  final List<String> steps; // Treatment procedure
  final List<String>? chemicalTreatments; // Optional pesticides
  final List<String>? organicAlternatives; // Organic options
  final String? warningInfo; // Safety warnings
  final int daysToRecovery; // Estimated time to plant recovery

  Remedy({
    required this.id,
    required this.diseaseId,
    required this.title,
    required this.description,
    this.steps = const [],
    this.chemicalTreatments,
    this.organicAlternatives,
    this.warningInfo,
    this.daysToRecovery = 7,
  });
}
