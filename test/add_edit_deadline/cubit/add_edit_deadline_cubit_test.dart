import 'package:bloc_test/bloc_test.dart';
import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class FakeDeadline extends Fake implements Deadline {}

void main() {
  group('AddEditDeadlineCubit', () {
    late DeadlinesRepository deadlinesRepository;
    final mockExpirationDate = DateTime.parse('2024-12-06');
    final mockInitialDeadline = Deadline(
      categoryId: '11',
      name: 'name',
      expirationDate: mockExpirationDate,
    );

    setUpAll(() {
      registerFallbackValue(FakeDeadline());
    });

    setUp(() {
      deadlinesRepository = MockDeadlinesRepository();
    });

    AddEditDeadlineCubit createCubit({
      Deadline? initialDeadline,
      String categoryId = '',
    }) {
      return AddEditDeadlineCubit(
        deadlinesRepository: deadlinesRepository,
        categoryId: categoryId,
        deadline: initialDeadline,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createCubit, returnsNormally);
      });

      test('has correct initial state when initial deadline is not provided',
          () {
        final initialState = createCubit().state;
        expect(
          initialState,
          equals(
            AddEditDeadlineState(expirationDate: initialState.expirationDate),
          ),
        );
      });

      test('has correct initial state when initial deadline is provided', () {
        expect(
          createCubit(initialDeadline: mockInitialDeadline).state,
          equals(
            AddEditDeadlineState(
              initialDeadline: mockInitialDeadline,
              categoryId: mockInitialDeadline.categoryId,
              name: mockInitialDeadline.name,
              expirationDate: mockInitialDeadline.expirationDate,
            ),
          ),
        );
      });
    });

    group('onNameChanged', () {
      blocTest<AddEditDeadlineCubit, AddEditDeadlineState>(
        'emits state with changed name',
        build: () => createCubit(initialDeadline: mockInitialDeadline),
        act: (cubit) => cubit.onNameChanged('changed'),
        expect: () => [
          AddEditDeadlineState(
            initialDeadline: mockInitialDeadline,
            categoryId: mockInitialDeadline.categoryId,
            name: 'changed',
            expirationDate: mockExpirationDate,
          )
        ],
      );
    });

    group('onDateTimeChanged', () {
      blocTest<AddEditDeadlineCubit, AddEditDeadlineState>(
        'emits state with changed expiration date',
        build: () => createCubit(initialDeadline: mockInitialDeadline),
        act: (cubit) => cubit.onDateTimeChanged(DateTime.parse('2024-11-11')),
        expect: () => [
          AddEditDeadlineState(
            initialDeadline: mockInitialDeadline,
            categoryId: mockInitialDeadline.categoryId,
            name: mockInitialDeadline.name,
            expirationDate: DateTime.parse('2024-11-11'),
          )
        ],
      );
    });

    group('saveDeadline', () {
      blocTest<AddEditDeadlineCubit, AddEditDeadlineState>(
        'emits state with success when new deadline was successfully saved',
        setUp: () {
          when(() => deadlinesRepository.createDeadline(any()))
              .thenAnswer((_) async {});
        },
        build: createCubit,
        seed: () => AddEditDeadlineState(
          name: 'new name',
          expirationDate: mockExpirationDate,
        ),
        act: (cubit) => cubit.saveDeadline(),
        expect: () => [
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.loading,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.success,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
        ],
      );

      blocTest<AddEditDeadlineCubit, AddEditDeadlineState>(
        'emits state with failure when saving created deadline to repository fails',
        setUp: () {
          when(() => deadlinesRepository.createDeadline(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () => AddEditDeadlineState(
          name: 'new name',
          expirationDate: mockExpirationDate,
        ),
        act: (cubit) => cubit.saveDeadline(),
        expect: () => [
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.loading,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.failure,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
        ],
      );

      blocTest<AddEditDeadlineCubit, AddEditDeadlineState>(
        'emits state with success when updated deadline was successfully saved',
        setUp: () {
          when(() => deadlinesRepository.updateDeadline(any()))
              .thenAnswer((_) async {});
        },
        build: createCubit,
        seed: () => AddEditDeadlineState(
          initialDeadline: mockInitialDeadline,
          name: 'new name',
          expirationDate: mockExpirationDate,
        ),
        act: (cubit) => cubit.saveDeadline(),
        expect: () => [
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.loading,
            initialDeadline: mockInitialDeadline,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.success,
            initialDeadline: mockInitialDeadline,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
        ],
      );

      blocTest<AddEditDeadlineCubit, AddEditDeadlineState>(
        'emits state with failure when saving updated deadline to repository fails',
        setUp: () {
          when(() => deadlinesRepository.updateDeadline(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () => AddEditDeadlineState(
          initialDeadline: mockInitialDeadline,
          name: 'new name',
          expirationDate: mockExpirationDate,
        ),
        act: (cubit) => cubit.saveDeadline(),
        expect: () => [
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.loading,
            initialDeadline: mockInitialDeadline,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.failure,
            initialDeadline: mockInitialDeadline,
            name: 'new name',
            expirationDate: mockExpirationDate,
          ),
        ],
      );
    });
  });
}
