import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort, weak }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  static final _uppercase = RegExp(r'[A-Z]');
  static final _lowercase = RegExp(r'[a-z]');
  static final _number = RegExp(r'[0-9]');

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    final hasUpper = _uppercase.hasMatch(value);
    final hasLower = _lowercase.hasMatch(value);
    final hasNumber = _number.hasMatch(value);
    if (!hasUpper || !hasLower || !hasNumber) {
      return PasswordValidationError.weak;
    }
    return null;
  }
}



