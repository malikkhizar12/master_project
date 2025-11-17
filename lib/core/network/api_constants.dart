class ApiConstants {
  // Base URL - Local backend for development
  // For web: use http://127.0.0.1:8000 or http://localhost:8000
  // For mobile: use http://10.0.2.2:8000 (Android emulator) or http://localhost:8000 (iOS simulator)
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Endpoints
  static const String courses = '/courses';
  static const String books = '/books';
  static const String progress = '/progress';
  static const String recommendations = '/recommendations';
  static const String recommendationsCourses = '/recommendations/courses';
  static const String recommendationsBooks = '/recommendations/books';
  static const String enroll = '/enroll';
  static const String startReading = '/start-reading';
  static const String updateProgress = '/update-progress';

  // Query parameters
  static const String category = 'category';
  static const String level = 'level';
  static const String search = 'search';
  static const String limit = 'limit';
  static const String offset = 'offset';
}
