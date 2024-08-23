import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationRepository', () {
    const id = 'id';
    const email = 'email';
    const user = User(id: id, email: email);
    final mockUser = MockUser(uid: id, email: email);

    group('constructor', () {
      test('works properly', () {
        expect(
          () => AuthenticationRepository(firebaseAuth: MockFirebaseAuth()),
          returnsNormally,
        );
      });
    });

    group('user', () {
      test('emits user when firebase user is not empty', () async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: MockFirebaseAuth(
            mockUser: mockUser,
            signedIn: true,
          ),
        );

        expect(
          authenticationRepository.user,
          emits(user),
        );
      });

      test('emits empty user when firebase user is null', () async {
        final authenticationRepository =
            AuthenticationRepository(firebaseAuth: MockFirebaseAuth());

        expect(
          authenticationRepository.user,
          emits(User.empty),
        );
      });
    });

    group('signOut', () {
      test('succeeds when sign out succeeds', () {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: MockFirebaseAuth(
            mockUser: mockUser,
            signedIn: true,
          ),
        );

        expect(authenticationRepository.signOut(), completes);
      });
    });

    group('deleteUser', () {
      test('succeeds when account deletion succeeds', () {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: MockFirebaseAuth(
            mockUser: mockUser,
            signedIn: true,
          ),
        );

        expect(authenticationRepository.deleteUser(), completes);
      });
    });
  });
}
