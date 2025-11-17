import '../repositories/book_repository.dart';

class StartReading {
  final BookRepository repository;

  StartReading(this.repository);

  Future<void> call(String bookId) async {
    return await repository.startReading(bookId);
  }
}





