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

  Future<List<Deadline>> readDeadlinesByCategoryId(String categoryId) =>
      _deadlinesApi.readDeadlinesByCategoryId(categoryId);

  Future<List<Deadline>> readDeadlinesByCategoryIds(List<String> categoryIds) =>
      _deadlinesApi.readDeadlinesByCategoryIds(categoryIds);

  Stream<List<Deadline>> observeDeadlinesByCategoryId(String categoryId) =>
      _deadlinesApi.observeDeadlinesByCategoryId(categoryId);
}
