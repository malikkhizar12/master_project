import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_progress.dart';
import '../../domain/usecases/get_statistics.dart';
import '../../domain/usecases/get_courses_in_progress.dart';
import '../../domain/usecases/get_books_in_progress.dart';
import '../../domain/usecases/get_achievements.dart';
import '../../../../core/error/failure.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final GetProgress getProgress;
  final GetStatistics getStatistics;
  final GetCoursesInProgress getCoursesInProgress;
  final GetBooksInProgress getBooksInProgress;
  final GetAchievements getAchievements;

  ProgressCubit({
    required this.getProgress,
    required this.getStatistics,
    required this.getCoursesInProgress,
    required this.getBooksInProgress,
    required this.getAchievements,
  }) : super(ProgressInitial());

  Future<void> loadProgress() async {
    emit(ProgressLoading());
    try {
      final progress = await getProgress();
      emit(ProgressLoaded(progress: progress));
    } on Failure catch (failure) {
      emit(ProgressError(failure.message));
    } catch (e) {
      emit(ProgressError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadStatistics() async {
    emit(ProgressLoading());
    try {
      final statistics = await getStatistics();
      emit(StatisticsLoaded(statistics: statistics));
    } on Failure catch (failure) {
      emit(ProgressError(failure.message));
    } catch (e) {
      emit(ProgressError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadCoursesInProgress() async {
    emit(ProgressLoading());
    try {
      final courses = await getCoursesInProgress();
      emit(CoursesInProgressLoaded(courses: courses));
    } on Failure catch (failure) {
      emit(ProgressError(failure.message));
    } catch (e) {
      emit(ProgressError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadBooksInProgress() async {
    emit(ProgressLoading());
    try {
      final books = await getBooksInProgress();
      emit(BooksInProgressLoaded(books: books));
    } on Failure catch (failure) {
      emit(ProgressError(failure.message));
    } catch (e) {
      emit(ProgressError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadAchievements() async {
    emit(ProgressLoading());
    try {
      final achievements = await getAchievements();
      emit(AchievementsLoaded(achievements: achievements));
    } on Failure catch (failure) {
      emit(ProgressError(failure.message));
    } catch (e) {
      emit(ProgressError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadAllProgressData() async {
    emit(ProgressLoading());
    try {
      final progress = await getProgress();
      final statistics = await getStatistics();
      final courses = await getCoursesInProgress();
      final books = await getBooksInProgress();
      final achievements = await getAchievements();
      
      emit(ProgressDataLoaded(
        progress: progress,
        statistics: statistics,
        coursesInProgress: courses,
        booksInProgress: books,
        achievements: achievements,
      ));
    } on Failure catch (failure) {
      emit(ProgressError(failure.message));
    } catch (e) {
      emit(ProgressError('Unexpected error: ${e.toString()}'));
    }
  }
}

