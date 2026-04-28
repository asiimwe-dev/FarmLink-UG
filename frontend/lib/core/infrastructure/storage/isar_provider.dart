// ignore_for_file: unused_import

// import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:farmcom/core/utils/logger.dart';
import 'schemas/user_schema.dart';
import 'schemas/post_schema.dart';
import 'schemas/disease_schema.dart';
import 'schemas/transaction_schema.dart';
import 'schemas/sync_queue_schema.dart';
import 'schemas/crop_schema.dart';
import 'schemas/market_price_schema.dart';

// Stub for testing - Isar disabled due to AGP 8.x compatibility
late final dynamic isar;

/// Initialize Isar database with all schemas
/// Call this once in main.dart before running the app
/// TODO: Re-enable when AGP 8.x compatibility is resolved
Future<dynamic> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  Logger.i('⏳ Isar database path prepared: ${dir.path}');

  // Stub implementation for UI testing
  // Real implementation requires Isar 3.2.0+ for AGP 8.x support
  return null;
}


/// Get the global Isar instance
dynamic getIsarInstance() {
  throw StateError('Isar not initialized. Disabled for AGP 8.x compatibility.');
}

/// Close Isar database (call on app shutdown)
Future<void> closeIsar() async {
  // Stub implementation
}

/// Clear all data (for testing/logout)
Future<void> clearIsarData() async {
  // Stub implementation
}
