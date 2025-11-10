import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/core/validators/email.dart';
import 'package:focus/core/validators/password.dart';
import 'package:focus/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:formz/formz.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create account'),
      ),
      body: SafeArea(
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status != FormzSubmissionStatus.initial,
          listener: (context, state) {
            if (state.status == FormzSubmissionStatus.success) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.homeRoute,
                (_) => false,
              );
            } else if (state.status == FormzSubmissionStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            final theme = Theme.of(context);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Full name (optional)',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: context.read<SignUpCubit>().nameChanged,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_emailFocus),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: switch (state.email.displayError) {
                        null => null,
                        EmailValidationError.empty => 'Email is required',
                        EmailValidationError.invalid =>
                          'Enter a valid email address',
                      },
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: context.read<SignUpCubit>().emailChanged,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    focusNode: _passwordFocus,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'At least 8 characters with a number, '
                          'uppercase and lowercase letter',
                      errorText: switch (state.password.displayError) {
                        null => null,
                        PasswordValidationError.empty =>
                          'Password cannot be empty',
                        PasswordValidationError.tooShort =>
                          'Password must be at least 8 characters',
                        PasswordValidationError.weak =>
                          'Include uppercase, lowercase and number',
                      },
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: context.read<SignUpCubit>().passwordChanged,
                    onSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocus),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    focusNode: _confirmPasswordFocus,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      errorText: state.status == FormzSubmissionStatus.failure &&
                              state.errorMessage
                                  ?.startsWith('Passwords do not match') ==
                                  true
                          ? state.errorMessage
                          : null,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged:
                        context.read<SignUpCubit>().confirmPasswordChanged,
                    onSubmitted: (_) => context.read<SignUpCubit>().submit(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          state.status == FormzSubmissionStatus.inProgress
                              ? null
                              : context.read<SignUpCubit>().submit,
                      child: state.status == FormzSubmissionStatus.inProgress
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Create account'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                      AppRouter.loginRoute,
                      (_) => false,
                    ),
                    child: Text(
                      'Already have an account? Sign in',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

