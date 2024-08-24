import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppCubit', () {
    final user = MockUser();
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.user)
          .thenAnswer((_) => const Stream.empty());
    });

    test('initial state is not authenticated when user stream is empty', () {
      expect(
        AppCubit(authenticationRepository: authenticationRepository).state,
        equals(const AppState(isAuthenticated: false)),
      );
    });

    blocTest<AppCubit, AppState>(
      'emits state with authenticated when user is not empty',
      setUp: () {
        when(() => user.isNotEmpty).thenReturn(true);
        when(() => authenticationRepository.user)
            .thenAnswer((_) => Stream.value(user));
      },
      build: () => AppCubit(authenticationRepository: authenticationRepository),
      seed: () => const AppState(isAuthenticated: false),
      expect: () => [AppState(isAuthenticated: true, user: user)],
    );

    blocTest<AppCubit, AppState>(
      'emits state with not authenticated when user is empty',
      setUp: () {
        when(() => authenticationRepository.user)
            .thenAnswer((_) => Stream.value(User.empty));
      },
      build: () => AppCubit(authenticationRepository: authenticationRepository),
      seed: () => const AppState(isAuthenticated: true),
      expect: () => [const AppState(isAuthenticated: false, user: User.empty)],
    );
  });
}
