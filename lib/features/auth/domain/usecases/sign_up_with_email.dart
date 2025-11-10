import 'package:focus/features/auth/domain/entities/auth_user.dart';
import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailParams {
  SignUpWithEmailParams({
    required this.email,
    required this.password,
    this.displayName,
  });

  final String email;
  final String password;
  final String? displayName;
}

class SignUpWithEmail {
  SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call(SignUpWithEmailParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}



