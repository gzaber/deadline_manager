import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    const id = 'mockId';
    const email = 'mockEmail';

    test('constructor works correctly', () {
      expect(
        () => const User(id: id, email: email),
        returnsNormally,
      );
    });

    test('supports value equality', () {
      expect(
        const User(id: id, email: email),
        equals(const User(id: id, email: email)),
      );
    });

    test('props are correct', () {
      expect(
        const User(id: id, email: email).props,
        equals([id, email]),
      );
    });

    test('empty creates user with empty id and email', () {
      const user = User.empty;
      expect(user.id, isEmpty);
      expect(user.email, isEmpty);
    });

    group('isEmpty', () {
      test('returns true for empty user', () {
        expect(User.empty.isEmpty, true);
      });
      test('returns false for non empty user', () {
        const user = User(id: id, email: email);
        expect(user.isEmpty, false);
      });
    });

    group('isNotEmpty', () {
      test('returns false for empty user', () {
        expect(User.empty.isNotEmpty, false);
      });
      test('returns true for non empty user', () {
        const user = User(id: id, email: email);
        expect(user.isNotEmpty, true);
      });
    });
  });
}
