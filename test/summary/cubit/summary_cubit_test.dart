import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/summary/summary.dart';

import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

void main() {
  group('SummaryCubit', () {
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;
    late PermissionsRepository permissionsRepository;
    const userDateString = '2024-12-06';
    const sharedDateString = '2024-12-07';
    const mockUser = User(id: '1', email: 'email');
    final mockUserCategory = Category(
      id: '11',
      owner: 'owner',
      name: 'user-category',
      icon: 100,
      color: 200,
    );

    final mockSharedCategory = Category(
      id: '22',
      owner: 'sharing',
      name: 'shared-category',
      icon: 100,
      color: 200,
    );
    final mockUserDeadline = Deadline(
      id: '1',
      categoryId: mockUserCategory.id,
      name: 'user-deadline',
      expirationDate: DateTime.parse(userDateString),
    );
    final mockSharedDeadline = Deadline(
      id: '2',
      categoryId: mockSharedCategory.id,
      name: 'shared-deadline',
      expirationDate: DateTime.parse(sharedDateString),
    );
    final mockUserSummaryDeadline = SummaryDeadline(
      name: mockUserDeadline.name,
      expirationDate: mockUserDeadline.expirationDate,
      isShared: false,
      categoryName: mockUserCategory.name,
      sharedBy: mockUserCategory.owner,
    );
    final mockSharedSummaryDeadline = SummaryDeadline(
      name: mockSharedDeadline.name,
      expirationDate: mockSharedDeadline.expirationDate,
      isShared: true,
      categoryName: mockSharedCategory.name,
      sharedBy: mockSharedCategory.owner,
    );

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();
      permissionsRepository = MockPermissionsRepository();
    });

    SummaryCubit createCubit() {
      return SummaryCubit(
        deadlinesRepository: deadlinesRepository,
        categoriesRepository: categoriesRepository,
        permissionsRepository: permissionsRepository,
        user: mockUser,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          createCubit().state,
          equals(const SummaryState(user: mockUser)),
        );
      });
    });

    group('toggleShowDetails', () {
      blocTest<SummaryCubit, SummaryState>(
        'emits state with switched parameter responsible for showing details',
        build: createCubit,
        act: (cubit) => cubit.toggleShowDetails(),
        expect: () => const [
          SummaryState(user: mockUser, showDetails: true),
        ],
      );
    });

    group('toggleShowShared', () {
      blocTest<SummaryCubit, SummaryState>(
        'emits state with switched parameter responsible for showing shared deadlines',
        build: createCubit,
        act: (cubit) => cubit.toggleShowShared(),
        expect: () => const [
          SummaryState(user: mockUser, showShared: true),
        ],
      );
    });

    group('readDeadlines', () {
      blocTest<SummaryCubit, SummaryState>(
        'emits state with success status and deadlines when successfully read',
        setUp: () {
          when(() => categoriesRepository.readCategoriesByOwner(any()))
              .thenAnswer((_) async => [mockUserCategory]);
          when(() => permissionsRepository.readCategoryIdsByReceiver(any()))
              .thenAnswer((_) async => [mockSharedCategory.id]);
          when(() => categoriesRepository.readCategoryById(any()))
              .thenAnswer((_) async => mockSharedCategory);
          when(() => deadlinesRepository.readDeadlinesByCategoryIds(any()))
              .thenAnswer((_) async => [mockUserDeadline, mockSharedDeadline]);
        },
        build: createCubit,
        act: (cubit) => cubit.readDeadlines(),
        expect: () => [
          const SummaryState(status: SummaryStatus.loading, user: mockUser),
          SummaryState(
            status: SummaryStatus.success,
            user: mockUser,
            userDeadlines: [mockUserSummaryDeadline],
            summaryDeadlines: [
              mockUserSummaryDeadline,
              mockSharedSummaryDeadline
            ],
          ),
        ],
      );

      blocTest<SummaryCubit, SummaryState>(
        'emits state with initial status when there are no categories',
        setUp: () {
          when(() => categoriesRepository.readCategoriesByOwner(any()))
              .thenAnswer((_) async => []);
          when(() => permissionsRepository.readCategoryIdsByReceiver(any()))
              .thenAnswer((_) async => []);
        },
        build: createCubit,
        act: (cubit) => cubit.readDeadlines(),
        expect: () => const [
          SummaryState(status: SummaryStatus.loading, user: mockUser),
          SummaryState(status: SummaryStatus.initial, user: mockUser),
        ],
      );

      blocTest<SummaryCubit, SummaryState>(
        'emits state with failure status when reading from repostiory fails',
        setUp: () {
          when(() => categoriesRepository.readCategoriesByOwner(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        act: (cubit) => cubit.readDeadlines(),
        expect: () => const [
          SummaryState(status: SummaryStatus.loading, user: mockUser),
          SummaryState(status: SummaryStatus.failure, user: mockUser),
        ],
      );
    });
  });
}
