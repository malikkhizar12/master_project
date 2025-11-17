import '../../../../core/error/failure.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Course>> getCourses({
    String? category,
    String? level,
    String? search,
  }) async {
    try {
      return await remoteDataSource.getCourses(
        category: category,
        level: level,
        search: search,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Course> getCourseById(String id) async {
    try {
      return await remoteDataSource.getCourseById(id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getRecommendedCourses() async {
    try {
      return await remoteDataSource.getRecommendedCourses();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getEnrolledCourses() async {
    try {
      return await remoteDataSource.getEnrolledCourses();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> enrollInCourse(String courseId) async {
    try {
      return await remoteDataSource.enrollInCourse(courseId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }
}





