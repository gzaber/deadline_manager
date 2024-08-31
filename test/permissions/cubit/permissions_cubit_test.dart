import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

void main() {
  group('PermissionsCubit', () {
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
    final mockPermission = Permission(
      id: '11',
      giver: mockUser.email,
      receiver: 'receiver',
      categoryIds: [mockCategory.id],
    );

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      permissionsRepository = MockPermissionsRepository();

      when(() => permissionsRepository.observePermissionsByGiver(any()))
          .thenAnswer((_) => Stream.value([mockPermission]));
      when(() => categoriesRepository.readCategoriesByOwner(any()))
          .thenAnswer((_) async => [mockCategory]);
    });

    PermissionsCubit createCubit() {
      return PermissionsCubit(
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
          const PermissionsState(user: mockUser),
        );
      });
    });

    group('subscribeToPermissions', () {
      blocTest<PermissionsCubit, PermissionsState>(
        'starts listening to repository observePermissionsByGiver stream',
        build: createCubit,
        act: (cubit) => cubit.subscribeToPermissions(),
        verify: (_) {
          verify(() => permissionsRepository
              .observePermissionsByGiver(mockUser.email)).called(1);
        },
      );

      blocTest<PermissionsCubit, PermissionsState>(
        'emits state with success status and permissions when repository stream emits new permissions',
        build: createCubit,
        act: (cubit) => cubit.subscribeToPermissions(),
        expect: () => [
          const PermissionsState(
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          PermissionsState(
            streamStatus: PermissionsStreamStatus.success,
            user: mockUser,
            permissions: [mockPermission],
          ),
        ],
      );

      blocTest<PermissionsCubit, PermissionsState>(
        'emits state with failure status when repository stream emits error',
        setUp: () {
          when(() => permissionsRepository.observePermissionsByGiver(any()))
              .thenAnswer((_) => Stream.error(Exception('failure')));
        },
        build: createCubit,
        act: (cubit) => cubit.subscribeToPermissions(),
        expect: () => const [
          PermissionsState(
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          PermissionsState(
            streamStatus: PermissionsStreamStatus.failure,
            user: mockUser,
          ),
        ],
      );
    });

    group('readCategories', () {
      blocTest<PermissionsCubit, PermissionsState>(
        'emits state with success status and categories when read successfully',
        build: () => createCubit()..subscribeToPermissions(),
        act: (cubit) => cubit.readCategories(),
        expect: () => [
          const PermissionsState(
            futureStatus: PermissionsFutureStatus.loading,
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          PermissionsState(
            futureStatus: PermissionsFutureStatus.loading,
            streamStatus: PermissionsStreamStatus.success,
            user: mockUser,
            permissions: [mockPermission],
          ),
          PermissionsState(
              futureStatus: PermissionsFutureStatus.success,
              streamStatus: PermissionsStreamStatus.success,
              user: mockUser,
              permissions: [mockPermission],
              categories: [mockCategory]),
        ],
      );

      blocTest<PermissionsCubit, PermissionsState>(
        'emits state with failure status when read categories fails',
        setUp: () {
          when(() => categoriesRepository.readCategoriesByOwner(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => createCubit()..subscribeToPermissions(),
        act: (cubit) => cubit.readCategories(),
        expect: () => [
          const PermissionsState(
            futureStatus: PermissionsFutureStatus.loading,
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          const PermissionsState(
            futureStatus: PermissionsFutureStatus.failure,
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          PermissionsState(
            futureStatus: PermissionsFutureStatus.failure,
            streamStatus: PermissionsStreamStatus.success,
            user: mockUser,
            permissions: [mockPermission],
          )
        ],
      );
    });

    group('deletePermission', () {
      blocTest<PermissionsCubit, PermissionsState>(
        'emits state with success status when permission deleted successfully',
        setUp: () {
          when(() => permissionsRepository.deletePermission(any()))
              .thenAnswer((_) async {});
        },
        build: () => createCubit()..subscribeToPermissions(),
        act: (cubit) => cubit.deletePermission(mockPermission.id),
        expect: () => [
          const PermissionsState(
            futureStatus: PermissionsFutureStatus.loading,
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          PermissionsState(
            futureStatus: PermissionsFutureStatus.loading,
            streamStatus: PermissionsStreamStatus.success,
            user: mockUser,
            permissions: [mockPermission],
          ),
          PermissionsState(
            futureStatus: PermissionsFutureStatus.success,
            streamStatus: PermissionsStreamStatus.success,
            user: mockUser,
            permissions: [mockPermission],
          )
        ],
      );

      blocTest<PermissionsCubit, PermissionsState>(
        'emits state with failure status when delete permission fails',
        setUp: () {
          when(() => permissionsRepository.deletePermission(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => createCubit()..subscribeToPermissions(),
        act: (cubit) => cubit.deletePermission(mockPermission.id),
        expect: () => [
          const PermissionsState(
            futureStatus: PermissionsFutureStatus.loading,
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          const PermissionsState(
            futureStatus: PermissionsFutureStatus.failure,
            streamStatus: PermissionsStreamStatus.loading,
            user: mockUser,
          ),
          PermissionsState(
            futureStatus: PermissionsFutureStatus.failure,
            streamStatus: PermissionsStreamStatus.success,
            user: mockUser,
            permissions: [mockPermission],
          )
        ],
      );
    });

    group('getPermissionCategories', () {
      blocTest<PermissionsCubit, PermissionsState>(
        'returns categories based on permission category ids',
        build: createCubit,
        seed: () => PermissionsState(
            permissions: [mockPermission], categories: [mockCategory]),
        act: (cubit) => cubit.subscribeToPermissions(),
        verify: (cubit) {
          expect(
            cubit.getPermissionCategories(mockPermission),
            equals([mockCategory]),
          );
        },
      );
    });
  });
}
