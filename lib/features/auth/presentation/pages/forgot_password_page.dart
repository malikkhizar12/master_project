import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/core/validators/email.dart';
import 'package:focus/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:formz/formz.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
      ),
      body: SafeArea(
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status != FormzSubmissionStatus.initial,
          listener: (context, state) {
            if (state.status == FormzSubmissionStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password reset email sent. Check your inbox.',
                  ),
                ),
              );
            } else if (state.status == FormzSubmissionStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter the email associated with your account and we will send you a link to reset your password.',
                  ),
                  const SizedBox(height: 24),
                  TextField(
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
                    onChanged:
                        context.read<ResetPasswordCubit>().emailChanged,
                    onSubmitted: (_) =>
                        context.read<ResetPasswordCubit>().submit(),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: state.status ==
                            FormzSubmissionStatus.inProgress
                        ? null
                        : context.read<ResetPasswordCubit>().submit,
                    child: state.status ==
                            FormzSubmissionStatus.inProgress
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Send reset link'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                      AppRouter.loginRoute,
                      (_) => false,
                    ),
                    child: const Text('Back to sign in'),
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

