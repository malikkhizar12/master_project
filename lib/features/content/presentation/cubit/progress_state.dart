import 'package:equatable/equatable.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final Map<String, dynamic> progress;

  const ProgressLoaded({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class StatisticsLoaded extends ProgressState {
  final Map<String, dynamic> statistics;

  const StatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class CoursesInProgressLoaded extends ProgressState {
  final List<Map<String, dynamic>> courses;

  const CoursesInProgressLoaded({required this.courses});

  @override
  List<Object?> get props => [courses];
}

class BooksInProgressLoaded extends ProgressState {
  final List<Map<String, dynamic>> books;

  const BooksInProgressLoaded({required this.books});

  @override
  List<Object?> get props => [books];
}

class AchievementsLoaded extends ProgressState {
  final List<Map<String, dynamic>> achievements;

  const AchievementsLoaded({required this.achievements});

  @override
  List<Object?> get props => [achievements];
}

class ProgressDataLoaded extends ProgressState {
  final Map<String, dynamic> progress;
  final Map<String, dynamic> statistics;
  final List<Map<String, dynamic>> coursesInProgress;
  final List<Map<String, dynamic>> booksInProgress;
  final List<Map<String, dynamic>> achievements;

  const ProgressDataLoaded({
    required this.progress,
    required this.statistics,
    required this.coursesInProgress,
    required this.booksInProgress,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        progress,
        statistics,
        coursesInProgress,
        booksInProgress,
        achievements,
      ];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}

