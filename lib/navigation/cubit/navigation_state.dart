part of 'navigation_cubit.dart';

final class NavigationState extends Equatable {
  const NavigationState({
    this.selectedIndex = 0,
  });

  final int selectedIndex;

  @override
  List<Object> get props => [selectedIndex];
}
