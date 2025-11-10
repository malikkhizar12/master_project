import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/di/service_locator.dart';
import 'package:focus/features/auth/presentation/cubit/login_cubit.dart';
import 'package:focus/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:focus/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:focus/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:focus/features/auth/presentation/pages/login_page.dart';
import 'package:focus/features/auth/presentation/pages/sign_up_page.dart';
import 'package:focus/features/content/presentation/pages/main_navigation_page.dart';
import 'package:focus/features/content/presentation/pages/course_detail_page.dart';
import 'package:focus/features/content/presentation/pages/book_detail_page.dart';
import 'package:focus/features/content/domain/entities/course.dart';
import 'package:focus/features/content/domain/entities/book.dart';
import 'package:focus/features/profile/domain/entities/user_profile.dart';
import 'package:focus/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:focus/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:focus/core/di/service_locator.dart' as di;

class AppRouter {
  static const loginRoute = '/';
  static const signUpRoute = '/signup';
  static const forgotPasswordRoute = '/forgot-password';
  static const homeRoute = '/home';
  static const courseDetailRoute = '/course-detail';
  static const bookDetailRoute = '/book-detail';
  static const editProfileRoute = '/edit-profile';

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signUpRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SignUpCubit>(
            create: (_) => sl<SignUpCubit>(),
            child: const SignUpPage(),
          ),
          settings: settings,
        );
      case forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ResetPasswordCubit>(
            create: (_) => sl<ResetPasswordCubit>(),
            child: const ForgotPasswordPage(),
          ),
          settings: settings,
        );
      case homeRoute:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationPage(),
          settings: settings,
        );
      case courseDetailRoute:
        final course = settings.arguments as Course;
        return MaterialPageRoute(
          builder: (_) => CourseDetailPage(course: course),
          settings: settings,
        );
      case bookDetailRoute:
        final book = settings.arguments as Book;
        return MaterialPageRoute(
          builder: (_) => BookDetailPage(book: book),
          settings: settings,
        );
      case editProfileRoute:
        final profile = settings.arguments as UserProfile?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProfileCubit>(
            create: (_) => di.sl<ProfileCubit>(),
            child: EditProfilePage(initialProfile: profile),
          ),
          settings: settings,
        );
      case loginRoute:
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<LoginCubit>(
            create: (_) => sl<LoginCubit>(),
            child: const LoginPage(),
          ),
          settings: settings,
        );
    }
  }
}

