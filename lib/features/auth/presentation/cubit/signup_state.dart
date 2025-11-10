part of 'signup_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.displayName = '',
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final String displayName;
  final Email email;
  final Password password;
  final String confirmPassword;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  SignUpState copyWith({
    String? displayName,
    Email? email,
    Password? password,
    String? confirmPassword,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        email,
        password,
        confirmPassword,
        status,
        errorMessage,
      ];
}



