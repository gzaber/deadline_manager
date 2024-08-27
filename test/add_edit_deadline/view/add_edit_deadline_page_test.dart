import 'package:bloc_test/bloc_test.dart';
import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockAddEditDeadlineCubit extends MockCubit<AddEditDeadlineState>
    implements AddEditDeadlineCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('AddEditDeadlinePage', () {
    late DeadlinesRepository deadlinesRepository;

    setUp(() {
      deadlinesRepository = MockDeadlinesRepository();
    });

    testWidgets('renders AddEditDeadlineView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deadlinesRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: AddEditDeadlinePage(categoryId: '1'),
          ),
        ),
      );

      expect(find.byType(AddEditDeadlineView), findsOneWidget);
    });
  });

  group('AddEditDeadlineView', () {
    late AddEditDeadlineCubit addEditDeadlineCubit;
    final mockExpirationDate = DateTime.parse('2024-12-06');
    final mockInitialDeadline = Deadline(
      categoryId: '11',
      name: 'name',
      expirationDate: mockExpirationDate,
    );

    setUp(() {
      addEditDeadlineCubit = MockAddEditDeadlineCubit();
    });

    Widget createView() {
      return BlocProvider.value(
        value: addEditDeadlineCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: AddEditDeadlineView(),
        ),
      );
    }

    group('AppBar', () {
      group('title', () {
        testWidgets('renders correct text when deadline is created',
            (tester) async {
          when(() => addEditDeadlineCubit.state).thenReturn(
              AddEditDeadlineState(expirationDate: mockExpirationDate));

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

        testWidgets('renders correct text when deadline is updated',
            (tester) async {
          when(() => addEditDeadlineCubit.state)
              .thenReturn(AddEditDeadlineState(
            initialDeadline: mockInitialDeadline,
            expirationDate: mockExpirationDate,
          ));

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
        when(() => addEditDeadlineCubit.state).thenReturn(
            AddEditDeadlineState(expirationDate: mockExpirationDate));

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
        when(() => addEditDeadlineCubit.state).thenReturn(AddEditDeadlineState(
          status: AddEditDeadlineStatus.loading,
          expirationDate: mockExpirationDate,
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

      testWidgets('calls saveDeadline cubit method when tapped',
          (tester) async {
        when(() => addEditDeadlineCubit.state).thenReturn(AddEditDeadlineState(
          name: 'category',
          expirationDate: mockExpirationDate,
        ));
        when(() => addEditDeadlineCubit.saveDeadline())
            .thenAnswer((_) async {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byIcon(Icons.save));

        verify(() => addEditDeadlineCubit.saveDeadline()).called(1);
      });

      testWidgets(
          'does not call saveDeadline cubit method when tapped if name is empty',
          (tester) async {
        when(() => addEditDeadlineCubit.state).thenReturn(
            AddEditDeadlineState(name: '', expirationDate: mockExpirationDate));
        when(() => addEditDeadlineCubit.saveDeadline())
            .thenAnswer((_) async {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byIcon(Icons.save));

        verifyNever(() => addEditDeadlineCubit.saveDeadline());
      });
    });

    group('name text form field', () {
      testWidgets('calls onNameChanged cubit method when text is changed',
          (tester) async {
        when(() => addEditDeadlineCubit.state).thenReturn(
            AddEditDeadlineState(expirationDate: mockExpirationDate));
        when(() => addEditDeadlineCubit.onNameChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.enterText(find.byType(TextFormField), 'new-name');

        verify(() => addEditDeadlineCubit.onNameChanged('new-name')).called(1);
      });
    });

    group('date picker', () {
      testWidgets(
          'calls onDateTimeChanged cubit method when expiration date is changed',
          (tester) async {
        when(() => addEditDeadlineCubit.state).thenReturn(
            AddEditDeadlineState(expirationDate: mockExpirationDate));
        when(() => addEditDeadlineCubit.onDateTimeChanged(any()))
            .thenAnswer((_) {});

        await tester.pumpWidget(createView());
        await tester.tap(find.byType(OutlinedButton));
        await tester.pump();
        await tester.tap(find.text('10'));
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        verify(() => addEditDeadlineCubit
            .onDateTimeChanged(DateTime.parse('2024-12-10'))).called(1);
      });
    });

    testWidgets('renders failure snackbar', (tester) async {
      when(() => addEditDeadlineCubit.state)
          .thenReturn(AddEditDeadlineState(expirationDate: mockExpirationDate));
      whenListen(
        addEditDeadlineCubit,
        Stream.fromIterable([
          AddEditDeadlineState(
            status: AddEditDeadlineStatus.failure,
            expirationDate: mockExpirationDate,
          )
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
          value: addEditDeadlineCubit,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: InheritedGoRouter(
              goRouter: router,
              child: const AddEditDeadlineView(),
            ),
          ),
        );
      }

      testWidgets('pops when deadline successfully saved', (tester) async {
        when(() => addEditDeadlineCubit.state).thenReturn(
            AddEditDeadlineState(expirationDate: mockExpirationDate));
        whenListen(
          addEditDeadlineCubit,
          Stream.fromIterable([
            AddEditDeadlineState(
              status: AddEditDeadlineStatus.success,
              expirationDate: mockExpirationDate,
            )
          ]),
        );

        await tester.pumpWidget(createViewWithRouter());

        verify(() => router.pop()).called(1);
      });
    });
  });
}
