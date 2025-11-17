import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetEnrolledCourses {
  final CourseRepository repository;

  GetEnrolledCourses(this.repository);

  Future<List<Course>> call() async {
    return await repository.getEnrolledCourses();
  }
}





