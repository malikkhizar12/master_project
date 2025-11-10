import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:focus/core/error/failure.dart';
import 'package:focus/core/validators/email.dart';
import 'package:focus/core/validators/password.dart';
import 'package:focus/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:formz/formz.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required SignUpWithEmail signUpWithEmail,
  })  : _signUpWithEmail = signUpWithEmail,
        super(const SignUpState());

  final SignUpWithEmail _signUpWithEmail;

  void nameChanged(String value) {
    emit(state.copyWith(
      displayName: value.trim(),
      status: FormzSubmissionStatus.initial,
      errorMessage: null,
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
      errorMessage: null,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: FormzSubmissionStatus.initial,
      errorMessage: null,
    ));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(
      confirmPassword: value,
      status: FormzSubmissionStatus.initial,
      errorMessage: null,
    ));
  }

  Future<void> submit() async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final passwordsMatch = password.value == state.confirmPassword;
    final isValid = email.isValid && password.isValid;

    emit(state.copyWith(email: email, password: password));

    if (!isValid || !passwordsMatch) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: passwordsMatch
              ? null
              : 'Passwords do not match. Please re-enter.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _signUpWithEmail(
        SignUpWithEmailParams(
          email: email.value,
          password: password.value,
          displayName: state.displayName,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on Failure catch (error) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: error.message,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}


