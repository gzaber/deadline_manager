import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/cubit/add_edit_category_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddEditCategoryState', () {
    final mockInitialCategory = Category(
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );
    const mockUser = User(id: '1', email: 'email');

    AddEditCategoryState createState({
      AddEditCategoryStatus status = AddEditCategoryStatus.initial,
      Category? initialCategory,
      User user = User.empty,
      String name = 'name',
      int icon = 100,
      int color = 200,
    }) {
      return AddEditCategoryState(
        status: status,
        initialCategory: initialCategory,
        user: user,
        name: name,
        icon: icon,
        color: color,
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
          AddEditCategoryStatus.initial,
          null,
          User.empty,
          'name',
          100,
          200
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
            status: null,
            initialCategory: null,
            user: null,
            name: null,
            icon: null,
            color: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non null parameter', () {
        expect(
          createState().copyWith(
            status: AddEditCategoryStatus.success,
            initialCategory: mockInitialCategory,
            user: mockUser,
            name: 'new name',
            icon: 500,
            color: 600,
          ),
          equals(createState(
            status: AddEditCategoryStatus.success,
            initialCategory: mockInitialCategory,
            user: mockUser,
            name: 'new name',
            icon: 500,
            color: 600,
          )),
        );
      });
    });
  });
}
