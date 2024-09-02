import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_permission/add_edit_permission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class FakePermission extends Fake implements Permission {}

void main() {
  group('AddEditPermissionCubit', () {
    late CategoriesRepository categoriesRepository;
    late PermissionsRepository permissionsRepository;

    const mockUser = User(id: '1', email: 'email');
    final mockInitialPermission = Permission(
      id: '1',
      giver: 'giver',
      receiver: 'receiver',
      categoryIds: const ['11', '12'],
    );
    final mockCategory = Category(
      owner: mockUser.email,
      name: 'name',
      icon: 100,
      color: 200,
    );

    setUpAll(() {
      registerFallbackValue(FakePermission());
    });

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      permissionsRepository = MockPermissionsRepository();
    });

    AddEditPermissionCubit createCubit({Permission? initialPermission}) {
      return AddEditPermissionCubit(
        categoriesRepository: categoriesRepository,
        permissionsRepository: permissionsRepository,
        permission: initialPermission,
        user: mockUser,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createCubit, returnsNormally);
      });

      test('has correct initial state when initial permission is not provided',
          () {
        expect(
          createCubit().state,
          equals(const AddEditPermissionState(user: mockUser)),
        );
      });

      test('has correct initial state when initial permission is provided', () {
        expect(
          createCubit(initialPermission: mockInitialPermission).state,
          equals(AddEditPermissionState(
            user: mockUser,
            initialPermission: mockInitialPermission,
            receiver: mockInitialPermission.receiver,
            categoryIds: mockInitialPermission.categoryIds,
          )),
        );
      });
    });

    group('readCategories', () {
      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with success status and categories when successfully read',
        setUp: () {
          when(() => categoriesRepository.readCategoriesByOwner(any()))
              .thenAnswer((_) async => [mockCategory]);
        },
        build: createCubit,
        seed: () => const AddEditPermissionState(),
        act: (cubit) => cubit.readCategories(),
        expect: () => [
          const AddEditPermissionState(status: AddEditPermissionStatus.loading),
          AddEditPermissionState(
            status: AddEditPermissionStatus.success,
            categories: [mockCategory],
          ),
        ],
      );

      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with failure status when reading from repostiory fails',
        setUp: () {
          when(() => categoriesRepository.readCategoriesByOwner(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () => const AddEditPermissionState(),
        act: (cubit) => cubit.readCategories(),
        expect: () => const [
          AddEditPermissionState(status: AddEditPermissionStatus.loading),
          AddEditPermissionState(status: AddEditPermissionStatus.failure),
        ],
      );
    });

    group('onReceiverChanged', () {
      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with changed receiver',
        build: createCubit,
        seed: () => const AddEditPermissionState(),
        act: (cubit) => cubit.onReceiverChanged('receiver-changed'),
        expect: () =>
            [const AddEditPermissionState(receiver: 'receiver-changed')],
      );
    });

    group('onCategoryChanged', () {
      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with added category id',
        build: createCubit,
        seed: () => const AddEditPermissionState(),
        act: (cubit) => cubit.onCategoryChanged(mockCategory.id),
        expect: () => [
          AddEditPermissionState(categoryIds: [mockCategory.id])
        ],
      );

      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with removed category id',
        build: createCubit,
        seed: () => AddEditPermissionState(categoryIds: [mockCategory.id]),
        act: (cubit) => cubit.onCategoryChanged(mockCategory.id),
        expect: () => [const AddEditPermissionState()],
      );
    });

    group('savePermission', () {
      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with saved status when new permission was successfully saved',
        setUp: () {
          when(() => permissionsRepository.createPermission(any()))
              .thenAnswer((_) async {});
        },
        build: createCubit,
        seed: () => const AddEditPermissionState(receiver: 'receiver'),
        act: (cubit) => cubit.savePermission(),
        expect: () => const [
          AddEditPermissionState(
            status: AddEditPermissionStatus.loading,
            receiver: 'receiver',
          ),
          AddEditPermissionState(
            status: AddEditPermissionStatus.saved,
            receiver: 'receiver',
          ),
        ],
      );

      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with failure status when saving new permission fails',
        setUp: () {
          when(() => permissionsRepository.createPermission(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () => const AddEditPermissionState(receiver: 'receiver'),
        act: (cubit) => cubit.savePermission(),
        expect: () => const [
          AddEditPermissionState(
            status: AddEditPermissionStatus.loading,
            receiver: 'receiver',
          ),
          AddEditPermissionState(
            status: AddEditPermissionStatus.failure,
            receiver: 'receiver',
          ),
        ],
      );

      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with saved status when updated permission was successfully saved',
        setUp: () {
          when(() => permissionsRepository.updatePermission(any()))
              .thenAnswer((_) async {});
        },
        build: createCubit,
        seed: () =>
            AddEditPermissionState(initialPermission: mockInitialPermission),
        act: (cubit) => cubit.savePermission(),
        expect: () => [
          AddEditPermissionState(
            status: AddEditPermissionStatus.loading,
            initialPermission: mockInitialPermission,
          ),
          AddEditPermissionState(
            status: AddEditPermissionStatus.saved,
            initialPermission: mockInitialPermission,
          ),
        ],
      );

      blocTest<AddEditPermissionCubit, AddEditPermissionState>(
        'emits state with failure status when saving updated permission fails',
        setUp: () {
          when(() => permissionsRepository.updatePermission(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () =>
            AddEditPermissionState(initialPermission: mockInitialPermission),
        act: (cubit) => cubit.savePermission(),
        expect: () => [
          AddEditPermissionState(
            status: AddEditPermissionStatus.loading,
            initialPermission: mockInitialPermission,
          ),
          AddEditPermissionState(
            status: AddEditPermissionStatus.failure,
            initialPermission: mockInitialPermission,
          ),
        ],
      );
    });
  });
}
