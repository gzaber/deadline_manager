import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockPermissionsCubit extends MockCubit<PermissionsState>
    implements PermissionsCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockGoRouter extends Mock implements GoRouter {}

class FakePermission extends Fake implements Permission {}

void main() {
  group('PermissionsPage', () {
    late CategoriesRepository categoriesRepository;
    late PermissionsRepository permissionsRepository;
    late AppCubit appCubit;

    const mockUser = User(id: '1', email: 'email');

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      permissionsRepository = MockPermissionsRepository();
      appCubit = MockAppCubit();

      when(() => appCubit.state)
          .thenReturn(const AppState(isAuthenticated: true, user: mockUser));
      when(() => permissionsRepository.observePermissionsByGiver(any()))
          .thenAnswer((_) => Stream.value([]));
    });

    testWidgets('renders PermissionsView', (tester) async {
      await tester.pumpWidget(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: categoriesRepository,
          ),
          RepositoryProvider.value(
            value: permissionsRepository,
          ),
        ],
        child: BlocProvider.value(
          value: appCubit,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: PermissionsPage(),
          ),
        ),
      ));

      expect(find.byType(PermissionsView), findsOneWidget);
    });
  });

  group('PermissionsView', () {
    late PermissionsCubit permissionsCubit;
    late GoRouter router;

    const mockUser = User(id: '1', email: 'email');
    final mockCategory = Category(
      id: '1',
      owner: mockUser.email,
      name: 'name',
      icon: 100,
      color: 200,
    );
    final mockPermission = Permission(
      id: '11',
      giver: mockUser.email,
      receiver: 'receiver',
      categoryIds: [mockCategory.id],
    );

    setUpAll(() {
      registerFallbackValue(FakePermission());
    });

    setUp(() {
      permissionsCubit = MockPermissionsCubit();
      router = MockGoRouter();

      when(() => permissionsCubit.state).thenReturn(
        PermissionsState(
          futureStatus: PermissionsFutureStatus.success,
          streamStatus: PermissionsStreamStatus.success,
          permissions: [mockPermission],
          categories: [mockCategory],
          user: mockUser,
        ),
      );
      when(() => permissionsCubit.getPermissionCategories(any()))
          .thenAnswer((_) => [mockCategory]);
    });

    Widget createView() {
      return BlocProvider.value(
        value: permissionsCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: InheritedGoRouter(
            goRouter: router,
            child: const PermissionsView(),
          ),
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
            matching: find.text(AppLocalizationsEn().permissionsTitle),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders add icon button', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(AddIconButton), findsOneWidget);
      });

      group('add icon button', () {
        testWidgets('navigates to AddEditPermission location when tapped',
            (tester) async {
          await tester.pumpWidget(createView());
          await tester.tap(find.byType(AddIconButton));

          verify(
            () => router.go(AppRouter.permissionsToAddEditPermissionsLocation),
          ).called(1);
        });
      });
    });

    testWidgets('renders circular progress indicator when loading data',
        (tester) async {
      when(() => permissionsCubit.state).thenReturn(const PermissionsState(
          streamStatus: PermissionsStreamStatus.loading));

      await tester.pumpWidget(createView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders text info when there are no permissions to display',
        (tester) async {
      when(() => permissionsCubit.state).thenReturn(const PermissionsState(
          streamStatus: PermissionsStreamStatus.success));

      await tester.pumpWidget(createView());

      expect(
        find.text(AppLocalizationsEn().emptyListMessage),
        findsOneWidget,
      );
    });

    testWidgets('renders failure snackbar', (tester) async {
      when(() => permissionsCubit.state).thenReturn(const PermissionsState(
          streamStatus: PermissionsStreamStatus.loading));
      whenListen(
          permissionsCubit,
          Stream.fromIterable([
            const PermissionsState(
                streamStatus: PermissionsStreamStatus.failure)
          ]));

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

    group('list view', () {
      testWidgets('renders permission list tile', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.text(mockPermission.receiver),
          ),
          findsOneWidget,
        );
      });

      group('list tile', () {
        testWidgets('renders popup menu button', (tester) async {
          await tester.pumpWidget(createView());

          expect(
            find.descendant(
              of: find.byType(ListTile),
              matching: find.byType(PopupMenuButton),
            ),
            findsOneWidget,
          );
        });

        group('popup menu button', () {
          testWidgets('renders 2 menu items when tapped', (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();

            expect(find.byType(PopupMenuItem), findsNWidgets(2));
            expect(
              find.descendant(
                of: find.byType(PopupMenuItem),
                matching: find.text(AppLocalizationsEn().menuUpdateOption),
              ),
              findsOneWidget,
            );
            expect(
              find.descendant(
                of: find.byType(PopupMenuItem),
                matching: find.text(AppLocalizationsEn().menuDeleteOption),
              ),
              findsOneWidget,
            );
          });

          testWidgets(
              'navigates to AddEditPermission location when update option tapped',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();
            await tester.tap(find.text(AppLocalizationsEn().menuUpdateOption));

            verify(() => router.go(
                  AppRouter.permissionsToAddEditPermissionsLocation,
                  extra: mockPermission,
                )).called(1);
          });

          testWidgets('shows confirmation dialog when delete option tapped',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();
            await tester.tap(find.text(AppLocalizationsEn().menuDeleteOption));
            await tester.pumpAndSettle();

            expect(find.byType(ConfirmationAlertDialog), findsOneWidget);
          });

          testWidgets('calls cubit method if deletion is confirmed',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();
            await tester.tap(find.text(AppLocalizationsEn().menuDeleteOption));
            await tester.pumpAndSettle();
            await tester
                .tap(find.text(AppLocalizationsEn().dialogConfirmButtonText));

            verify(() => permissionsCubit.deletePermission(mockPermission.id))
                .called(1);
          });
        });
      });

      testWidgets('renders divider between deadline list tiles',
          (tester) async {
        when(() => permissionsCubit.state).thenReturn(
            PermissionsState(permissions: [mockPermission, mockPermission]));

        await tester.pumpWidget(createView());

        expect(find.byType(Divider), findsOneWidget);
      });
    });
  });
}
