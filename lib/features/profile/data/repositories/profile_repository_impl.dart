import 'package:focus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:focus/features/profile/domain/entities/user_profile.dart';
import 'package:focus/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile?> getProfile(String userId) {
    return _remoteDataSource.getProfile(userId);
  }

  @override
  Future<void> saveProfile(UserProfile profile) {
    return _remoteDataSource.saveProfile(profile);
  }

  @override
  Future<String> uploadProfilePicture(String userId, String filePath) {
    return _remoteDataSource.uploadProfilePicture(userId, filePath);
  }

  @override
  Stream<UserProfile?> watchProfile(String userId) {
    return _remoteDataSource.watchProfile(userId);
  }
}

