import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:focus/core/error/failure.dart';
import 'package:focus/core/validators/email.dart';
import 'package:focus/core/validators/password.dart';
import 'package:focus/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SignInWithEmail signInWithEmail,
  })  : _signInWithEmail = signInWithEmail,
        super(const LoginState());

  final SignInWithEmail _signInWithEmail;

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

  Future<void> submit() async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final isValid = email.isValid && password.isValid;

    emit(state.copyWith(email: email, password: password));

    if (!isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _signInWithEmail(
        SignInWithEmailParams(
          email: email.value,
          password: password.value,
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


