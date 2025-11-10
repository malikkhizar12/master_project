import 'package:firebase_auth/firebase_auth.dart';

import 'package:focus/core/error/failure.dart';
import 'package:focus/features/auth/domain/entities/auth_user.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUser?> authStateChanges();

  Future<AuthUser?> currentUser();

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> sendPasswordReset(String email);

  Future<void> signOut();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<AuthUser?> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapUser(user) : null;
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Failure('User not found after sign in');
      }
      return _mapUser(user)!;
    } on FirebaseAuthException catch (error) {
      throw Failure(error.message ?? 'Unable to sign in', code: error.code);
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Failure('User not found after sign up');
      }
      
      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
        // Reload user to get updated profile
        await user.reload();
        // Get the updated user
        final updatedUser = _firebaseAuth.currentUser;
        if (updatedUser != null) {
          return _mapUser(updatedUser)!;
        }
      }
      
      return _mapUser(user)!;
    } on FirebaseAuthException catch (error) {
      throw Failure(error.message ?? 'Unable to sign up', code: error.code);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw Failure(
        error.message ?? 'Unable to send reset email',
        code: error.code,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}

