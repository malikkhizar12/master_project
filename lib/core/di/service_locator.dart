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
}

