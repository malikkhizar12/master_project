import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.email,
    this.fullName,
    this.university,
    this.educationalDetails,
    this.interests = const [],
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String userId;
  final String email;
  final String? fullName;
  final String? university;
  final String? educationalDetails;
  final List<String> interests;
  final String? profilePictureUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? userId,
    String? email,
    String? fullName,
    String? university,
    String? educationalDetails,
    List<String>? interests,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      university: university ?? this.university,
      educationalDetails: educationalDetails ?? this.educationalDetails,
      interests: interests ?? this.interests,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        fullName,
        university,
        educationalDetails,
        interests,
        profilePictureUrl,
        createdAt,
        updatedAt,
      ];
}

