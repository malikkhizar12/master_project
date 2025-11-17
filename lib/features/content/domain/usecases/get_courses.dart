import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourses {
  final CourseRepository repository;

  GetCourses(this.repository);

  Future<List<Course>> call({
    String? category,
    String? level,
    String? search,
  }) async {
    return await repository.getCourses(
      category: category,
      level: level,
      search: search,
    );
  }
}





