import 'package:focus/features/auth/domain/entities/auth_user.dart';
import 'package:focus/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthState {
  WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AuthUser?> call() {
    return _repository.authStateChanges();
  }
}



