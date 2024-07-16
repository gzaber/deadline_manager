part of 'permissions_cubit.dart';

enum PermissionsStatus { intial, loading, success, failure }

final class PermissionsState extends Equatable {
  const PermissionsState({
    this.status = PermissionsStatus.intial,
    this.permissions = const [],
    this.categories = const [],
    this.user = User.empty,
  });

  final PermissionsStatus status;
  final List<Permission> permissions;
  final List<Category> categories;
  final User user;

  @override
  List<Object> get props => [status, permissions, user];

  PermissionsState copyWith({
    PermissionsStatus? status,
    List<Permission>? permissions,
    List<Category>? categories,
    User? user,
  }) {
    return PermissionsState(
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      categories: categories ?? this.categories,
      user: user ?? this.user,
    );
  }
}
