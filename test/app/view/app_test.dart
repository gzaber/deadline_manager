import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/authentication/authentication.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late User user;

    final categoriesRepository = MockCategoriesRepository();
    final deadlinesRepository = MockDeadlinesRepository();
    final permissionsRepository = MockPermissionsRepository();

    setUpAll(() {
      setFirebaseUiIsTestMode(true);
    });

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();
      when(() => authenticationRepository.user)
          .thenAnswer((_) => Stream.value(user));
      when(() => authenticationRepository.auth).thenReturn(MockFirebaseAuth());
      when(() => user.isNotEmpty).thenReturn(true);
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: authenticationRepository,
          categoriesRepository: categoriesRepository,
          deadlinesRepository: deadlinesRepository,
          permissionsRepository: permissionsRepository,
        ),
      );
      await tester.pump();

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AppCubit appCubit;

    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;
    late PermissionsRepository permissionsRepository;

    setUpAll(() {
      setFirebaseUiIsTestMode(true);
    });

    setUp(() {
      appCubit = MockAppCubit();
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();
      permissionsRepository = MockPermissionsRepository();
    });

    testWidgets('navigates to AuthenticationPage when not authenticated',
        (tester) async {
      when(() => appCubit.state)
          .thenReturn(const AppState(isAuthenticated: false));
      when(() => appCubit.auth).thenReturn(MockFirebaseAuth());

      await tester.pumpWidget(
        BlocProvider.value(
          value: appCubit,
          child: const AppView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AuthenticationPage), findsOneWidget);
    });

    testWidgets('navigates to SummaryPage when authenticated', (tester) async {
      final user = MockUser();

      when(() => appCubit.state)
          .thenReturn(AppState(isAuthenticated: true, user: user));

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: categoriesRepository),
            RepositoryProvider.value(value: deadlinesRepository),
            RepositoryProvider.value(value: permissionsRepository)
          ],
          child: BlocProvider.value(
            value: appCubit,
            child: const AppView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SummaryPage), findsOneWidget);
    });
  });
}
