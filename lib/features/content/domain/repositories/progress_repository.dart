abstract class ProgressRepository {
  Future<Map<String, dynamic>> getProgress();
  Future<Map<String, dynamic>> getStatistics();
  Future<List<Map<String, dynamic>>> getCoursesInProgress();
  Future<List<Map<String, dynamic>>> getBooksInProgress();
  Future<List<Map<String, dynamic>>> getAchievements();
}





