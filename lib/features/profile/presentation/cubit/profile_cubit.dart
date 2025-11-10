import 'package:bloc/bloc.dart';
import 'package:focus/features/profile/domain/entities/user_profile.dart';
import 'package:focus/features/profile/domain/repositories/profile_repository.dart';
import 'package:focus/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _repository.getProfile(userId);
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    emit(state.copyWith(status: ProfileStatus.saving));
    try {
      await _repository.saveProfile(profile);
      emit(state.copyWith(
        status: ProfileStatus.saved,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<String?> uploadProfilePicture(String userId, String filePath) async {
    try {
      final url = await _repository.uploadProfilePicture(userId, filePath);
      return url;
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
      return null;
    }
  }

  void watchProfile(String userId) {
    _repository.watchProfile(userId).listen((profile) {
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    });
  }
}

