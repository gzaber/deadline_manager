import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SummaryDeadline', () {
    const dateString = '2024-12-06';

    SummaryDeadline createModel({
      String name = 'name',
      String expirationDateString = dateString,
      bool isShared = false,
      String categoryName = 'category-name',
      int categoryIcon = 100,
      String sharedBy = 'giver',
    }) {
      return SummaryDeadline(
        name: name,
        expirationDate: DateTime.parse(expirationDateString),
        isShared: isShared,
        categoryName: categoryName,
        sharedBy: sharedBy,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createModel, returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(createModel(), equals(createModel()));
    });

    test('props are correct', () {
      expect(
        createModel().props,
        equals([
          'name',
          DateTime.parse(dateString),
          false,
          'category-name',
          'giver',
        ]),
      );
    });

    group('toDeadline', () {
      test('returns Deadline instance', () {
        expect(
          createModel().toDeadline(),
          equals(
            Deadline(
              id: '',
              categoryId: '',
              name: 'name',
              expirationDate: DateTime.parse(dateString),
            ),
          ),
        );
      });
    });
  });
}
