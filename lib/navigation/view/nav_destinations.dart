import 'package:deadline_manager/categories/categories.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';

class NavDestinations {
  static final destinations = [
    Destination(
      label: 'Home',
      icon: Icons.list,
      widget: Container(color: Colors.amber),
    ),
    const Destination(
      label: 'Categories',
      icon: Icons.category,
      widget: CategoriesPage(),
    ),
    Destination(
      label: 'Share',
      icon: Icons.share,
      widget: Container(color: Colors.purple),
    ),
    Destination(
      label: 'Settings',
      icon: Icons.settings,
      widget: Container(color: Colors.blue),
    ),
  ];
}
