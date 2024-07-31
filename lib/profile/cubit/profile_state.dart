part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  deleteUserFailure,
  signOutFailure,
}

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user = User.empty,
  });

  final ProfileStatus status;
  final User user;

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status, user];
}
