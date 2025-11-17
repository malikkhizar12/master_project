import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/send_password_reset_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/auth/domain/usecases/watch_auth_state.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password_cubit.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../../features/content/data/datasources/course_remote_datasource.dart';
import '../../features/content/data/datasources/book_remote_datasource.dart';
import '../../features/content/data/datasources/progress_remote_datasource.dart';
import '../../features/content/data/repositories/course_repository_impl.dart';
import '../../features/content/data/repositories/book_repository_impl.dart';
import '../../features/content/data/repositories/progress_repository_impl.dart';
import '../../features/content/domain/repositories/course_repository.dart';
import '../../features/content/domain/repositories/book_repository.dart';
import '../../features/content/domain/repositories/progress_repository.dart';
import '../../features/content/domain/usecases/get_courses.dart';
import '../../features/content/domain/usecases/get_course_by_id.dart';
import '../../features/content/domain/usecases/get_recommended_courses.dart';
import '../../features/content/domain/usecases/get_enrolled_courses.dart';
import '../../features/content/domain/usecases/enroll_in_course.dart';
import '../../features/content/domain/usecases/get_books.dart';
import '../../features/content/domain/usecases/get_book_by_id.dart';
import '../../features/content/domain/usecases/get_recommended_books.dart';
import '../../features/content/domain/usecases/get_reading_books.dart';
import '../../features/content/domain/usecases/start_reading.dart';
import '../../features/content/domain/usecases/get_progress.dart';
import '../../features/content/domain/usecases/get_statistics.dart';
import '../../features/content/domain/usecases/get_courses_in_progress.dart';
import '../../features/content/domain/usecases/get_books_in_progress.dart';
import '../../features/content/domain/usecases/get_achievements.dart';
import '../../features/content/presentation/cubit/course_cubit.dart';
import '../../features/content/presentation/cubit/book_cubit.dart';
import '../../features/content/presentation/cubit/progress_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSource(sl<FirebaseAuth>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<SignInWithEmail>(
    () => SignInWithEmail(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpWithEmail>(
    () => SignUpWithEmail(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendPasswordResetEmail>(
    () => SendPasswordResetEmail(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOut>(
    () => SignOut(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<WatchAuthState>(
    () => WatchAuthState(sl<AuthRepository>()),
  );

  // Cubits
  sl.registerFactory(
    () => LoginCubit(
      signInWithEmail: sl<SignInWithEmail>(),
    ),
  );

  sl.registerFactory(
    () => SignUpCubit(
      signUpWithEmail: sl<SignUpWithEmail>(),
    ),
  );

  sl.registerFactory(
    () => ResetPasswordCubit(
      sendPasswordResetEmail: sl<SendPasswordResetEmail>(),
    ),
  );

  sl.registerLazySingleton(
    () => AuthCubit(
      watchAuthState: sl<WatchAuthState>(),
      signOut: sl<SignOut>(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );

  // Profile dependencies
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => FirebaseProfileRemoteDataSource(
      sl<FirebaseFirestore>(),
      sl<FirebaseStorage>(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  sl.registerFactory(
    () => ProfileCubit(sl<ProfileRepository>()),
  );

  // API Client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: ApiConstants.baseUrl,
      // Add authentication headers if needed
      // headers: {'Authorization': 'Bearer ${token}'},
    ),
  );

  // Content Data Sources
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => ApiCourseRemoteDataSource(sl<ApiClient>()),
  );

  sl.registerLazySingleton<BookRemoteDataSource>(
    () => ApiBookRemoteDataSource(sl<ApiClient>()),
  );

  sl.registerLazySingleton<ProgressRemoteDataSource>(
    () => ApiProgressRemoteDataSource(sl<ApiClient>()),
  );

  // Content Repositories
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(sl<CourseRemoteDataSource>()),
  );

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(sl<BookRemoteDataSource>()),
  );

  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl<ProgressRemoteDataSource>()),
  );

  // Content Use Cases
  sl.registerLazySingleton<GetCourses>(
    () => GetCourses(sl<CourseRepository>()),
  );

  sl.registerLazySingleton<GetCourseById>(
    () => GetCourseById(sl<CourseRepository>()),
  );

  sl.registerLazySingleton<GetRecommendedCourses>(
    () => GetRecommendedCourses(sl<CourseRepository>()),
  );

  sl.registerLazySingleton<GetEnrolledCourses>(
    () => GetEnrolledCourses(sl<CourseRepository>()),
  );

  sl.registerLazySingleton<EnrollInCourse>(
    () => EnrollInCourse(sl<CourseRepository>()),
  );

  sl.registerLazySingleton<GetBooks>(
    () => GetBooks(sl<BookRepository>()),
  );

  sl.registerLazySingleton<GetBookById>(
    () => GetBookById(sl<BookRepository>()),
  );

  sl.registerLazySingleton<GetRecommendedBooks>(
    () => GetRecommendedBooks(sl<BookRepository>()),
  );

  sl.registerLazySingleton<GetReadingBooks>(
    () => GetReadingBooks(sl<BookRepository>()),
  );

  sl.registerLazySingleton<StartReading>(
    () => StartReading(sl<BookRepository>()),
  );

  sl.registerLazySingleton<GetProgress>(
    () => GetProgress(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton<GetStatistics>(
    () => GetStatistics(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton<GetCoursesInProgress>(
    () => GetCoursesInProgress(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton<GetBooksInProgress>(
    () => GetBooksInProgress(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton<GetAchievements>(
    () => GetAchievements(sl<ProgressRepository>()),
  );

  // Content Cubits
  sl.registerFactory(
    () => CourseCubit(
      getCourses: sl<GetCourses>(),
      getCourseById: sl<GetCourseById>(),
      getRecommendedCourses: sl<GetRecommendedCourses>(),
      getEnrolledCourses: sl<GetEnrolledCourses>(),
      enrollInCourse: sl<EnrollInCourse>(),
    ),
  );

  sl.registerFactory(
    () => BookCubit(
      getBooks: sl<GetBooks>(),
      getBookById: sl<GetBookById>(),
      getRecommendedBooks: sl<GetRecommendedBooks>(),
      getReadingBooks: sl<GetReadingBooks>(),
      startReading: sl<StartReading>(),
    ),
  );

  sl.registerFactory(
    () => ProgressCubit(
      getProgress: sl<GetProgress>(),
      getStatistics: sl<GetStatistics>(),
      getCoursesInProgress: sl<GetCoursesInProgress>(),
      getBooksInProgress: sl<GetBooksInProgress>(),
      getAchievements: sl<GetAchievements>(),
    ),
  );
}

