part of 'app_cubit.dart';

final class AppState extends Equatable {
  const AppState({
    required this.isAuthenticated,
    this.user = User.empty,
  });

  final bool isAuthenticated;
  final User user;

  @override
  List<Object> get props => [isAuthenticated, user];
}
