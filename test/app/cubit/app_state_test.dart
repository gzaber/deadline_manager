import 'package:authentication_repository/authentication_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    AppState createSubject() {
      return const AppState(isAuthenticated: false);
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          () => const AppState(isAuthenticated: false),
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([false, User.empty]),
      );
    });
  });
}
