import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:focus/core/error/failure.dart';
import 'package:focus/core/validators/email.dart';
import 'package:focus/features/auth/domain/usecases/send_password_reset_email.dart';
import 'package:formz/formz.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({
    required SendPasswordResetEmail sendPasswordResetEmail,
  })  : _sendPasswordResetEmail = sendPasswordResetEmail,
        super(const ResetPasswordState());

  final SendPasswordResetEmail _sendPasswordResetEmail;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
      errorMessage: null,
    ));
  }

  Future<void> submit() async {
    final email = Email.dirty(state.email.value);
    final isValid = email.isValid;

    emit(state.copyWith(email: email));

    if (!isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _sendPasswordResetEmail(email.value);
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


