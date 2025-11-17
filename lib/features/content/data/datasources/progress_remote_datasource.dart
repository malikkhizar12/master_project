import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/failure.dart';

abstract class ProgressRemoteDataSource {
  Future<Map<String, dynamic>> getProgress();
  Future<Map<String, dynamic>> getStatistics();
  Future<List<Map<String, dynamic>>> getCoursesInProgress();
  Future<List<Map<String, dynamic>>> getBooksInProgress();
  Future<List<Map<String, dynamic>>> getAchievements();
}

class ApiProgressRemoteDataSource implements ProgressRemoteDataSource {
  final ApiClient apiClient;

  ApiProgressRemoteDataSource(this.apiClient);

  @override
  Future<Map<String, dynamic>> getProgress() async {
    try {
      final response = await apiClient.get(ApiConstants.progress);
      return response['data'] ?? response;
    } catch (e) {
      throw Failure('Failed to fetch progress: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await apiClient.get('${ApiConstants.progress}/statistics');
      return response['data'] ?? response;
    } catch (e) {
      throw Failure('Failed to fetch statistics: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCoursesInProgress() async {
    try {
      final response = await apiClient.get('${ApiConstants.progress}/courses');
      final List<dynamic> coursesJson = response['data'] ?? response['courses'] ?? [];
      return coursesJson.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      throw Failure('Failed to fetch courses in progress: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getBooksInProgress() async {
    try {
      final response = await apiClient.get('${ApiConstants.progress}/books');
      final List<dynamic> booksJson = response['data'] ?? response['books'] ?? [];
      return booksJson.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      throw Failure('Failed to fetch books in progress: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAchievements() async {
    try {
      final response = await apiClient.get('${ApiConstants.progress}/achievements');
      final List<dynamic> achievementsJson = response['data'] ?? response['achievements'] ?? [];
      return achievementsJson.map((json) => json as Map<String, dynamic>).toList();
    } catch (e) {
      throw Failure('Failed to fetch achievements: ${e.toString()}');
    }
  }
}





