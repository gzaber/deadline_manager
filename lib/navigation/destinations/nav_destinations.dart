import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';

class NavDestinations {
  static const destinations = [
    Destination(
      label: 'Summary',
      icon: Icons.list,
      path: RouterConfiguration.summaryPath,
    ),
    Destination(
      label: 'Categories',
      icon: Icons.category,
      path: RouterConfiguration.categoriesPath,
    ),
    Destination(
      label: 'Share',
      icon: Icons.share,
      path: RouterConfiguration.sharePath,
    ),
    Destination(
      label: 'Settings',
      icon: Icons.settings,
      path: RouterConfiguration.settingsPath,
    ),
  ];
}
