import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmail {
  SendPasswordResetEmail(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) {
    return _repository.sendPasswordResetEmail(email);
  }
}



