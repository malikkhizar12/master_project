import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetRecommendedCourses {
  final CourseRepository repository;

  GetRecommendedCourses(this.repository);

  Future<List<Course>> call() async {
    return await repository.getRecommendedCourses();
  }
}





