import 'package:bloc_test/bloc_test.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/authentication/view/authentication_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  group('AuthenticationPage', () {
    late AppCubit appCubit;

    setUpAll(() {
      setFirebaseUiIsTestMode(true);
    });

    setUp(() {
      appCubit = MockAppCubit();
      when(() => appCubit.state)
          .thenReturn(const AppState(isAuthenticated: false));
      when(() => appCubit.auth).thenReturn(MockFirebaseAuth());
    });

    Widget createPage() {
      return BlocProvider.value(
        value: appCubit,
        child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: AuthenticationPage()),
      );
    }

    testWidgets('renders pre-built SignInScreen', (tester) async {
      await tester.pumpWidget(createPage());

      expect(find.byType(SignInScreen), findsOneWidget);
    });

    testWidgets('renders app name when screen size is not mobile',
        (tester) async {
      await tester.pumpWidget(createPage());

      expect(find.text(AppLocalizationsEn().appName), findsOneWidget);
    });

    testWidgets('renders app name when screen size is desktop', (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(createPage());

      expect(find.text(AppLocalizationsEn().appName), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
