import 'package:deadlines_api/deadlines_api.dart';
import 'package:test/test.dart';

void main() {
  group('Deadline', () {
    const dateString = '2024-12-06';
    const newDateString = '2024-12-07';

    Deadline createSubject({
      String? id = '1',
      String categoryId = '11',
      String name = 'name',
      String formattedDate = dateString,
    }) {
      return Deadline(
        id: id,
        categoryId: categoryId,
        name: name,
        expirationDate: DateTime.parse(formattedDate),
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('sets id if not provided', () {
        expect(createSubject(id: null).id, isNotEmpty);
      });
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          '1',
          '11',
          'name',
          DateTime.parse(dateString),
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            id: null,
            categoryId: null,
            name: null,
            expirationDate: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            id: '2',
            categoryId: '22',
            name: 'new name',
            expirationDate: DateTime.parse(newDateString),
          ),
          equals(
            createSubject(
              id: '2',
              categoryId: '22',
              name: 'new name',
              formattedDate: newDateString,
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Deadline.fromJson(<String, dynamic>{
            'id': '1',
            'categoryId': '11',
            'name': 'name',
            'expirationDate': dateString,
          }),
          equals(createSubject()),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'id': '1',
            'categoryId': '11',
            'name': 'name',
            'expirationDate': DateTime.parse(dateString).toIso8601String(),
          }),
        );
      });
    });
  });
}
