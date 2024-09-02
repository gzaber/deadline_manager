import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddEditDeadlineState', () {
    final mockExpirationDate = DateTime.parse('2024-12-06');
    final mockInitialDeadline = Deadline(
      categoryId: '11',
      name: 'name',
      expirationDate: mockExpirationDate,
    );

    AddEditDeadlineState createState({
      AddEditDeadlineStatus status = AddEditDeadlineStatus.initial,
      Deadline? initialDeadline,
      String categoryId = '',
      String name = '',
      required DateTime expirationDate,
    }) {
      return AddEditDeadlineState(
        status: status,
        initialDeadline: initialDeadline,
        categoryId: categoryId,
        name: name,
        expirationDate: expirationDate,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          () => createState(expirationDate: mockExpirationDate),
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createState(expirationDate: mockExpirationDate),
        equals(createState(expirationDate: mockExpirationDate)),
      );
    });

    test('props are correct', () {
      expect(
        createState(expirationDate: mockExpirationDate).props,
        equals([
          AddEditDeadlineStatus.initial,
          null,
          '',
          '',
          mockExpirationDate,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState(expirationDate: mockExpirationDate).copyWith(),
          equals(createState(expirationDate: mockExpirationDate)),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createState(expirationDate: mockExpirationDate).copyWith(
            status: null,
            initialDeadline: null,
            categoryId: null,
            name: null,
            expirationDate: null,
          ),
          equals(createState(expirationDate: mockExpirationDate)),
        );
      });

      test('replaces every non null parameter', () {
        expect(
          createState(expirationDate: mockExpirationDate).copyWith(
            status: AddEditDeadlineStatus.success,
            initialDeadline: mockInitialDeadline,
            categoryId: '11',
            name: 'category',
            expirationDate: mockExpirationDate,
          ),
          equals(createState(
            status: AddEditDeadlineStatus.success,
            initialDeadline: mockInitialDeadline,
            categoryId: '11',
            name: 'category',
            expirationDate: mockExpirationDate,
          )),
        );
      });
    });
  });
}
