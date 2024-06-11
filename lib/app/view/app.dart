import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deadline_manager/app/app.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    required CategoriesRepository categoriesRepository,
    required DeadlinesRepository deadlinesRepository,
    super.key,
  })  : _authenticationRepository = authenticationRepository,
        _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository;

  final AuthenticationRepository _authenticationRepository;
  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;

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
      title: 'Deadline Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig:
          RouterConfiguration(isAuthenticated: isAuthenticated).router,
    );
  }
}
