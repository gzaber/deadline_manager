part of 'home_cubit.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.selectedIndex = 0,
  });

  final int selectedIndex;

  @override
  List<Object> get props => [selectedIndex];
}
