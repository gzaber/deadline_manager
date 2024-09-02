import 'package:authentication_repository/authentication_repository.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileState', () {
    const mockUser = User(id: '1', email: 'email');

    ProfileState createState({
      ProfileStatus status = ProfileStatus.initial,
      User user = User.empty,
    }) {
      return ProfileState(
        status: status,
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
          ProfileStatus.initial,
          User.empty,
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
            status: null,
            user: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            status: ProfileStatus.success,
            user: mockUser,
          ),
          equals(
            createState(
              status: ProfileStatus.success,
              user: mockUser,
            ),
          ),
        );
      });
    });
  });
}
