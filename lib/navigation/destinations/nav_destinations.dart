import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';

class NavDestinations {
  static const destinations = [
    Destination(
      label: 'Summary',
      icon: Icons.list,
      path: AppRouter.summaryPath,
    ),
    Destination(
      label: 'Categories',
      icon: Icons.category,
      path: AppRouter.categoriesPath,
    ),
    Destination(
      label: 'Permissions',
      icon: Icons.lock,
      path: AppRouter.permissionsPath,
    ),
    Destination(
      label: 'Settings',
      icon: Icons.settings,
      path: AppRouter.settingsPath,
    ),
  ];
}
