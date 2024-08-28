import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_permission/add_edit_permission.dart';
import 'package:deadline_manager/app/app.dart';
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

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockAddEditPermissionCubit extends MockCubit<AddEditPermissionState>
    implements AddEditPermissionCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('AddEditPermissionPage', () {
    late CategoriesRepository categoriesRepository;
    late PermissionsRepository permissionsRepository;
    late AppCubit appCubit;

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      permissionsRepository = MockPermissionsRepository();
      appCubit = MockAppCubit();

      when(() => appCubit.state).thenReturn(
        const AppState(
          isAuthenticated: true,
          user: User(id: '1', email: 'email'),
        ),
      );
    });

    testWidgets('renders AddEditPermissionView', (tester) async {
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
            home: AddEditPermissionPage(),
          ),
        ),
      ));

      expect(find.byType(AddEditPermissionView), findsOneWidget);
    });
  });

  group('AddEditPermissionView', () {
    late AddEditPermissionCubit addEditPermissionCubit;
    final mockInitialPermission = Permission(
      id: '1',
      giver: 'giver',
      receiver: 'receiver',
      categoryIds: const ['11', '12'],
    );

    setUp(() {
      addEditPermissionCubit = MockAddEditPermissionCubit();
    });

    Widget createView() {
      return BlocProvider.value(
        value: addEditPermissionCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: AddEditPermissionView(),
        ),
      );
    }

    group('AppBar', () {
      group('title', () {
        testWidgets('renders correct text when permission is created',
            (tester) async {
          when(() => addEditPermissionCubit.state)
              .thenReturn(const AddEditPermissionState());

          await tester.pumpWidget(createView());

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text(AppLocalizationsEn().addEditCreateTitle),
            ),
            findsOneWidget,
          );
        });

        testWidgets('renders correct text when permission is updated',
            (tester) async {
          when(() => addEditPermissionCubit.state).thenReturn(
              AddEditPermissionState(initialPermission: mockInitialPermission));

          await tester.pumpWidget(createView());

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text(AppLocalizationsEn().addEditUpdateTitle),
            ),
            findsOneWidget,
          );
        });
      });
    });

    group('save button', () {
      testWidgets('renders icon', (tester) async {
        when(() => addEditPermissionCubit.state).thenReturn(
            AddEditPermissionState(initialPermission: mockInitialPermission));

        await tester.pumpWidget(createView());

        expect(find.byType(IconButton), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byIcon(Icons.save),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders circular progress indicator when saving data',
          (tester) async {
        when(() => addEditPermissionCubit.state)
            .thenReturn(AddEditPermissionState(
          status: AddEditPermissionStatus.loading,
          initialPermission: mockInitialPermission,
        ));

        await tester.pumpWidget(createView());

        expect(find.byType(IconButton), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );
      });

      testWidgets('calls savePermission cubit method when tapped',
          (tester) async {
        when(() => addEditPermissionCubit.state)
            .thenReturn(AddEditPermissionState(
          initialPermission: mockInitialPermission,
          receiver: 'receiver',
        ));
        when(() => addEditPermissionCubit.savePermission())
            .thenAnswer((_) async {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byIcon(Icons.save));

        verify(() => addEditPermissionCubit.savePermission()).called(1);
      });

      testWidgets(
          'does not call savePermission cubit method when tapped if receiver is empty',
          (tester) async {
        when(() => addEditPermissionCubit.state)
            .thenReturn(AddEditPermissionState(
          initialPermission: mockInitialPermission,
          receiver: '',
        ));
        when(() => addEditPermissionCubit.savePermission())
            .thenAnswer((_) async {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byIcon(Icons.save));

        verifyNever(() => addEditPermissionCubit.savePermission());
      });
    });

    group('receiver text form field', () {
      testWidgets('calls onReceiverChanged cubit method when text is changed',
          (tester) async {
        when(() => addEditPermissionCubit.state)
            .thenReturn(const AddEditPermissionState());
        when(() => addEditPermissionCubit.onReceiverChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.enterText(find.byType(TextFormField), 'new-receiver');

        verify(() => addEditPermissionCubit.onReceiverChanged('new-receiver'))
            .called(1);
      });
    });

    group('category selector', () {
      final mockCategory = Category(
        id: '11',
        owner: 'owner',
        name: 'some-category',
        icon: 100,
        color: 200,
      );

      testWidgets(
          'calls onCategoryChanged cubit method when category is changed',
          (tester) async {
        when(() => addEditPermissionCubit.state)
            .thenReturn(AddEditPermissionState(categories: [mockCategory]));
        when(() => addEditPermissionCubit.onCategoryChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.tap(find.text('some-category'));

        verify(() => addEditPermissionCubit.onCategoryChanged(mockCategory.id))
            .called(1);
      });
    });

    testWidgets('renders failure snackbar', (tester) async {
      when(() => addEditPermissionCubit.state)
          .thenReturn(const AddEditPermissionState());
      whenListen(
        addEditPermissionCubit,
        Stream.fromIterable([
          const AddEditPermissionState(status: AddEditPermissionStatus.failure)
        ]),
      );

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

    group('router', () {
      late GoRouter router;

      setUp(() {
        router = MockGoRouter();
      });

      Widget createViewWithRouter() {
        return BlocProvider.value(
          value: addEditPermissionCubit,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: InheritedGoRouter(
              goRouter: router,
              child: const AddEditPermissionView(),
            ),
          ),
        );
      }

      testWidgets('pops when permission successfully saved', (tester) async {
        when(() => addEditPermissionCubit.state)
            .thenReturn(const AddEditPermissionState());
        whenListen(
          addEditPermissionCubit,
          Stream.fromIterable(const [
            AddEditPermissionState(status: AddEditPermissionStatus.saved)
          ]),
        );

        await tester.pumpWidget(createViewWithRouter());

        verify(() => router.pop()).called(1);
      });
    });
  });
}
