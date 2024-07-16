import 'models/models.dart';

abstract interface class DeadlinesApi {
  Future<void> createDeadline(Deadline deadline);
  Future<void> updateDeadline(Deadline deadline);
  Future<void> deleteDeadline(String id);
  Future<List<Deadline>> readDeadlinesByCategoryId(String categoryId);
  Future<List<Deadline>> readDeadlinesByCategoryIds(List<String> categoryIds);
  Stream<List<Deadline>> observeDeadlinesByCategoryId(String categoryId);
}
