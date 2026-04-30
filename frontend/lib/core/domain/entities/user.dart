import 'package:equatable/equatable.dart';

/// Verification status for users
enum VerificationStatus {
  unverified,
  agronomist,
  verifiedTrader,
}

/// User entity - represents a farmer in FarmLink UG
class User extends Equatable {
  final String id;
  final String phone;
  final String? name;
  final String? profilePicture;
  final String? bio;
  final DateTime createdAt;
  final DateTime? lastSignIn;
  final bool isLoggedIn;
  final String? region; // e.g., "Mt. Elgon", "Central Uganda"
  final List<String> interests; // e.g., ["Coffee", "Maize"]
  final VerificationStatus verificationStatus;

  const User({
    required this.id,
    required this.phone,
    this.name,
    this.profilePicture,
    this.bio,
    required this.createdAt,
    this.lastSignIn,
    required this.isLoggedIn,
    this.region,
    this.interests = const [],
    this.verificationStatus = VerificationStatus.unverified,
  });

  /// Copy with modifications
  User copyWith({
    String? id,
    String? phone,
    String? name,
    String? profilePicture,
    String? bio,
    DateTime? createdAt,
    DateTime? lastSignIn,
    bool? isLoggedIn,
    String? region,
    List<String>? interests,
    VerificationStatus? verificationStatus,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      region: region ?? this.region,
      interests: interests ?? this.interests,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phone,
        name,
        profilePicture,
        bio,
        createdAt,
        lastSignIn,
        isLoggedIn,
        region,
        interests,
        verificationStatus,
      ];
}
