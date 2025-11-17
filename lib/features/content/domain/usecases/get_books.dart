import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooks {
  final BookRepository repository;

  GetBooks(this.repository);

  Future<List<Book>> call({
    String? category,
    String? search,
  }) async {
    return await repository.getBooks(
      category: category,
      search: search,
    );
  }
}





