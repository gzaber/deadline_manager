import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_permission/add_edit_permission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permissions_repository/permissions_repository.dart';

void main() {
  group('AddEditPermissionState', () {
    final mockInitialPermission = Permission(
      id: '1',
      giver: 'giver',
      receiver: 'receiver',
      categoryIds: const ['11'],
    );
    final mockCategory = Category(
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );
    const mockUser = User(id: '1', email: 'email');

    AddEditPermissionState createState({
      AddEditPermissionStatus status = AddEditPermissionStatus.initial,
      Permission? initialPermission,
      User user = User.empty,
      String receiver = '',
      List<String> categoryIds = const [],
      List<Category> categories = const [],
    }) {
      return AddEditPermissionState(
        status: status,
        initialPermission: initialPermission,
        user: user,
        receiver: receiver,
        categoryIds: categoryIds,
        categories: categories,
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
        equals([AddEditPermissionStatus.initial, null, User.empty, '', [], []]),
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
            status: null,
            initialPermission: null,
            user: null,
            receiver: null,
            categoryIds: null,
            categories: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non null parameter', () {
        expect(
          createState().copyWith(
            status: AddEditPermissionStatus.success,
            initialPermission: mockInitialPermission,
            user: mockUser,
            receiver: 'receiver',
            categoryIds: ['11'],
            categories: [mockCategory],
          ),
          equals(
            createState(
              status: AddEditPermissionStatus.success,
              initialPermission: mockInitialPermission,
              user: mockUser,
              receiver: 'receiver',
              categoryIds: ['11'],
              categories: [mockCategory],
            ),
          ),
        );
      });
    });
  });
}
