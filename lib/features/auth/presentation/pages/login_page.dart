import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/core/validators/email.dart';
import 'package:focus/core/validators/password.dart';
import 'package:focus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:focus/features/auth/presentation/cubit/login_cubit.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == AuthStatus.authenticated,
          listener: (context, state) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.homeRoute,
              (_) => false,
            );
          },
          child: BlocConsumer<LoginCubit, LoginState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status != FormzSubmissionStatus.initial,
            listener: (context, state) {
              if (state.status == FormzSubmissionStatus.failure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
            builder: (context, state) {
              final theme = Theme.of(context);

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in with your email and password',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      onChanged: context.read<LoginCubit>().emailChanged,
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
                      onSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocusNode),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      focusNode: _passwordFocusNode,
                      onChanged: context.read<LoginCubit>().passwordChanged,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => context.read<LoginCubit>().submit(),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.forgotPasswordRoute,
                          );
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state.status ==
                                FormzSubmissionStatus.inProgress
                            ? null
                            : context.read<LoginCubit>().submit,
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
                            : const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRouter.signUpRoute);
                          },
                          child: const Text('Create one'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

