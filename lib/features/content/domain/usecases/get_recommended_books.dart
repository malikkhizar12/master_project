import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetRecommendedBooks {
  final BookRepository repository;

  GetRecommendedBooks(this.repository);

  Future<List<Book>> call() async {
    return await repository.getRecommendedBooks();
  }
}





