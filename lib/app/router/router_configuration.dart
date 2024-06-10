import 'package:deadline_manager/authentication/authentication.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterConfiguration {
  RouterConfiguration({
    required this.isAuthenticated,
  });

  final bool isAuthenticated;

  static const authenticationPath = '/authentication';
  static const homePath = '/home';
  static const categoriesPath = '/categories';
  static const categoryIdParameter = 'categoryId';
  static const categoryDetailsPath = 'category_details';
  static const categoryDetailsWithParameterPath =
      '$categoryDetailsPath/:$categoryIdParameter';
  static const categoriesToDeadlinesPath =
      '$categoriesPath/$categoryDetailsPath';
  static const sharePath = '/share';
  static const settingsPath = '/settings';

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: homePath,
    redirect: (context, state) => !isAuthenticated ? authenticationPath : null,
    routes: [
      GoRoute(
        path: authenticationPath,
        builder: (context, state) => const AuthenticationPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => NavigationPage(child: child),
        routes: [
          GoRoute(
            path: homePath,
            builder: (context, state) => Container(color: Colors.orange),
          ),
          GoRoute(
            path: categoriesPath,
            builder: (context, state) => const CategoriesPage(),
            routes: [
              GoRoute(
                path: categoryDetailsWithParameterPath,
                builder: (context, state) => CategoryDetailsPage(
                  categoryId: state.pathParameters[categoryIdParameter] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: sharePath,
            builder: (context, state) => Container(color: Colors.indigo),
          ),
          GoRoute(
            path: settingsPath,
            builder: (context, state) => Container(color: Colors.purpleAccent),
          ),
        ],
      ),
    ],
  );
}
