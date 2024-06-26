import 'package:deadlines_api/deadlines_api.dart';

class DeadlinesRepository {
  const DeadlinesRepository({
    required DeadlinesApi deadlinesApi,
  }) : _deadlinesApi = deadlinesApi;

  final DeadlinesApi _deadlinesApi;

  Future<void> createDeadline(Deadline deadline) async =>
      await _deadlinesApi.createDeadline(deadline);

  Future<void> updateDeadline(Deadline deadline) async =>
      await _deadlinesApi.updateDeadline(deadline);

  Future<void> deleteDeadline(String id) async =>
      await _deadlinesApi.deleteDeadline(id);

  Stream<Deadline> observeDeadlineById(String id) =>
      _deadlinesApi.observeDeadlineById(id);

  Stream<List<Deadline>> observeDeadlinesByCategory(String categoryId) =>
      _deadlinesApi.observeDeadlinesByCategory(categoryId);

  Stream<List<Deadline>> observeDeadlinesByCategories(
          List<String> categoryIds) =>
      _deadlinesApi.observeDeadlinesByCategories(categoryIds);
}
