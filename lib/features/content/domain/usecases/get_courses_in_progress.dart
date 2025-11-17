import '../repositories/progress_repository.dart';

class GetCoursesInProgress {
  final ProgressRepository repository;

  GetCoursesInProgress(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getCoursesInProgress();
  }
}




