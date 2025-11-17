import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class FocusApp extends StatelessWidget {
  const FocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Focus',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1), // Indigo-500
            brightness: Brightness.light,
          ).copyWith(
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF8B5CF6),
            tertiary: const Color(0xFFEC4899),
            surface: Colors.white,
            onSurface: const Color(0xFF1F2937),
          ),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        onGenerateRoute: (settings) {
          final route = router.onGenerateRoute(settings);
          return route;
        },
        builder: (context, child) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              // Show loading while checking auth state
              if (state.status == AuthStatus.unknown) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              // If authenticated and on login page, redirect to home
              if (state.status == AuthStatus.authenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final navigator = Navigator.maybeOf(context);
                  if (navigator != null) {
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute == AppRouter.loginRoute ||
                        currentRoute == AppRouter.signUpRoute) {
                      navigator.pushNamedAndRemoveUntil(
                        AppRouter.homeRoute,
                        (_) => false,
                      );
                    }
                  }
                });
              }
              
              // If not authenticated and on protected route, redirect to login
              if (state.status == AuthStatus.unauthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final navigator = Navigator.maybeOf(context);
                  if (navigator != null) {
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute != AppRouter.loginRoute &&
                        currentRoute != AppRouter.signUpRoute &&
                        currentRoute != AppRouter.forgotPasswordRoute) {
                      navigator.pushNamedAndRemoveUntil(
                        AppRouter.loginRoute,
                        (_) => false,
                      );
                    }
                  }
                });
              }
              
              return child ?? const SizedBox();
            },
          );
        },
        initialRoute: AppRouter.loginRoute,
      ),
    );
  }
}
