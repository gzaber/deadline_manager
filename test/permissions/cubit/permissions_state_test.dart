import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permissions_repository/permissions_repository.dart';

void main() {
  group('PermissionsState', () {
    const mockUser = User(id: '1', email: 'email');
    final mockCategory = Category(
      id: '11',
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );
    final mockPermission = Permission(
      id: '111',
      giver: 'giver',
      receiver: 'receiver',
      categoryIds: [mockCategory.id],
    );

    PermissionsState createState({
      PermissionsFutureStatus futureStatus = PermissionsFutureStatus.initial,
      PermissionsStreamStatus streamStatus = PermissionsStreamStatus.initial,
      List<Permission> permissions = const [],
      List<Category> categories = const [],
      User user = User.empty,
    }) {
      return PermissionsState(
        futureStatus: futureStatus,
        streamStatus: streamStatus,
        permissions: permissions,
        categories: categories,
        user: user,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createState, returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([
          PermissionsFutureStatus.initial,
          PermissionsStreamStatus.initial,
          [],
          [],
          User.empty,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createState().copyWith(
            futureStatus: null,
            streamStatus: null,
            permissions: null,
            categories: null,
            user: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            futureStatus: PermissionsFutureStatus.success,
            streamStatus: PermissionsStreamStatus.success,
            permissions: [mockPermission],
            categories: [mockCategory],
            user: mockUser,
          ),
          equals(
            createState(
              futureStatus: PermissionsFutureStatus.success,
              streamStatus: PermissionsStreamStatus.success,
              permissions: [mockPermission],
              categories: [mockCategory],
              user: mockUser,
            ),
          ),
        );
      });
    });
  });
}
