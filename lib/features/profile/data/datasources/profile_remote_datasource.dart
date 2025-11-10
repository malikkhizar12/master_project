import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:focus/core/error/failure.dart';
import 'package:focus/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile?> getProfile(String userId);
  Future<void> saveProfile(UserProfile profile);
  Future<String> uploadProfilePicture(String userId, String filePath);
  Stream<UserProfile?> watchProfile(String userId);
}

class FirebaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  FirebaseProfileRemoteDataSource(
    this._firestore,
    this._storage,
  );

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  static const String _collection = 'user_profiles';

  @override
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (!doc.exists) {
        return null;
      }
      return _mapDocument(doc);
    } catch (e) {
      throw Failure('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    try {
      final now = DateTime.now();
      final profileData = {
        'userId': profile.userId,
        'email': profile.email,
        'fullName': profile.fullName,
        'university': profile.university,
        'educationalDetails': profile.educationalDetails,
        'interests': profile.interests,
        'profilePictureUrl': profile.profilePictureUrl,
        'updatedAt': now.toIso8601String(),
        if (profile.createdAt == null) 'createdAt': now.toIso8601String(),
      };

      await _firestore
          .collection(_collection)
          .doc(profile.userId)
          .set(profileData, SetOptions(merge: true));
    } catch (e) {
      throw Failure('Failed to save profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture(String userId, String filePath) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      throw Failure('Failed to upload picture: ${e.toString()}');
    }
  }

  @override
  Stream<UserProfile?> watchProfile(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? _mapDocument(doc) : null);
  }

  UserProfile _mapDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      userId: data['userId'] as String,
      email: data['email'] as String,
      fullName: data['fullName'] as String?,
      university: data['university'] as String?,
      educationalDetails: data['educationalDetails'] as String?,
      interests: List<String>.from(data['interests'] ?? []),
      profilePictureUrl: data['profilePictureUrl'] as String?,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : null,
    );
  }
}

