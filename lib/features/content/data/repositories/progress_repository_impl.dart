import '../../../../core/error/failure.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> getProgress() async {
    try {
      return await remoteDataSource.getProgress();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await remoteDataSource.getStatistics();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCoursesInProgress() async {
    try {
      return await remoteDataSource.getCoursesInProgress();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getBooksInProgress() async {
    try {
      return await remoteDataSource.getBooksInProgress();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAchievements() async {
    try {
      return await remoteDataSource.getAchievements();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }
}





