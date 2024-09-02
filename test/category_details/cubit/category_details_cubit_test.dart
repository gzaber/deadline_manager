import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

void main() {
  group('CategoryDetailsCubit', () {
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;

    final mockCategory = Category(
      id: '1',
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );
    final mockDeadline = Deadline(
      id: '11',
      categoryId: mockCategory.id,
      name: 'name',
      expirationDate: DateTime.parse('2024-12-06'),
    );

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();

      when(() => deadlinesRepository.observeDeadlinesByCategoryId(any()))
          .thenAnswer((_) => Stream.value([mockDeadline]));
      when(() => categoriesRepository.readCategoryById(any()))
          .thenAnswer((_) async => mockCategory);
      when(() => deadlinesRepository.deleteDeadline(any()))
          .thenAnswer((_) async {});
    });

    CategoryDetailsCubit createCubit() {
      return CategoryDetailsCubit(
        categoriesRepository: categoriesRepository,
        deadlinesRepository: deadlinesRepository,
        categoryId: mockCategory.id,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          createCubit().state,
          CategoryDetailsState(),
        );
      });
    });

    group('subscribeToDeadlines', () {
      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'starts listening to repository observeDeadlinesByCategoryId stream',
        build: createCubit,
        act: (cubit) => cubit.subscribeToDeadlines(mockCategory.id),
        verify: (_) {
          verify(() => deadlinesRepository
              .observeDeadlinesByCategoryId(mockCategory.id)).called(1);
        },
      );

      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'emits state with success status and deadlines when repository stream emits new deadlines',
        build: createCubit,
        act: (cubit) => cubit.subscribeToDeadlines(mockCategory.id),
        expect: () => [
          CategoryDetailsState(
              streamStatus: CategoryDetailsStreamStatus.loading),
          CategoryDetailsState(
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
          ),
        ],
      );

      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'emits state with failure status when repository stream emits error',
        setUp: () {
          when(() => deadlinesRepository.observeDeadlinesByCategoryId(any()))
              .thenAnswer((_) => Stream.error(Exception('failure')));
        },
        build: createCubit,
        act: (cubit) => cubit.subscribeToDeadlines(mockCategory.id),
        expect: () => [
          CategoryDetailsState(
              streamStatus: CategoryDetailsStreamStatus.loading),
          CategoryDetailsState(
              streamStatus: CategoryDetailsStreamStatus.failure),
        ],
      );
    });

    group('readCategory', () {
      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'emits state with success status and category when read successfully',
        build: () => createCubit()..subscribeToDeadlines(mockCategory.id),
        act: (cubit) => cubit.readCategory(mockCategory.id),
        expect: () => [
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.loading,
            streamStatus: CategoryDetailsStreamStatus.loading,
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.loading,
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.success,
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
            category: mockCategory,
          ),
        ],
      );

      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'emits state with failure status when read category fails',
        setUp: () {
          when(() => categoriesRepository.readCategoryById(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => createCubit()..subscribeToDeadlines(mockCategory.id),
        act: (cubit) => cubit.readCategory(mockCategory.id),
        expect: () => [
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.loading,
            streamStatus: CategoryDetailsStreamStatus.loading,
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.failure,
            streamStatus: CategoryDetailsStreamStatus.loading,
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.failure,
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
          ),
        ],
      );
    });

    group('deleteDeadline', () {
      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'emits state with success status when deadline successfully deleted',
        build: () => createCubit()..subscribeToDeadlines(mockCategory.id),
        act: (cubit) => cubit.deleteDeadline(mockDeadline.id),
        expect: () => [
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.loading,
            streamStatus: CategoryDetailsStreamStatus.loading,
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.loading,
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.success,
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
          ),
        ],
      );

      blocTest<CategoryDetailsCubit, CategoryDetailsState>(
        'emits state with failure status when delete deadline fails',
        setUp: () {
          when(() => deadlinesRepository.deleteDeadline(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => createCubit()..subscribeToDeadlines(mockCategory.id),
        act: (cubit) => cubit.deleteDeadline(mockDeadline.id),
        expect: () => [
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.loading,
            streamStatus: CategoryDetailsStreamStatus.loading,
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.failure,
            streamStatus: CategoryDetailsStreamStatus.loading,
          ),
          CategoryDetailsState(
            futureStatus: CategoryDetailsFutureStatus.failure,
            streamStatus: CategoryDetailsStreamStatus.success,
            deadlines: [mockDeadline],
          ),
        ],
      );
    });
  });
}
