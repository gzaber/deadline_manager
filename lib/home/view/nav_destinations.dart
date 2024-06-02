import 'package:deadline_manager/home/home.dart';
import 'package:flutter/material.dart';

class NavDestinations {
  static final destinations = [
    Destination(
      label: 'Overview',
      icon: Icons.list,
      widget: Container(color: Colors.amber),
    ),
    Destination(
      label: 'Categories',
      icon: Icons.category,
      widget: Container(color: Colors.indigo),
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
