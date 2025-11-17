import '../repositories/progress_repository.dart';

class GetAchievements {
  final ProgressRepository repository;

  GetAchievements(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getAchievements();
  }
}




