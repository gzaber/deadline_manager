import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  group('ProfilePage', () {
    late AuthenticationRepository authenticationRepository;
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;
    late PermissionsRepository permissionsRepository;
    late AppCubit appCubit;

    const mockUser = User(id: '1', email: 'email');

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();
      permissionsRepository = MockPermissionsRepository();
      appCubit = MockAppCubit();

      when(() => appCubit.state)
          .thenReturn(const AppState(isAuthenticated: true, user: mockUser));
    });

    testWidgets('renders ProfileView', (tester) async {
      await tester.pumpWidget(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: authenticationRepository,
          ),
          RepositoryProvider.value(
            value: categoriesRepository,
          ),
          RepositoryProvider.value(
            value: deadlinesRepository,
          ),
          RepositoryProvider.value(
            value: permissionsRepository,
          ),
        ],
        child: BlocProvider.value(
          value: appCubit,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: ProfilePage(),
          ),
        ),
      ));

      expect(find.byType(ProfileView), findsOneWidget);
    });
  });

  group('ProfileView', () {
    late ProfileCubit profileCubit;
    const mockUser = User(id: '1', email: 'email');

    setUp(() {
      profileCubit = MockProfileCubit();

      when(() => profileCubit.state).thenReturn(
          const ProfileState(status: ProfileStatus.initial, user: mockUser));
    });

    Widget createView() {
      return BlocProvider.value(
        value: profileCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ProfileView(),
        ),
      );
    }

    group('AppBar', () {
      testWidgets('renders correct title text', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(AppLocalizationsEn().profileTitle),
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('renders circular progress indicator when status is loading',
        (tester) async {
      when(() => profileCubit.state)
          .thenReturn(const ProfileState(status: ProfileStatus.loading));

      await tester.pumpWidget(createView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders failure snackbar when sign out fails', (tester) async {
      when(() => profileCubit.state)
          .thenReturn(const ProfileState(status: ProfileStatus.loading));
      whenListen(
          profileCubit,
          Stream.fromIterable(
              [const ProfileState(status: ProfileStatus.signOutFailure)]));

      await tester.pumpWidget(createView());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(AppLocalizationsEn().failureMessage),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders failure snackbar when delete user fails',
        (tester) async {
      when(() => profileCubit.state)
          .thenReturn(const ProfileState(status: ProfileStatus.loading));
      whenListen(
          profileCubit,
          Stream.fromIterable(
              [const ProfileState(status: ProfileStatus.deleteUserFailure)]));

      await tester.pumpWidget(createView());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(AppLocalizationsEn().deleteAccountFailureMessage),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders correct icon and user email', (tester) async {
      await tester.pumpWidget(createView());

      expect(find.byIcon(AppIcons.profileDestinationIcon), findsOneWidget);
      expect(find.text(mockUser.email), findsOneWidget);
    });

    testWidgets('renders sign out button', (tester) async {
      await tester.pumpWidget(createView());

      expect(
        find.descendant(
          of: find.byType(OutlinedButton),
          matching: find.text(AppLocalizationsEn().profileSignOutButtonText),
        ),
        findsOneWidget,
      );
    });

    group('sign out button', () {
      testWidgets('calls sign out cubit method when tapped', (tester) async {
        await tester.pumpWidget(createView());
        await tester
            .tap(find.text(AppLocalizationsEn().profileSignOutButtonText));

        verify(() => profileCubit.signOut()).called(1);
      });
    });

    testWidgets('renders delete account button', (tester) async {
      await tester.pumpWidget(createView());

      expect(
        find.descendant(
          of: find.byType(OutlinedButton),
          matching:
              find.text(AppLocalizationsEn().profileDeleteAccountButtonText),
        ),
        findsOneWidget,
      );
    });

    group('delete account button', () {
      testWidgets('shows confirmation dialog when tapped', (tester) async {
        await tester.pumpWidget(createView());
        await tester.tap(
            find.text(AppLocalizationsEn().profileDeleteAccountButtonText));
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmationAlertDialog), findsOneWidget);
      });

      testWidgets('calls sign out cubit method if deletion is confirmed',
          (tester) async {
        await tester.pumpWidget(createView());
        await tester.tap(
            find.text(AppLocalizationsEn().profileDeleteAccountButtonText));
        await tester.pumpAndSettle();

        expect(find.byType(ConfirmationAlertDialog), findsOneWidget);
        await tester
            .tap(find.text(AppLocalizationsEn().dialogConfirmButtonText));

        verify(() => profileCubit.deleteUser()).called(1);
      });
    });
  });
}
