import 'package:app_ui/app_ui.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class NavDestinations {
  static getDestinations(BuildContext context) => [
        Destination(
          label: AppLocalizations.of(context)!.summaryTitle,
          icon: AppIcons.summaryDestinationIcon,
          path: AppRouter.summaryPath,
        ),
        Destination(
          label: AppLocalizations.of(context)!.categoriesTitle,
          icon: AppIcons.categoriesDesitinationIcon,
          path: AppRouter.categoriesPath,
        ),
        Destination(
          label: AppLocalizations.of(context)!.permissionsTitle,
          icon: AppIcons.permissionsDestinationIcon,
          path: AppRouter.permissionsPath,
        ),
        Destination(
          label: AppLocalizations.of(context)!.profileTitle,
          icon: AppIcons.profileDestinationIcon,
          path: AppRouter.profilePath,
        ),
      ];
}
