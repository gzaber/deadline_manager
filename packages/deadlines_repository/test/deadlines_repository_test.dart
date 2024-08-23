import 'package:deadlines_api/deadlines_api.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDeadlinesApi extends Mock implements DeadlinesApi {}

class FakeDeadline extends Fake implements Deadline {}

void main() {
  group('DeadlinesRepository', () {
    late DeadlinesApi api;
    late DeadlinesRepository repository;

    final deadline1 = Deadline(
      id: '1',
      categoryId: '11',
      name: 'name1',
      expirationDate: DateTime.parse('2024-12-06'),
    );
    final deadline2 = Deadline(
      id: '2',
      categoryId: '11',
      name: 'name2',
      expirationDate: DateTime.parse('2024-12-07'),
    );
    final deadline3 = Deadline(
      id: '3',
      categoryId: '12',
      name: 'name2',
      expirationDate: DateTime.parse('2024-12-08'),
    );

    setUpAll(() {
      registerFallbackValue(FakeDeadline());
    });

    setUp(() {
      api = MockDeadlinesApi();
      repository = DeadlinesRepository(deadlinesApi: api);

      when(() => api.createDeadline(any())).thenAnswer((_) async {});
      when(() => api.updateDeadline(any())).thenAnswer((_) async {});
      when(() => api.deleteDeadline(any())).thenAnswer((_) async {});
      when(() => api.readDeadlinesByCategoryId(any()))
          .thenAnswer((_) async => [deadline1, deadline2]);
      when(() => api.readDeadlinesByCategoryIds(any()))
          .thenAnswer((_) async => [deadline1, deadline2, deadline3]);
      when(() => api.observeDeadlinesByCategoryId(any()))
          .thenAnswer((_) => Stream.value([deadline1, deadline2]));
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => DeadlinesRepository(deadlinesApi: api),
          returnsNormally,
        );
      });
    });

    group('createDeadline', () {
      test('makes correct api request', () {
        final deadline = Deadline(
          categoryId: '1',
          name: 'name',
          expirationDate: DateTime.parse('2024-12-06'),
        );

        expect(repository.createDeadline(deadline), completes);
        verify(() => api.createDeadline(deadline)).called(1);
      });
    });

    group('updateDeadline', () {
      test('makes correct api request', () {
        expect(repository.updateDeadline(deadline1), completes);
        verify(() => api.updateDeadline(deadline1)).called(1);
      });
    });

    group('deleteDeadline', () {
      test('makes correct api request', () {
        expect(repository.deleteDeadline(deadline1.id), completes);
        verify(() => api.deleteDeadline(deadline1.id)).called(1);
      });
    });

    group('readDeadlinesByCategoryId', () {
      test('makes correct api request', () {
        expect(repository.readDeadlinesByCategoryId(deadline1.categoryId),
            completes);
        verify(() => api.readDeadlinesByCategoryId(deadline1.categoryId))
            .called(1);
      });

      test('returns deadline list by category id', () async {
        expect(
          await repository.readDeadlinesByCategoryId(deadline1.categoryId),
          equals([deadline1, deadline2]),
        );
      });
    });

    group('readDeadlinesByCategoryIds', () {
      test('makes correct api request', () {
        expect(
          repository.readDeadlinesByCategoryIds(
            [deadline1.categoryId, deadline3.categoryId],
          ),
          completes,
        );
        verify(() => api.readDeadlinesByCategoryIds(
            [deadline1.categoryId, deadline3.categoryId])).called(1);
      });

      test('returns deadline list by category id list', () async {
        expect(
          await repository.readDeadlinesByCategoryIds(
              [deadline1.categoryId, deadline3.categoryId]),
          equals([deadline1, deadline2, deadline3]),
        );
      });
    });

    group('observeDeadlinesByCategoryId', () {
      test('makes correct api request', () {
        expect(
          repository.observeDeadlinesByCategoryId(deadline1.categoryId),
          isNot(throwsA(anything)),
        );
        verify(() => api.observeDeadlinesByCategoryId(deadline1.categoryId))
            .called(1);
      });

      test('returns stream of deadline list by category id', () {
        expect(
          repository.observeDeadlinesByCategoryId(deadline1.categoryId),
          emits([deadline1, deadline2]),
        );
      });
    });
  });
}
