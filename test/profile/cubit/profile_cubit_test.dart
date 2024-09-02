import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

void main() {
  group('ProfileCubit', () {
    late AuthenticationRepository authenticationRepository;
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;
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

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();
      permissionsRepository = MockPermissionsRepository();

      when(() => categoriesRepository.readCategoriesByOwner(any()))
          .thenAnswer((_) async => [mockCategory]);
      when(() => categoriesRepository.deleteCategory(any()))
          .thenAnswer((_) async {});
      when(() => deadlinesRepository.readDeadlinesByCategoryIds(any()))
          .thenAnswer((_) async => [mockDeadline]);
      when(() => deadlinesRepository.deleteDeadline(any()))
          .thenAnswer((_) async {});
      when(() => permissionsRepository.readPermissionsByGiver(any()))
          .thenAnswer((_) async => [mockPermission]);
      when(() => permissionsRepository.deletePermission(any()))
          .thenAnswer((_) async {});
      when(() => authenticationRepository.deleteUser())
          .thenAnswer((_) async {});
      when(() => authenticationRepository.signOut()).thenAnswer((_) async {});
    });

    ProfileCubit createCubit() {
      return ProfileCubit(
        authenticationRepository: authenticationRepository,
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
          const ProfileState(user: mockUser),
        );
      });
    });

    group('deleteUser', () {
      blocTest<ProfileCubit, ProfileState>(
        'emits state with success status when successfully deleted',
        build: createCubit,
        act: (cubit) => cubit.deleteUser(),
        expect: () => const [
          ProfileState(status: ProfileStatus.loading, user: mockUser),
          ProfileState(status: ProfileStatus.success, user: mockUser),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits state with failure status when deletion fails',
        setUp: () {
          when(() => authenticationRepository.deleteUser())
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        act: (cubit) => cubit.deleteUser(),
        expect: () => const [
          ProfileState(status: ProfileStatus.loading, user: mockUser),
          ProfileState(status: ProfileStatus.deleteUserFailure, user: mockUser),
        ],
      );
    });

    group('signOut', () {
      blocTest<ProfileCubit, ProfileState>(
        'calls repository method for sign out',
        build: createCubit,
        act: (cubit) => cubit.signOut(),
        verify: (_) {
          verify(() => authenticationRepository.signOut()).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emit state with failure when sign out fails',
        setUp: () {
          when(() => authenticationRepository.signOut())
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        act: (cubit) => cubit.signOut(),
        expect: () => [
          const ProfileState(
              status: ProfileStatus.signOutFailure, user: mockUser)
        ],
      );
    });
  });
}
