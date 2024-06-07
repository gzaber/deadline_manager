import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const NavigationView(),
    );
  }
}

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        context.select((NavigationCubit cubit) => cubit.state.selectedIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMediumWidth = constraints.maxWidth > 640;
        final isLargeWidth = constraints.maxWidth > 960;

        if (isMediumWidth) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    destinations: [
                      ...NavDestinations.destinations.map(
                        (destination) => NavigationRailDestination(
                          icon: Icon(destination.icon),
                          label: Text(destination.label),
                        ),
                      ),
                    ],
                    extended: isLargeWidth ? true : false,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) =>
                        context.read<NavigationCubit>().setIndex(value),
                  ),
                  Expanded(
                    child: _DestinationView(index: selectedIndex),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: [
              ...NavDestinations.destinations.map(
                (destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                ),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) =>
                context.read<NavigationCubit>().setIndex(value),
          ),
          body: SafeArea(
            child: _DestinationView(index: selectedIndex),
          ),
        );
      },
    );
  }
}

class _DestinationView extends StatelessWidget {
  const _DestinationView({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: NavDestinations.destinations
            .map((destination) => destination.widget)
            .toList()[index],
      ),
    );
  }
}
