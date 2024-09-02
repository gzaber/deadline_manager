import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/add_edit_category.dart';
import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadline_manager/add_edit_permission/add_edit_permission.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/authentication/authentication.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockDeadlinesRepository extends Mock implements DeadlinesRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  group('AppRouter', () {
    late AuthenticationRepository authenticationRepository;
    late CategoriesRepository categoriesRepository;
    late DeadlinesRepository deadlinesRepository;
    late PermissionsRepository permissionsRepository;
    late AppCubit appCubit;

    const mockUser = User(id: '1', email: 'email');
    final mockCategory = Category(
      id: '11',
      owner: mockUser.email,
      name: 'name',
      icon: 100,
      color: 200,
    );
    final mockDeadline = Deadline(
      id: '111',
      categoryId: mockCategory.id,
      name: 'name',
      expirationDate: DateTime.parse('2024-12-06'),
    );

    setUpAll(() {
      setFirebaseUiIsTestMode(true);
    });

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      categoriesRepository = MockCategoriesRepository();
      deadlinesRepository = MockDeadlinesRepository();
      permissionsRepository = MockPermissionsRepository();
      appCubit = MockAppCubit();

      when(() => appCubit.state)
          .thenReturn(const AppState(isAuthenticated: true, user: mockUser));
      when(() => appCubit.auth).thenReturn(MockFirebaseAuth());
      when(() => categoriesRepository.observeCategoriesByOwner(any()))
          .thenAnswer((_) => Stream.value([mockCategory]));
      when(() => deadlinesRepository.observeDeadlinesByCategoryId(any()))
          .thenAnswer((_) => Stream.value([mockDeadline]));
      when(() => permissionsRepository.observePermissionsByGiver(any()))
          .thenAnswer((_) => Stream.value([]));
    });

    Widget createApp({
      bool isAuthenticated = true,
    }) {
      return MultiRepositoryProvider(
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
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: AppRouter(isAuthenticated: isAuthenticated).router,
          ),
        ),
      );
    }

    testWidgets('renders AuthenticationPage when not authenticated',
        (tester) async {
      await tester.pumpWidget(createApp(isAuthenticated: false));

      expect(find.byType(AuthenticationPage), findsOneWidget);
    });

    testWidgets('renders SummaryPage as initial location', (tester) async {
      await tester.pumpWidget(createApp());

      expect(find.byType(SummaryPage), findsOneWidget);
    });

    testWidgets('renders CategoriesPage when selected', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.tap(find.byIcon(AppIcons.categoriesDesitinationIcon));
      await tester.pumpAndSettle();

      expect(find.byType(CategoriesPage), findsOneWidget);
    });

    group('CategoriesPage', () {
      testWidgets(
          'navigates to AddEditCategoryPage when add icon button tapped',
          (tester) async {
        await tester.pumpWidget(createApp());
        await tester.tap(find.byIcon(AppIcons.categoriesDesitinationIcon));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(AddIconButton));
        await tester.pumpAndSettle();

        expect(find.byType(AddEditCategoryPage), findsOneWidget);
      });

      testWidgets('navigates to CategoryDetailsPage when category tapped',
          (tester) async {
        await tester.pumpWidget(createApp());
        await tester.tap(find.byIcon(AppIcons.categoriesDesitinationIcon));
        await tester.pumpAndSettle();
        await tester.tap(find.text(mockCategory.name));
        await tester.pumpAndSettle();

        expect(find.byType(CategoryDetailsPage), findsOneWidget);
      });

      group('CategoryDetailsPage', () {
        testWidgets(
            'navigates to AddEditDeadlinePage when add icon button tapped',
            (tester) async {
          await tester.pumpWidget(createApp());
          await tester.tap(find.byIcon(AppIcons.categoriesDesitinationIcon));
          await tester.pumpAndSettle();
          await tester.tap(find.text(mockCategory.name));
          await tester.pumpAndSettle();
          await tester.tap(find.byType(AddIconButton));
          await tester.pumpAndSettle();

          expect(find.byType(AddEditDeadlinePage), findsOneWidget);
        });
      });
    });

    testWidgets('renders PermissionsPage when selected', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.tap(find.byIcon(AppIcons.permissionsDestinationIcon));
      await tester.pumpAndSettle();

      expect(find.byType(PermissionsPage), findsOneWidget);
    });

    group('PermissionsPage', () {
      testWidgets(
          'navigates to AddEditPermissionPage when add icon button tapped',
          (tester) async {
        await tester.pumpWidget(createApp());
        await tester.tap(find.byIcon(AppIcons.permissionsDestinationIcon));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(AddIconButton));
        await tester.pumpAndSettle();

        expect(find.byType(AddEditPermissionPage), findsOneWidget);
      });
    });

    testWidgets('renders ProfilePage when selected', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.tap(find.byIcon(AppIcons.profileDestinationIcon));
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePage), findsOneWidget);
    });
  });
}
