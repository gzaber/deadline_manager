import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockCategoryDetailsCubit extends MockCubit<CategoryDetailsState>
    implements CategoryDetailsCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('CategoryDetailsPage', () {
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();

      when(() => deadlinesRepository.observeDeadlinesByCategoryId(any()))
          .thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders CategoryDetailsView', (tester) async {
      await tester.pumpWidget(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: categoriesRepository,
          ),
          RepositoryProvider.value(
            value: deadlinesRepository,
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CategoryDetailsPage(categoryId: '1'),
        ),
      ));

      expect(find.byType(CategoryDetailsView), findsOneWidget);
    });
  });

  group('CategoryDetailsView', () {
    late CategoryDetailsCubit categoryDetailsCubit;
    late GoRouter router;

    final mockCategory = Category(
      id: '1',
      owner: 'owner',
      name: 'category-name',
      icon: 100,
      color: 200,
    );
    final mockDeadline = Deadline(
      categoryId: mockCategory.id,
      name: 'name',
      expirationDate: DateTime.parse('2024-12-06'),
    );

    setUp(() {
      categoryDetailsCubit = MockCategoryDetailsCubit();
      router = MockGoRouter();

      when(() => categoryDetailsCubit.state).thenReturn(
        CategoryDetailsState(
          futureStatus: CategoryDetailsFutureStatus.success,
          streamStatus: CategoryDetailsStreamStatus.success,
          category: mockCategory,
          deadlines: [mockDeadline],
        ),
      );
    });

    Widget createView() {
      return BlocProvider.value(
        value: categoryDetailsCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: InheritedGoRouter(
            goRouter: router,
            child: const CategoryDetailsView(),
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
            matching: find.text(mockCategory.name),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders add icon button', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(AddIconButton), findsOneWidget);
      });

      group('add icon button', () {
        testWidgets('navigates to AddEditDeadline location when tapped',
            (tester) async {
          await tester.pumpWidget(createView());
          await tester.tap(find.byType(AddIconButton));

          verify(
            () => router.go(
              '${AppRouter.categoriesToCategoryDetailsLocation}/${mockCategory.id}/${AppRouter.addEditDeadlinePath}/${mockCategory.id}',
            ),
          ).called(1);
        });
      });
    });

    testWidgets('renders circular progress indicator when loading data',
        (tester) async {
      when(() => categoryDetailsCubit.state).thenReturn(CategoryDetailsState(
          streamStatus: CategoryDetailsStreamStatus.loading));

      await tester.pumpWidget(createView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders text info when there are no deadlines to display',
        (tester) async {
      when(() => categoryDetailsCubit.state).thenReturn(CategoryDetailsState(
          streamStatus: CategoryDetailsStreamStatus.success));

      await tester.pumpWidget(createView());

      expect(
        find.text(AppLocalizationsEn().emptyListMessage),
        findsOneWidget,
      );
    });

    testWidgets('renders failure snackbar', (tester) async {
      when(() => categoryDetailsCubit.state).thenReturn(CategoryDetailsState(
          streamStatus: CategoryDetailsStreamStatus.loading));
      whenListen(
          categoryDetailsCubit,
          Stream.fromIterable([
            CategoryDetailsState(
                streamStatus: CategoryDetailsStreamStatus.failure)
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
      testWidgets('renders deadline list tile', (tester) async {
        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.text(mockDeadline.name),
          ),
          findsOneWidget,
        );
      });

      group('list tile', () {
        testWidgets(
            'renders row with date text and popup menu button if screen size is not mobile',
            (tester) async {
          await tester.pumpWidget(createView());

          expect(
            find.descendant(
              of: find.widgetWithText(Row, '06-12-2024'),
              matching: find.byType(PopupMenuButton),
            ),
            findsOneWidget,
          );
        });

        testWidgets(
            'renders popup menu button without date text if screen size is mobile',
            (tester) async {
          tester.view.physicalSize = const Size(400, 800);
          tester.view.devicePixelRatio = 1;

          await tester.pumpWidget(createView());

          expect(
            find.descendant(
              of: find.widgetWithText(Row, '06-12-2024'),
              matching: find.byType(PopupMenuButton),
            ),
            findsNothing,
          );
          expect(
            find.descendant(
              of: find.byType(ListTile),
              matching: find.byType(PopupMenuButton),
            ),
            findsOneWidget,
          );

          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
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
              'navigates to AddEditDeadline location when update option tapped',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();
            await tester.tap(find.text(AppLocalizationsEn().menuUpdateOption));

            verify(() => router.go(
                  '${AppRouter.categoriesToCategoryDetailsLocation}/${mockDeadline.categoryId}/${AppRouter.addEditDeadlinePath}/${mockDeadline.categoryId}',
                  extra: mockDeadline,
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

            verify(() => categoryDetailsCubit.deleteDeadline(mockDeadline.id))
                .called(1);
          });
        });
      });

      testWidgets('renders divider between deadline list tiles',
          (tester) async {
        when(() => categoryDetailsCubit.state).thenReturn(
            CategoryDetailsState(deadlines: [mockDeadline, mockDeadline]));

        await tester.pumpWidget(createView());

        expect(find.byType(Divider), findsOneWidget);
      });
    });
  });
}
