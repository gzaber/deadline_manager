import 'package:categories_api/categories_api.dart';
import 'package:test/test.dart';

void main() {
  group('Category', () {
    Category createSubject({
      String? id = '1',
      String owner = 'owner@mail.com',
      String name = 'name',
      icon = 100,
      color = 200,
    }) {
      return Category(
        id: id,
        owner: owner,
        name: name,
        icon: icon,
        color: color,
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
          'owner@mail.com',
          'name',
          100,
          200,
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
            owner: null,
            name: null,
            icon: null,
            color: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            id: '2',
            owner: 'newowner@mail.com',
            name: 'new name',
            icon: 1100,
            color: 1200,
          ),
          equals(
            createSubject(
              id: '2',
              owner: 'newowner@mail.com',
              name: 'new name',
              icon: 1100,
              color: 1200,
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Category.fromJson(<String, dynamic>{
            'id': '1',
            'owner': 'owner@mail.com',
            'name': 'name',
            'icon': 100,
            'color': 200,
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
            'owner': 'owner@mail.com',
            'name': 'name',
            'icon': 100,
            'color': 200,
          }),
        );
      });
    });
  });
}
