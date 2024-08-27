import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/add_edit_category.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockAddEditCategoryCubit extends MockCubit<AddEditCategoryState>
    implements AddEditCategoryCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('AddEditCategoryPage', () {
    late CategoriesRepository categoriesRepository;
    late AppCubit appCubit;

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
      appCubit = MockAppCubit();

      when(() => appCubit.state)
          .thenReturn(const AppState(isAuthenticated: true));
    });

    testWidgets('renders AddEditCategoryView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: categoriesRepository,
          child: BlocProvider.value(
            value: appCubit,
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: AddEditCategoryPage(),
            ),
          ),
        ),
      );

      expect(find.byType(AddEditCategoryView), findsOneWidget);
    });
  });

  group('AddEditCategoryView', () {
    late AddEditCategoryCubit addEditCategoryCubit;
    final mockInitialCategory = Category(
      id: '1',
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );

    setUp(() {
      addEditCategoryCubit = MockAddEditCategoryCubit();
    });

    Widget createView() {
      return BlocProvider.value(
        value: addEditCategoryCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: AddEditCategoryView(),
        ),
      );
    }

    group('AppBar', () {
      group('title', () {
        testWidgets('renders correct text when category is created',
            (tester) async {
          when(() => addEditCategoryCubit.state)
              .thenReturn(const AddEditCategoryState());

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

        testWidgets('renders correct text when category is updated',
            (tester) async {
          when(() => addEditCategoryCubit.state).thenReturn(
              AddEditCategoryState(initialCategory: mockInitialCategory));

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
        when(() => addEditCategoryCubit.state).thenReturn(
            AddEditCategoryState(initialCategory: mockInitialCategory));

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
        when(() => addEditCategoryCubit.state).thenReturn(AddEditCategoryState(
          status: AddEditCategoryStatus.loading,
          initialCategory: mockInitialCategory,
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

      testWidgets('calls saveCategory cubit method when tapped',
          (tester) async {
        when(() => addEditCategoryCubit.state).thenReturn(AddEditCategoryState(
          initialCategory: mockInitialCategory,
          name: 'category',
        ));
        when(() => addEditCategoryCubit.saveCategory())
            .thenAnswer((_) async {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byIcon(Icons.save));

        verify(() => addEditCategoryCubit.saveCategory()).called(1);
      });

      testWidgets(
          'does not call saveCategory cubit method when tapped if name is empty',
          (tester) async {
        when(() => addEditCategoryCubit.state).thenReturn(AddEditCategoryState(
          initialCategory: mockInitialCategory,
          name: '',
        ));
        when(() => addEditCategoryCubit.saveCategory())
            .thenAnswer((_) async {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byIcon(Icons.save));

        verifyNever(() => addEditCategoryCubit.saveCategory());
      });
    });

    group('name text form field', () {
      testWidgets('calls onNameChanged cubit method when text is changed',
          (tester) async {
        when(() => addEditCategoryCubit.state)
            .thenReturn(const AddEditCategoryState());
        when(() => addEditCategoryCubit.onNameChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.enterText(find.byType(TextFormField), 'new-name');

        verify(() => addEditCategoryCubit.onNameChanged('new-name')).called(1);
      });
    });

    group('color selector', () {
      final lastColor = AppColors.categoryColors.last.value;

      testWidgets('calls onColorChanged cubit method when color is changed',
          (tester) async {
        when(() => addEditCategoryCubit.state)
            .thenReturn(const AddEditCategoryState());
        when(() => addEditCategoryCubit.onColorChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.tap(
            find.byKey(Key('addEditCategoryView_color_choiceChip$lastColor')));

        verify(() => addEditCategoryCubit.onColorChanged(lastColor)).called(1);
      });
    });

    group('icon selector', () {
      final lastIcon = AppIcons.categoryIcons.last.codePoint;

      testWidgets('calls onIconChanged cubit method when icon is changed',
          (tester) async {
        when(() => addEditCategoryCubit.state)
            .thenReturn(const AddEditCategoryState());
        when(() => addEditCategoryCubit.onIconChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.tap(
            find.byKey(Key('addEditCategoryView_icon_choiceChip$lastIcon')));

        verify(() => addEditCategoryCubit.onIconChanged(lastIcon)).called(1);
      });
    });

    testWidgets('renders failure snackbar', (tester) async {
      when(() => addEditCategoryCubit.state)
          .thenReturn(const AddEditCategoryState());
      whenListen(
        addEditCategoryCubit,
        Stream.fromIterable([
          const AddEditCategoryState(status: AddEditCategoryStatus.failure)
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
          value: addEditCategoryCubit,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: InheritedGoRouter(
              goRouter: router,
              child: const AddEditCategoryView(),
            ),
          ),
        );
      }

      testWidgets('pops when category successfully saved', (tester) async {
        when(() => addEditCategoryCubit.state)
            .thenReturn(const AddEditCategoryState());
        whenListen(
          addEditCategoryCubit,
          Stream.fromIterable(const [
            AddEditCategoryState(status: AddEditCategoryStatus.success)
          ]),
        );

        await tester.pumpWidget(createViewWithRouter());

        verify(() => router.pop()).called(1);
      });
    });
  });
}
