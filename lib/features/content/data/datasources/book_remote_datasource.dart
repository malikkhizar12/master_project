import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';

abstract class BookRemoteDataSource {
  Future<List<Book>> getBooks({
    String? category,
    String? search,
  });
  Future<Book> getBookById(String id);
  Future<List<Book>> getRecommendedBooks();
  Future<List<Book>> getReadingBooks();
  Future<void> startReading(String bookId);
}

class ApiBookRemoteDataSource implements BookRemoteDataSource {
  final ApiClient apiClient;

  ApiBookRemoteDataSource(this.apiClient);

  @override
  Future<List<Book>> getBooks({
    String? category,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'All') {
        queryParams[ApiConstants.category] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams[ApiConstants.search] = search;
      }

      final response = await apiClient.get(
        ApiConstants.books,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final List<dynamic> booksJson = response['data'] ?? response['books'] ?? [];
      return booksJson.map((json) => _bookFromJson(json)).toList();
    } catch (e) {
      throw Failure('Failed to fetch books: ${e.toString()}');
    }
  }

  @override
  Future<Book> getBookById(String id) async {
    try {
      final response = await apiClient.get('${ApiConstants.books}/$id');
      final bookJson = response['data'] ?? response;
      return _bookFromJson(bookJson);
    } catch (e) {
      throw Failure('Failed to fetch book: ${e.toString()}');
    }
  }

  @override
  Future<List<Book>> getRecommendedBooks() async {
    try {
      final response = await apiClient.get('${ApiConstants.recommendations}/books');
      final List<dynamic> booksJson = response['data'] ?? response['books'] ?? [];
      return booksJson.map((json) => _bookFromJson(json)).toList();
    } catch (e) {
      throw Failure('Failed to fetch recommended books: ${e.toString()}');
    }
  }

  @override
  Future<List<Book>> getReadingBooks() async {
    try {
      final response = await apiClient.get('${ApiConstants.books}/reading');
      final List<dynamic> booksJson = response['data'] ?? response['books'] ?? [];
      return booksJson.map((json) => _bookFromJson(json)).toList();
    } catch (e) {
      throw Failure('Failed to fetch reading books: ${e.toString()}');
    }
  }

  @override
  Future<void> startReading(String bookId) async {
    try {
      await apiClient.post(
        '${ApiConstants.books}/$bookId${ApiConstants.startReading}',
        body: {'bookId': bookId},
      );
    } catch (e) {
      throw Failure('Failed to start reading: ${e.toString()}');
    }
  }

  Book _bookFromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      pageCount: json['pageCount'] ?? json['page_count'] ?? 0,
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      category: json['category'] ?? '',
      language: json['language'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      isFree: json['isFree'] ?? json['is_free'] ?? false,
      isReading: json['isReading'] ?? json['is_reading'] ?? false,
      progress: json['progress'] != null ? (json['progress'] as num).toDouble() : 0.0,
      publishedYear: json['publishedYear'] ?? json['published_year'],
    );
  }
}





