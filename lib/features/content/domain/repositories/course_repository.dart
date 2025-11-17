import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses({
    String? category,
    String? level,
    String? search,
  });
  Future<Course> getCourseById(String id);
  Future<List<Course>> getRecommendedCourses();
  Future<List<Course>> getEnrolledCourses();
  Future<void> enrollInCourse(String courseId);
}





