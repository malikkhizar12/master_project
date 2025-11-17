import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks({
    String? category,
    String? search,
  });
  Future<Book> getBookById(String id);
  Future<List<Book>> getRecommendedBooks();
  Future<List<Book>> getReadingBooks();
  Future<void> startReading(String bookId);
}





