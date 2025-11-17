import '../repositories/progress_repository.dart';

class GetBooksInProgress {
  final ProgressRepository repository;

  GetBooksInProgress(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getBooksInProgress();
  }
}




