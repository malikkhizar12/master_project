import '../repositories/progress_repository.dart';

class GetProgress {
  final ProgressRepository repository;

  GetProgress(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getProgress();
  }
}





