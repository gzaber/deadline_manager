import 'package:permissions_api/permissions_api.dart';
import 'package:test/test.dart';

void main() {
  group('Permission', () {
    Permission createSubject({
      String? id = '1',
      String giver = 'giver',
      String receiver = 'receiver',
      List<String> categoryIds = const ['11', '12'],
    }) {
      return Permission(
        id: id,
        giver: giver,
        receiver: receiver,
        categoryIds: categoryIds,
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
          'giver',
          'receiver',
          ['11', '12'],
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
            giver: null,
            receiver: null,
            categoryIds: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            id: '2',
            giver: 'new giver',
            receiver: 'new receiver',
            categoryIds: ['21', '22'],
          ),
          equals(
            createSubject(
              id: '2',
              giver: 'new giver',
              receiver: 'new receiver',
              categoryIds: ['21', '22'],
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Permission.fromJson(<String, dynamic>{
            'id': '1',
            'giver': 'giver',
            'receiver': 'receiver',
            'categoryIds': ['11', '12'],
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
            'giver': 'giver',
            'receiver': 'receiver',
            'categoryIds': ['11', '12'],
          }),
        );
      });
    });
  });
}
