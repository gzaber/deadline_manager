import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockSummaryCubit extends MockCubit<SummaryState>
    implements SummaryCubit {}

void main() {
  group('SummaryPage', () {
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
    });

    testWidgets('renders SummaryView', (tester) async {
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
              home: SummaryPage(),
            ),
          ),
        ),
      );

      expect(find.byType(SummaryView), findsOneWidget);
    });
  });

  group('SummaryView', () {
    late SummaryCubit summaryCubit;

    const userDateString = '2024-12-06';
    const sharedDateString = '2024-12-07';
    final mockUserSummaryDeadline1 = SummaryDeadline(
      name: 'user-deadline1',
      expirationDate: DateTime.parse(userDateString),
      isShared: false,
      categoryName: 'user-category1',
      sharedBy: 'user',
    );
    final mockUserSummaryDeadline2 = SummaryDeadline(
      name: 'user-deadline2',
      expirationDate: DateTime.parse(userDateString),
      isShared: false,
      categoryName: 'user-category2',
      sharedBy: 'user',
    );
    final mockSharedSummaryDeadline1 = SummaryDeadline(
      name: 'shared-deadline1',
      expirationDate: DateTime.parse(sharedDateString),
      isShared: true,
      categoryName: 'shared-category1',
      sharedBy: 'sharing1',
    );
    final mockSharedSummaryDeadline2 = SummaryDeadline(
      name: 'shared-deadline2',
      expirationDate: DateTime.parse(sharedDateString),
      isShared: true,
      categoryName: 'shared-category2',
      sharedBy: 'sharing2',
    );

    setUp(() {
      summaryCubit = MockSummaryCubit();

      when(() => summaryCubit.state).thenReturn(
        const SummaryState(),
      );
    });

    Widget createView() {
      return BlocProvider.value(
        value: summaryCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: SummaryView(),
        ),
      );
    }

    group('AppBar', () {
      group('title', () {
        testWidgets('renders correct text', (tester) async {
          await tester.pumpWidget(createView());

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text(AppLocalizationsEn().summaryTitle),
            ),
            findsOneWidget,
          );
        });
      });

      group('filter button', () {
        testWidgets('renders popup menu button', (tester) async {
          await tester.pumpWidget(createView());

          expect(find.byType(AppBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.byType(PopupMenuButton),
            ),
            findsOneWidget,
          );
        });

        testWidgets('renders 2 menu items with text when tapped',
            (tester) async {
          await tester.pumpWidget(createView());
          await tester.tap(find.byType(PopupMenuButton));
          await tester.pumpAndSettle();

          expect(find.byType(PopupMenuItem), findsNWidgets(2));
          expect(
            find.descendant(
              of: find.byType(PopupMenuItem),
              matching:
                  find.text(AppLocalizationsEn().summaryShowDetailsMenuOption),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byType(PopupMenuItem),
              matching:
                  find.text(AppLocalizationsEn().summaryShowSharedMenuOption),
            ),
            findsOneWidget,
          );
        });

        testWidgets('renders 2 menu items with check icon when tapped',
            (tester) async {
          when(() => summaryCubit.state).thenReturn(
            const SummaryState(showDetails: true, showShared: true),
          );
          await tester.pumpWidget(createView());
          await tester.tap(find.byType(PopupMenuButton));
          await tester.pumpAndSettle();

          expect(find.byType(PopupMenuItem), findsNWidgets(2));
          expect(
            find.descendant(
              of: find.byType(PopupMenuItem),
              matching: find.byIcon(AppIcons.checkIcon),
            ),
            findsNWidgets(2),
          );
        });

        group('menu item', () {
          testWidgets('calls toggleShowDetails cubit method when tapped',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();

            await tester.tap(
                find.text(AppLocalizationsEn().summaryShowDetailsMenuOption));

            verify(() => summaryCubit.toggleShowDetails()).called(1);
          });

          testWidgets('calls toggleShowShared cubit method when tapped',
              (tester) async {
            await tester.pumpWidget(createView());
            await tester.tap(find.byType(PopupMenuButton));
            await tester.pumpAndSettle();

            await tester.tap(
                find.text(AppLocalizationsEn().summaryShowSharedMenuOption));

            verify(() => summaryCubit.toggleShowShared()).called(1);
          });
        });
      });
    });

    testWidgets('renders circular progress indicator when loading data',
        (tester) async {
      when(() => summaryCubit.state).thenReturn(
        const SummaryState(status: SummaryStatus.loading),
      );

      await tester.pumpWidget(createView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders text info when there are no deadlines to display',
        (tester) async {
      when(() => summaryCubit.state).thenReturn(
        const SummaryState(status: SummaryStatus.success),
      );

      await tester.pumpWidget(createView());

      expect(
        find.text(AppLocalizationsEn().emptyListMessage),
        findsOneWidget,
      );
    });

    group('list view', () {
      SummaryState setupState({
        bool showDetails = false,
        bool showShared = false,
      }) {
        return SummaryState(
          status: SummaryStatus.success,
          showDetails: showDetails,
          showShared: showShared,
          userDeadlines: [
            mockUserSummaryDeadline1,
            mockUserSummaryDeadline2,
          ],
          summaryDeadlines: [
            mockUserSummaryDeadline1,
            mockUserSummaryDeadline2,
            mockSharedSummaryDeadline1,
            mockSharedSummaryDeadline2,
          ],
        );
      }

      testWidgets('renders user deadlines without details', (tester) async {
        when(() => summaryCubit.state).thenReturn(setupState());

        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsNWidgets(2));
        expect(find.text(mockUserSummaryDeadline1.name), findsOneWidget);
        expect(find.text(mockUserSummaryDeadline2.name), findsOneWidget);
        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline1.categoryName}',
          ),
          findsNothing,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline2.categoryName}',
          ),
          findsNothing,
        );
      });

      testWidgets('renders user deadlines with details', (tester) async {
        when(() => summaryCubit.state)
            .thenReturn(setupState(showDetails: true));

        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsNWidgets(2));
        expect(find.text(mockUserSummaryDeadline1.name), findsOneWidget);
        expect(find.text(mockUserSummaryDeadline2.name), findsOneWidget);
        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline1.categoryName}',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline2.categoryName}',
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders user and shared deadlines without details',
          (tester) async {
        when(() => summaryCubit.state).thenReturn(setupState(showShared: true));

        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsNWidgets(4));
        expect(find.text(mockUserSummaryDeadline1.name), findsOneWidget);
        expect(find.text(mockUserSummaryDeadline2.name), findsOneWidget);
        expect(find.text(mockSharedSummaryDeadline1.name), findsOneWidget);
        expect(find.text(mockSharedSummaryDeadline2.name), findsOneWidget);

        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline1.categoryName}',
          ),
          findsNothing,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline2.categoryName}',
          ),
          findsNothing,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summarySharedByLabel} ${mockSharedSummaryDeadline1.sharedBy}',
          ),
          findsNothing,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summarySharedByLabel} ${mockSharedSummaryDeadline2.sharedBy}',
          ),
          findsNothing,
        );
      });

      testWidgets('renders user and shared deadlines with details',
          (tester) async {
        when(() => summaryCubit.state)
            .thenReturn(setupState(showShared: true, showDetails: true));

        await tester.pumpWidget(createView());

        expect(find.byType(ListTile), findsNWidgets(4));
        expect(find.text(mockUserSummaryDeadline1.name), findsOneWidget);
        expect(find.text(mockUserSummaryDeadline2.name), findsOneWidget);
        expect(find.text(mockSharedSummaryDeadline1.name), findsOneWidget);
        expect(find.text(mockSharedSummaryDeadline2.name), findsOneWidget);

        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline1.categoryName}',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summaryCategoryLabel} ${mockUserSummaryDeadline2.categoryName}',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summarySharedByLabel} ${mockSharedSummaryDeadline1.sharedBy}',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            '${AppLocalizationsEn().summarySharedByLabel} ${mockSharedSummaryDeadline2.sharedBy}',
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('renders failure snackbar', (tester) async {
      whenListen(
        summaryCubit,
        Stream.fromIterable(
          [const SummaryState(status: SummaryStatus.failure)],
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
  });
}
