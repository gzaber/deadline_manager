part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user = User.empty,
  });

  final ProfileStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
