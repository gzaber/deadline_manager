import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockCategoriesCubit extends MockCubit<CategoriesState>
    implements CategoriesCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('CategoriesPage', () {
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;
    late PermissionsRepository permissionsRepository;
    late AppCubit appCubit;

    const mockUser = User(id: '1', email: 'email');

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();
      permissionsRepository = MockPermissionsRepository();
      appCubit = MockAppCubit();

      when(() => appCubit.state).thenReturn(
        const AppState(
          isAuthenticated: true,
          user: mockUser,
        ),
      );
      when(() => categoriesRepository.observeCategoriesByOwner(any()))
          .thenAnswer((_) => Stream.value([]));
    });

    testWidgets('renders CategoriesView', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
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
              home: CategoriesPage(),
            ),
          ),
        ),
      );

      expect(find.byType(CategoriesView), findsOneWidget);
    });
  });

  group('CategoriesView', () {
    late CategoriesCubit categoriesCubit;
    late GoRouter router;

    const mockUser = User(id: '1', email: 'email');
    final mockCategory = Category(
      id: '1',
      owner: mockUser.email,
      name: 'category-name',
      icon: 100,
      color: 200,
    );

    setUp(() {
      categoriesCubit = MockCategoriesCubit();
      router = MockGoRouter();

      when(() => categoriesCubit.state).thenReturn(
        CategoriesState(
          status: CategoriesStatus.success,
          categories: [mockCategory],
          user: mockUser,
        ),
      );
    });

    Widget createView() {
      return BlocProvider.value(
        value: categoriesCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: InheritedGoRouter(
            goRouter: router,
            child: const CategoriesView(),
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
            matching: find.text(AppLocalizationsEn().categoriesTitle),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders add icon button', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(AddIconButton), findsOneWidget);
      });

      group('add icon button', () {
        testWidgets('navigates to AddEditCategory location when tapped',
            (tester) async {
          await tester.pumpWidget(createView());
          await tester.tap(find.byType(AddIconButton));

          verify(() => router.go(AppRouter.categoriesToAddEditCategoryLocation))
              .called(1);
        });
      });
    });

    testWidgets('renders circular progress indicator when loading data',
        (tester) async {
      when(() => categoriesCubit.state)
          .thenReturn(const CategoriesState(status: CategoriesStatus.loading));

      await tester.pumpWidget(createView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders text info when there are no categories to display',
        (tester) async {
      when(() => categoriesCubit.state)
          .thenReturn(const CategoriesState(status: CategoriesStatus.success));

      await tester.pumpWidget(createView());

      expect(
        find.text(AppLocalizationsEn().emptyListMessage),
        findsOneWidget,
      );
    });

    testWidgets('renders failure snackbar', (tester) async {
      whenListen(
        categoriesCubit,
        Stream.fromIterable(
          [const CategoriesState(status: CategoriesStatus.failure)],
        ),
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

    group('grid view', () {
      testWidgets('renders category list tile', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.text(mockCategory.name),
          ),
          findsOneWidget,
        );
      });

      group('list tile', () {
        testWidgets('renders popup menu button', (tester) async {
          await tester.pumpWidget(createView());

          expect(find.byType(ListTile), findsOneWidget);
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
              'navigates to AddEditCategory location when update option tapped',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();
            await tester.tap(find.text(AppLocalizationsEn().menuUpdateOption));

            verify(() => router.go(
                  AppRouter.categoriesToAddEditCategoryLocation,
                  extra: mockCategory,
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

            verify(() => categoriesCubit.deleteCategory(mockCategory.id))
                .called(1);
          });
        });

        testWidgets('navigates to CategoryDetails location when tapped',
            (tester) async {
          await tester.pumpWidget(createView());
          await tester.tap(find.text(mockCategory.name));

          verify(() => router.go(
                  '${AppRouter.categoriesToCategoryDetailsLocation}/${mockCategory.id}'))
              .called(1);
        });
      });
    });
  });
}
