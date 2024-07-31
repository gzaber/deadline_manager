part of 'app_cubit.dart';

final class AppState extends Equatable {
  const AppState({
    required this.isAuthenticated,
    this.user = User.empty,
  });

  final bool isAuthenticated;
  final User user;

  AppState copyWith({
    bool? isAuthenticated,
    User? user,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [isAuthenticated, user];
}
