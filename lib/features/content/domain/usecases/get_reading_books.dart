import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetReadingBooks {
  final BookRepository repository;

  GetReadingBooks(this.repository);

  Future<List<Book>> call() async {
    return await repository.getReadingBooks();
  }
}





