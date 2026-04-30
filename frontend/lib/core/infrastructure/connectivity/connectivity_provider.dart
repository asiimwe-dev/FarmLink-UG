import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that monitors the device's connectivity status.
/// Consolidates connectivity logic into a single place.

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// A simpler provider that returns true if the device has any active connection.
final isOnlineProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityProvider);
  
  return connectivityAsync.maybeWhen(
    data: (result) => result != ConnectivityResult.none,
    orElse: () => true, // Assume online while loading to avoid flickering
  );
});
