import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/domain/entities/user.dart';
import 'package:farmcom/core/domain/exceptions/app_exception.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../data/datasources/remote_auth_datasource.dart';
import '../../data/datasources/local_auth_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/repositories/iauth_repository.dart';

// Repository provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remoteDataSource = RemoteAuthDataSource();
  final localDataSource = LocalAuthDataSource();
  
  return AuthRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// Usecases
final sendOTPUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SendOTPUseCase(repo);
});

final verifyOTPUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return VerifyOTPUseCase(repo);
});

final logoutUseCaseProvider = Provider((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repo);
});

// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final AppException? error;
  final String? message; // For UI feedback

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.message,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    AppException? error,
    String? message,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message ?? this.message,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final SendOTPUseCase sendOTPUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final LogoutUseCase logoutUseCase;
  final IAuthRepository authRepository;
  late StreamSubscription<User?> _userSubscription;

  AuthNotifier({
    required this.sendOTPUseCase,
    required this.verifyOTPUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(AuthState()) {
    // Initialize - check if user already logged in
    _initializeAuth();
  }

  void _initializeAuth() {
    _userSubscription = authRepository.watchCurrentUser().listen((user) {
      if (user != null && user.isLoggedIn) {
        state = state.copyWith(user: user, isLoading: false);
      }
    });
    
    // Auto-login demo user in debug mode for easier testing
    if (kDebugMode) {
      _loadDemoUser();
    }
  }
  
  /// Load demo user for development/testing (debug mode only)
  void _loadDemoUser() {
    final demoUser = User(
      id: 'demo_user_001',
      phone: '+256701234567',
      name: 'Test Farmer',
      createdAt: DateTime.now(),
      lastSignIn: DateTime.now(),
      isLoggedIn: true,
      region: 'Central Uganda',
      interests: ['Coffee', 'Maize'],
    );
    state = state.copyWith(user: demoUser);
  }

  Future<void> sendOTP(String phone) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      await sendOTPUseCase(phone);
      state = state.copyWith(
        isLoading: false,
        message: 'OTP sent to $phone',
      );
    } catch (e) {
      final error = e is AppException ? e : UnknownException(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: error,
        message: null,
      );
    }
  }

  Future<void> verifyOTP(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final user = await verifyOTPUseCase(phone, otp);
      state = state.copyWith(
        isLoading: false,
        user: user,
        message: 'Login successful!',
      );
    } catch (e) {
      final error = e is AppException ? e : UnknownException(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: error,
        message: null,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await logoutUseCase();
      state = AuthState();
    } catch (e) {
      final error = e is AppException ? e : UnknownException(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: error,
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? bio,
    String? region,
    List<String>? interests,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await authRepository.updateProfile(
        name: name,
        bio: bio,
        region: region,
        interests: interests,
      );
      state = state.copyWith(isLoading: false, user: updated);
    } catch (e) {
      final error = e is AppException ? e : UnknownException(e.toString());
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}

// Main auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final sendOTP = ref.watch(sendOTPUseCaseProvider);
  final verifyOTP = ref.watch(verifyOTPUseCaseProvider);
  final logout = ref.watch(logoutUseCaseProvider);
  final authRepo = ref.watch(authRepositoryProvider);

  return AuthNotifier(
    sendOTPUseCase: sendOTP,
    verifyOTPUseCase: verifyOTP,
    logoutUseCase: logout,
    authRepository: authRepo,
  );
});
