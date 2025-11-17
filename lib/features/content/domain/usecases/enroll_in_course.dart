import '../repositories/course_repository.dart';

class EnrollInCourse {
  final CourseRepository repository;

  EnrollInCourse(this.repository);

  Future<void> call(String courseId) async {
    return await repository.enrollInCourse(courseId);
  }
}





