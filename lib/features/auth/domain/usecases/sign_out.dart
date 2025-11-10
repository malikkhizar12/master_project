import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class SignOut {
  SignOut(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.signOut();
  }
}



