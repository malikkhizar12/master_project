import 'package:focus/features/auth/domain/entities/auth_user.dart';
import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  GetCurrentUser(this._repository);

  final AuthRepository _repository;

  Future<AuthUser?> call() {
    return _repository.getCurrentUser();
  }
}



