part of 'app_cubit.dart';

final class AppState extends Equatable {
  const AppState({
    required this.isAuthenticated,
    this.user = User.empty,
    this.isSignOutError = false,
  });

  final bool isAuthenticated;
  final User user;
  final bool isSignOutError;

  AppState copyWith({
    bool? isAuthenticated,
    User? user,
    bool? isSignOutError,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isSignOutError: isSignOutError ?? this.isSignOutError,
    );
  }

  @override
  List<Object> get props => [isAuthenticated, user, isSignOutError];
}
