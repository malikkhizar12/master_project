import '../entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();

  Future<AuthUser?> getCurrentUser();

  Future<AuthUser> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}



