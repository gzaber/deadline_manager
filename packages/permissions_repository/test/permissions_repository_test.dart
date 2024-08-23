import 'package:mocktail/mocktail.dart';
import 'package:permissions_api/permissions_api.dart';
import 'package:permissions_repository/permissions_repository.dart';
import 'package:test/test.dart';

class MockPermissionsApi extends Mock implements PermissionsApi {}

class FakePermission extends Fake implements Permission {}

void main() {
  group('PermissionsRepository', () {
    late PermissionsApi api;
    late PermissionsRepository repository;

    final permission1 = Permission(
      id: '1',
      giver: 'giver1',
      receiver: 'receiver1',
      categoryIds: ['11', '12'],
    );
    final permission2 = Permission(
      id: '2',
      giver: 'giver2',
      receiver: 'receiver2',
      categoryIds: ['12', '13'],
    );
    final permission3 = Permission(
      id: '3',
      giver: 'giver2',
      receiver: 'receiver1',
      categoryIds: ['14', '15'],
    );

    setUpAll(() {
      registerFallbackValue(FakePermission());
    });

    setUp(() {
      api = MockPermissionsApi();
      repository = PermissionsRepository(permissionsApi: api);

      when(() => api.createPermission(any())).thenAnswer((_) async {});
      when(() => api.updatePermission(any())).thenAnswer((_) async {});
      when(() => api.deletePermission(any())).thenAnswer((_) async {});
      when(() => api.readPermissionsByCategoryId(any()))
          .thenAnswer((_) async => [permission1, permission2]);
      when(() => api.readCategoryIdsByReceiver(any())).thenAnswer((_) async =>
          [...permission1.categoryIds, ...permission3.categoryIds]);
      when(() => api.readPermissionsByGiver(any()))
          .thenAnswer((_) async => [permission2, permission3]);
      when(() => api.observePermissionsByGiver(any()))
          .thenAnswer((_) => Stream.value([permission2, permission3]));
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => PermissionsRepository(permissionsApi: api),
          returnsNormally,
        );
      });
    });

    group('createPermission', () {
      test('makes correct api request', () {
        final permission = Permission(
          giver: 'giver',
          receiver: 'receiver',
          categoryIds: [],
        );

        expect(repository.createPermission(permission), completes);
        verify(() => api.createPermission(permission)).called(1);
      });
    });

    group('updatePermission', () {
      test('makes correct api request', () {
        expect(repository.updatePermission(permission1), completes);
        verify(() => api.updatePermission(permission1)).called(1);
      });
    });

    group('deletePermission', () {
      test('makes correct api request', () {
        expect(repository.deletePermission(permission1.id), completes);
        verify(() => api.deletePermission(permission1.id)).called(1);
      });
    });

    group('readPermissionsByCategoryId', () {
      test('makes correct api request', () {
        expect(repository.readPermissionsByCategoryId('12'), completes);
        verify(() => api.readPermissionsByCategoryId('12')).called(1);
      });

      test('returns permission list by category id', () async {
        expect(
          await repository.readPermissionsByCategoryId('12'),
          equals([permission1, permission2]),
        );
      });
    });

    group('readCategoryIdsByReceiver', () {
      test('makes correct api request', () {
        expect(repository.readCategoryIdsByReceiver(permission1.receiver),
            completes);
        verify(() => api.readCategoryIdsByReceiver(permission1.receiver))
            .called(1);
      });

      test('returns category ids list by receiver', () async {
        expect(
          await repository.readCategoryIdsByReceiver(permission1.receiver),
          equals([...permission1.categoryIds, ...permission3.categoryIds]),
        );
      });
    });

    group('readPermissionsByGiver', () {
      test('makes correct api request', () {
        expect(repository.readPermissionsByGiver(permission1.giver), completes);
        verify(() => api.readPermissionsByGiver(permission1.giver)).called(1);
      });

      test('returns permission list by giver', () async {
        expect(
          await repository.readPermissionsByGiver(permission2.giver),
          equals([permission2, permission3]),
        );
      });
    });

    group('observePermissionsByGiver', () {
      test('makes correct api request', () {
        expect(
          repository.observePermissionsByGiver(permission2.giver),
          isNot(throwsA(anything)),
        );
        verify(() => api.observePermissionsByGiver(permission2.giver))
            .called(1);
      });

      test('returns stream of permission list by giver', () {
        expect(
          repository.observePermissionsByGiver(permission2.giver),
          emits([permission2, permission3]),
        );
      });
    });
  });
}
