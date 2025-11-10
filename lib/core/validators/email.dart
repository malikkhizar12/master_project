import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final _regex = RegExp(
    r"^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$",
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    if (!_regex.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}



