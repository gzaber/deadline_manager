import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class FakePermission extends Fake implements Permission {}

void main() {
  group('CategoriesCubit', () {
    late DeadlinesRepository deadlinesRepository;
    late CategoriesRepository categoriesRepository;
    late PermissionsRepository permissionsRepository;

    const mockUser = User(id: '1', email: 'email');
    final mockCategory = Category(
      id: '1',
      owner: mockUser.email,
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
    final mockPermission = Permission(
      id: '111',
      giver: mockUser.email,
      receiver: 'receiver',
      categoryIds: [mockCategory.id],
    );

    setUpAll(() {
      registerFallbackValue(FakePermission());
    });

    setUp(() {
      deadlinesRepository = MockDeadlinesRepository();
      categoriesRepository = MockCategoriesRepository();
      permissionsRepository = MockPermissionsRepository();

      when(() => categoriesRepository.observeCategoriesByOwner(any()))
          .thenAnswer((_) => Stream.value([mockCategory]));
      when(() => categoriesRepository.deleteCategory(any()))
          .thenAnswer((_) async {});
      when(() => deadlinesRepository.readDeadlinesByCategoryId(any()))
          .thenAnswer((_) async => [mockDeadline]);
      when(() => deadlinesRepository.deleteDeadline(any()))
          .thenAnswer((_) async {});
      when(() => permissionsRepository.readPermissionsByCategoryId(any()))
          .thenAnswer((_) async => [mockPermission]);
      when(() => permissionsRepository.updatePermission(any()))
          .thenAnswer((_) async {});
    });

    CategoriesCubit createCubit() {
      return CategoriesCubit(
        categoriesRepository: categoriesRepository,
        deadlinesRepository: deadlinesRepository,
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
          const CategoriesState(user: mockUser),
        );
      });
    });

    group('subscribeToCategories', () {
      blocTest<CategoriesCubit, CategoriesState>(
        'starts listening to repository observeCategoriesByOwner stream',
        build: createCubit,
        act: (cubit) => cubit.subscribeToCategories(),
        verify: (_) {
          verify(() =>
                  categoriesRepository.observeCategoriesByOwner(mockUser.email))
              .called(1);
        },
      );

      blocTest<CategoriesCubit, CategoriesState>(
        'emits state with success status and categories when repository stream emits new categories',
        build: createCubit,
        act: (cubit) => cubit.subscribeToCategories(),
        expect: () => [
          const CategoriesState(
              status: CategoriesStatus.loading, user: mockUser),
          CategoriesState(
            status: CategoriesStatus.success,
            user: mockUser,
            categories: [mockCategory],
          ),
        ],
      );

      blocTest<CategoriesCubit, CategoriesState>(
        'emits state with failure status when repository stream emits error',
        setUp: () {
          when(() => categoriesRepository.observeCategoriesByOwner(any()))
              .thenAnswer((_) => Stream.error(Exception('failure')));
        },
        build: createCubit,
        act: (cubit) => cubit.subscribeToCategories(),
        expect: () => const [
          CategoriesState(status: CategoriesStatus.loading, user: mockUser),
          CategoriesState(status: CategoriesStatus.failure, user: mockUser),
        ],
      );
    });

    group('deleteCategory', () {
      blocTest<CategoriesCubit, CategoriesState>(
        'emits state with success status when category successfully deleted',
        build: () => createCubit()..subscribeToCategories(),
        seed: () => CategoriesState(
          status: CategoriesStatus.success,
          user: mockUser,
          categories: [mockCategory],
        ),
        act: (cubit) => cubit.deleteCategory('id'),
        expect: () => [
          CategoriesState(
            status: CategoriesStatus.loading,
            user: mockUser,
            categories: [mockCategory],
          ),
          CategoriesState(
            status: CategoriesStatus.success,
            user: mockUser,
            categories: [mockCategory],
          ),
        ],
      );

      blocTest<CategoriesCubit, CategoriesState>(
        'emits state with failure status when delete category fails',
        setUp: () {
          when(() => categoriesRepository.deleteCategory(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => createCubit()..subscribeToCategories(),
        seed: () => CategoriesState(
          status: CategoriesStatus.success,
          user: mockUser,
          categories: [mockCategory],
        ),
        act: (cubit) => cubit.deleteCategory('id'),
        expect: () => [
          CategoriesState(
            status: CategoriesStatus.loading,
            user: mockUser,
            categories: [mockCategory],
          ),
          CategoriesState(
            status: CategoriesStatus.failure,
            user: mockUser,
            categories: [mockCategory],
          ),
          CategoriesState(
            status: CategoriesStatus.success,
            user: mockUser,
            categories: [mockCategory],
          ),
        ],
      );
    });
  });
}
