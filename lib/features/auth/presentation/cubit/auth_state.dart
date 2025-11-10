part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(AuthUser user)
      : this._(status: AuthStatus.authenticated, user: user);
  const AuthState.failure(String message)
      : this._(status: AuthStatus.failure, errorMessage: message);

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];
}

enum AuthStatus { unknown, authenticated, unauthenticated, failure }



