import 'package:app_ui/app_ui.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/navigation/navigation.dart';

class NavDestinations {
  static const destinations = [
    Destination(
      label: 'Summary',
      icon: AppIcons.summaryDestinationIcon,
      path: AppRouter.summaryPath,
    ),
    Destination(
      label: 'Categories',
      icon: AppIcons.categoriesDesitinationIcon,
      path: AppRouter.categoriesPath,
    ),
    Destination(
      label: 'Permissions',
      icon: AppIcons.permissionsDestinationIcon,
      path: AppRouter.permissionsPath,
    ),
    Destination(
      label: 'Profile',
      icon: AppIcons.profileDestinationIcon,
      path: AppRouter.profilePath,
    ),
  ];
}
