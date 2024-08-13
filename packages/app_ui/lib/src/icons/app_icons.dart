import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

abstract class AppIcons {
  static const iconFontFamily = 'MaterialIcons';

  static const summaryDestinationIcon = Icons.list;
  static const categoriesDesitinationIcon = Icons.category;
  static const permissionsDestinationIcon = Icons.lock;
  static const profileDestinationIcon = Icons.account_circle;

  static const saveIcon = Icons.save;
  static const calendarIcon = Icons.date_range;
  static const addIcon = Icons.add_circle_outline;
  static const permissionItemIcon = Icons.person;
  static const emptyListInfoIcon = Icons.info;
  static const signOutIcon = Icons.logout;
  static const deleteAccountIcon = Icons.delete;

  static const categoryIcons = [
    Icons.folder,
    Icons.people,
    Icons.home,
    Icons.account_balance,
    Icons.payments,
    Icons.health_and_safety,
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.language,
    Icons.build,
    Icons.mail,
    Icons.phone,
    Icons.directions_car,
    Icons.local_shipping,
    Icons.airport_shuttle,
    Icons.flight,
  ];

  static Icon getDeadlineIcon(DateTime currentDate, DateTime expirationDate) {
    return Icon(Icons.description,
        color: switch (expirationDate.difference(currentDate).inDays) {
          <= 7 => AppColors.shortExpirationDateColor,
          > 7 && <= 30 => AppColors.mediumExpirationDateColor,
          _ => AppColors.longExpirationDateColor,
        });
  }
}
