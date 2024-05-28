import 'models/models.dart';

abstract interface class DeadlinesApi {
  Future<void> createDeadline(Deadline deadline);
  Future<void> updateDeadline(Deadline deadline);
  Future<void> deleteDeadline(String id);
  Future<Deadline> readDeadline(String id);
  Stream<List<Deadline>> observeDeadlinesByCategory(String categoryId);
}
