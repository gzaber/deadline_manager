import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({
    super.key,
    required this.child,
    required this.getDestinations,
  });

  final Widget child;
  final Function(BuildContext) getDestinations;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = AppScreenSize.getSize(context);

        if (screenSize != ScreenSize.mobile) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    destinations: [
                      ...getDestinations(context).map(
                        (destination) => NavigationRailDestination(
                          icon: Icon(destination.icon),
                          label: Text(destination.label),
                        ),
                      ),
                    ],
                    extended: screenSize == ScreenSize.desktop,
                    selectedIndex: _calculateSelectedIndex(context),
                    onDestinationSelected: (value) =>
                        _onDestinationSelected(value, context),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxWidth: AppScreenSize.desktopBreakpoint),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: [
              ...getDestinations(context).map(
                (destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                ),
              ),
            ],
            selectedIndex: _calculateSelectedIndex(context),
            onDestinationSelected: (value) =>
                _onDestinationSelected(value, context),
          ),
          body: SafeArea(
            child: child,
          ),
        );
      },
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return getDestinations(context)
        .indexWhere((dest) => location.startsWith(dest.path));
  }

  void _onDestinationSelected(int index, BuildContext context) =>
      context.go(getDestinations(context)[index].path);
}
