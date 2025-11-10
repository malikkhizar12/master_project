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
        onGenerateRoute: router.onGenerateRoute,
        initialRoute: AppRouter.loginRoute,
      ),
    );
  }
}

