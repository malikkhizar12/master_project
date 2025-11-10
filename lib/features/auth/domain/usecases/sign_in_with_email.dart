import 'package:focus/features/auth/domain/entities/auth_user.dart';
import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailParams {
  SignInWithEmailParams({required this.email, required this.password});

  final String email;
  final String password;
}

class SignInWithEmail {
  SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call(SignInWithEmailParams params) {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}



