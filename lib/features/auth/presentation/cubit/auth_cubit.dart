import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:focus/features/auth/domain/entities/auth_user.dart';
import 'package:focus/features/auth/domain/usecases/get_current_user.dart';
import 'package:focus/features/auth/domain/usecases/sign_out.dart';
import 'package:focus/features/auth/domain/usecases/watch_auth_state.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required WatchAuthState watchAuthState,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
  })  : _watchAuthState = watchAuthState,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        super(const AuthState.unknown()) {
    _listenForAuthChanges();
  }

  final WatchAuthState _watchAuthState;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  StreamSubscription<AuthUser?>? _subscription;

  Future<void> _listenForAuthChanges() async {
    _subscription = _watchAuthState().listen(
      (user) {
        if (user == null) {
          emit(const AuthState.unauthenticated());
        } else {
          emit(AuthState.authenticated(user));
        }
      },
      onError: (error, __) => emit(AuthState.failure(error.toString())),
    );

    final currentUser = await _getCurrentUser();
    if (currentUser != null) {
      emit(AuthState.authenticated(currentUser));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> logout() async {
    try {
      await _signOut();
      emit(const AuthState.unauthenticated());
    } catch (error) {
      emit(AuthState.failure(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}



