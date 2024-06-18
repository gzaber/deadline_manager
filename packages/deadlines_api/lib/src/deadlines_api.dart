import 'models/models.dart';

abstract interface class DeadlinesApi {
  Future<void> createDeadline(Deadline deadline);
  Future<void> updateDeadline(Deadline deadline);
  Future<void> deleteDeadline(String id);
  Stream<Deadline> observeDeadlineById(String id);
  Stream<List<Deadline>> observeDeadlinesByCategory(String categoryId);
  Stream<List<Deadline>> observeDeadlinesByCategories(List<String> categoryIds);
}
