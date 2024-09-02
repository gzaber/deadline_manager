import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/add_edit_category.dart';
import 'package:deadline_manager/add_edit_deadline/add_edit_deadline.dart';
import 'package:deadline_manager/add_edit_permission/add_edit_permission.dart';
import 'package:deadline_manager/authentication/authentication.dart';
import 'package:deadline_manager/categories/categories.dart';
import 'package:deadline_manager/category_details/category_details.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_repository/permissions_repository.dart';

class AppRouter {
  AppRouter({
    required this.isAuthenticated,
  });

  final bool isAuthenticated;
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static const authenticationPath = '/authentication';
  static const summaryPath = '/summary';
  static const categoriesPath = '/categories';
  static const permissionsPath = '/permissions';
  static const profilePath = '/profile';

  static const categoryDetailsPath = 'category_details';
  static const addEditCategoryPath = 'add_edit_category';
  static const addEditDeadlinePath = 'add_edit_deadline';
  static const addEditPermissionPath = 'add_edit_permission';

  static const categoryIdParameter = 'categoryId';

  static const categoryDetailsWithCategoryIdPath =
      '$categoryDetailsPath/:$categoryIdParameter';
  static const addEditDeadlineWithCategoryIdPath =
      '$addEditDeadlinePath/:$categoryIdParameter';

  static const categoriesToCategoryDetailsLocation =
      '$categoriesPath/$categoryDetailsPath';
  static const categoriesToAddEditCategoryLocation =
      '$categoriesPath/$addEditCategoryPath';
  static const permissionsToAddEditPermissionsLocation =
      '$permissionsPath/$addEditPermissionPath';

  get router => _router;

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
        builder: (context, state, child) => NavigationPage(
          getDestinations: NavDestinations.getDestinations,
          child: child,
        ),
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
                    path: addEditDeadlineWithCategoryIdPath,
                    builder: (context, state) => AddEditDeadlinePage(
                      categoryId:
                          state.pathParameters[categoryIdParameter] ?? '',
                      deadline: state.extra as Deadline?,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: addEditCategoryPath,
                builder: (context, state) => AddEditCategoryPage(
                  category: state.extra as Category?,
                ),
              ),
            ],
          ),
          GoRoute(
            path: permissionsPath,
            builder: (context, state) => const PermissionsPage(),
            routes: [
              GoRoute(
                path: addEditPermissionPath,
                builder: (context, state) => AddEditPermissionPage(
                  permission: state.extra as Permission?,
                ),
              ),
            ],
          ),
          GoRoute(
            path: profilePath,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
