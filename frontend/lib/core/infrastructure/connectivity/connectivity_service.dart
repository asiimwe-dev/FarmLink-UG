import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity service to detect network status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  /// Check current connectivity status
  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
