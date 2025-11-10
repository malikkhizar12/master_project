import 'package:focus/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> saveProfile(UserProfile profile);
  Future<String> uploadProfilePicture(String userId, String filePath);
  Stream<UserProfile?> watchProfile(String userId);
}

