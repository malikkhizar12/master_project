import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Book>> getBooks({String? category, String? search}) async {
    try {
      return await remoteDataSource.getBooks(
        category: category,
        search: search,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Book> getBookById(String id) async {
    try {
      return await remoteDataSource.getBookById(id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Book>> getRecommendedBooks() async {
    try {
      return await remoteDataSource.getRecommendedBooks();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<Book>> getReadingBooks() async {
    try {
      return await remoteDataSource.getReadingBooks();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> startReading(String bookId) async {
    try {
      return await remoteDataSource.startReading(bookId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Unexpected error: ${e.toString()}');
    }
  }
}
