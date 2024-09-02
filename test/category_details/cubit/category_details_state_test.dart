import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryDetailsState', () {
    final mockCategory = Category(
      id: '1',
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );
    final mockEmptyCategory = Category(
      id: '0',
      owner: '',
      name: '',
      icon: 0,
      color: 0,
    );
    final mockDeadline = Deadline(
      id: '11',
      categoryId: mockCategory.id,
      name: 'name',
      expirationDate: DateTime.parse('2024-12-06'),
    );

    CategoryDetailsState createState({
      CategoryDetailsFutureStatus futureStatus =
          CategoryDetailsFutureStatus.initial,
      CategoryDetailsStreamStatus streamStatus =
          CategoryDetailsStreamStatus.initial,
      Category? category,
      List<Deadline> deadlines = const [],
    }) {
      return CategoryDetailsState(
        futureStatus: futureStatus,
        streamStatus: streamStatus,
        category: category ?? mockEmptyCategory,
        deadlines: deadlines,
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
          CategoryDetailsFutureStatus.initial,
          CategoryDetailsStreamStatus.initial,
          mockEmptyCategory,
          []
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
            category: null,
            deadlines: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            futureStatus: CategoryDetailsFutureStatus.success,
            streamStatus: CategoryDetailsStreamStatus.success,
            category: mockCategory,
            deadlines: [mockDeadline],
          ),
          equals(
            createState(
              futureStatus: CategoryDetailsFutureStatus.success,
              streamStatus: CategoryDetailsStreamStatus.success,
              category: mockCategory,
              deadlines: [mockDeadline],
            ),
          ),
        );
      });
    });
  });
}
