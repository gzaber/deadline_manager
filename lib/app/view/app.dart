import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permissions_repository/permissions_repository.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required CategoriesRepository categoriesRepository,
    required DeadlinesRepository deadlinesRepository,
    required PermissionsRepository permissionsRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        _permissionsRepository = permissionsRepository;

  final AuthenticationRepository _authenticationRepository;
  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  final PermissionsRepository _permissionsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _categoriesRepository,
        ),
        RepositoryProvider.value(
          value: _deadlinesRepository,
        ),
        RepositoryProvider.value(
          value: _permissionsRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AppCubit(
          authenticationRepository: _authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated =
        context.select((AppCubit cubit) => cubit.state.isAuthenticated);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        FirebaseUILocalizations.delegate,
      ],
      routerConfig: AppRouter(isAuthenticated: isAuthenticated).router,
    );
  }
}
