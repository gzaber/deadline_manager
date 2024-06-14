import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/add_edit_category.dart';
import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadline_manager/authentication/authentication.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterConfiguration {
  RouterConfiguration({
    required this.isAuthenticated,
  });

  final bool isAuthenticated;

  static const authenticationPath = '/authentication';
  static const summaryPath = '/summary';
  static const categoriesPath = '/categories';
  static const sharePath = '/share';
  static const settingsPath = '/settings';

  static const categoryIdParameter = 'categoryId';
  static const deadlineIdParameter = 'deadlineId';

  static const categoryDetailsPath = 'category_details';
  static const categoryDetailsWithCategoryIdPath =
      '$categoryDetailsPath/:$categoryIdParameter';
  static const categoriesToCategoryDetailsPath =
      '$categoriesPath/$categoryDetailsPath';

  static const addEditCategoryPath = 'add_edit_category';
  static const addEditCategoryWithCategoryIdPath =
      '$addEditCategoryPath/:$categoryIdParameter';
  static const categoriesToAddEditCategoryPath =
      '$categoriesPath/$addEditCategoryPath';

  static const addEditDeadlinePath = 'add_edit_deadline';
  static const addEditDeadlineWithCategoryIdPath =
      '$addEditDeadlinePath/:$categoryIdParameter';

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: summaryPath,
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
            path: summaryPath,
            builder: (context, state) => const SummaryPage(),
          ),
          GoRoute(
            path: categoriesPath,
            builder: (context, state) => const CategoriesPage(),
            routes: [
              GoRoute(
                path: categoryDetailsWithCategoryIdPath,
                builder: (context, state) => CategoryDetailsPage(
                  categoryId: state.pathParameters[categoryIdParameter] ?? '',
                ),
                routes: [
                  GoRoute(
                    path: addEditDeadlinePath,
                    builder: (context, state) => AddEditDeadlinePage(
                      deadline: state.extra as Deadline,
                    ),
                  ),
                  GoRoute(
                    path: addEditDeadlineWithCategoryIdPath,
                    builder: (context, state) => AddEditDeadlinePage(
                      categoryId: state.pathParameters[categoryIdParameter],
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: addEditCategoryPath,
                builder: (context, state) => const AddEditCategoryPage(),
              ),
              GoRoute(
                path: addEditCategoryWithCategoryIdPath,
                builder: (context, state) => AddEditCategoryPage(
                  categoryId: state.pathParameters[categoryIdParameter],
                  category: state.extra as Category,
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

  get router => _router;
}
