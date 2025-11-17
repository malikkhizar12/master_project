import '../repositories/progress_repository.dart';

class GetStatistics {
  final ProgressRepository repository;

  GetStatistics(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getStatistics();
  }
}




