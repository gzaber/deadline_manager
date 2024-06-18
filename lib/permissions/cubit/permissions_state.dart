part of 'permissions_cubit.dart';

enum PermissionsStatus { intial, success, failure }

final class PermissionsState extends Equatable {
  const PermissionsState({
    this.status = PermissionsStatus.intial,
    this.permissions = const [],
    this.user = User.empty,
  });

  final PermissionsStatus status;
  final List<Permission> permissions;
  final User user;

  @override
  List<Object> get props => [status, permissions, user];

  PermissionsState copyWith({
    PermissionsStatus? status,
    List<Permission>? permissions,
    User? user,
  }) {
    return PermissionsState(
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      user: user ?? this.user,
    );
  }
}
