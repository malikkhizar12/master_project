import 'package:focus/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:focus/features/auth/domain/entities/auth_user.dart';
import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }

  @override
  Future<AuthUser?> getCurrentUser() {
    return _remoteDataSource.currentUser();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _remoteDataSource.sendPasswordReset(email);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _remoteDataSource.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}

