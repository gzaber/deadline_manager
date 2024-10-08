import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoriesState', () {
    const mockUser = User(id: '1', email: 'email');
    final mockCategory = Category(
      id: '11',
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );

    CategoriesState createState({
      CategoriesFutureStatus futureStatus = CategoriesFutureStatus.initial,
      CategoriesStreamStatus streamStatus = CategoriesStreamStatus.initial,
      List<Category> categories = const [],
      User user = User.empty,
    }) {
      return CategoriesState(
        futureStatus: futureStatus,
        streamStatus: streamStatus,
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
          CategoriesFutureStatus.initial,
          CategoriesStreamStatus.initial,
          [],
          User.empty
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
            categories: null,
            user: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            futureStatus: CategoriesFutureStatus.success,
            streamStatus: CategoriesStreamStatus.success,
            categories: [mockCategory],
            user: mockUser,
          ),
          equals(
            createState(
              futureStatus: CategoriesFutureStatus.success,
              streamStatus: CategoriesStreamStatus.success,
              categories: [mockCategory],
              user: mockUser,
            ),
          ),
        );
      });
    });
  });
}
