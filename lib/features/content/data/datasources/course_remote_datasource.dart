import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/course.dart';

abstract class CourseRemoteDataSource {
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

class ApiCourseRemoteDataSource implements CourseRemoteDataSource {
  final ApiClient apiClient;

  ApiCourseRemoteDataSource(this.apiClient);

  @override
  Future<List<Course>> getCourses({
    String? category,
    String? level,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') {
        queryParams[ApiConstants.category] = category;
      }
      if (level != null && level != 'All') {
        queryParams[ApiConstants.level] = level;
      }
      if (search != null && search.isNotEmpty) {
        queryParams[ApiConstants.search] = search;
      }

      final response = await apiClient.get(
        ApiConstants.courses,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final List<dynamic> coursesJson = response['data'] ?? response['courses'] ?? [];
      return coursesJson.map((json) => _courseFromJson(json)).toList();
    } catch (e) {
      throw Failure('Failed to fetch courses: ${e.toString()}');
    }
  }

  @override
  Future<Course> getCourseById(String id) async {
    try {
      final response = await apiClient.get('${ApiConstants.courses}/$id');
      final courseJson = response['data'] ?? response;
      return _courseFromJson(courseJson);
    } catch (e) {
      throw Failure('Failed to fetch course: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getRecommendedCourses() async {
    try {
      final response = await apiClient.get(ApiConstants.recommendationsCourses);
      final List<dynamic> coursesJson = response['data'] ?? response['courses'] ?? [];
      return coursesJson.map((json) => _courseFromJson(json)).toList();
    } catch (e) {
      throw Failure('Failed to fetch recommended courses: ${e.toString()}');
    }
  }

  @override
  Future<List<Course>> getEnrolledCourses() async {
    try {
      final response = await apiClient.get('${ApiConstants.courses}/enrolled');
      final List<dynamic> coursesJson = response['data'] ?? response['courses'] ?? [];
      return coursesJson.map((json) => _courseFromJson(json)).toList();
    } catch (e) {
      throw Failure('Failed to fetch enrolled courses: ${e.toString()}');
    }
  }

  @override
  Future<void> enrollInCourse(String courseId) async {
    try {
      await apiClient.post(
        '${ApiConstants.courses}/$courseId${ApiConstants.enroll}',
        body: {'courseId': courseId},
      );
    } catch (e) {
      throw Failure('Failed to enroll in course: ${e.toString()}');
    }
  }

  Course _courseFromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? '',
      duration: json['duration'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      enrolledCount: json['enrolledCount'] ?? json['enrolled_count'] ?? 0,
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      isFree: json['isFree'] ?? json['is_free'] ?? false,
      isEnrolled: json['isEnrolled'] ?? json['is_enrolled'] ?? false,
      progress: json['progress'] != null ? (json['progress'] as num).toDouble() : 0.0,
    );
  }
}




