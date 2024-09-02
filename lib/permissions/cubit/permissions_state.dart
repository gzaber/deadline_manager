part of 'permissions_cubit.dart';

enum PermissionsFutureStatus { initial, loading, success, failure }

enum PermissionsStreamStatus { initial, loading, success, failure }

final class PermissionsState extends Equatable {
  const PermissionsState({
    this.futureStatus = PermissionsFutureStatus.initial,
    this.streamStatus = PermissionsStreamStatus.initial,
    this.permissions = const [],
    this.categories = const [],
    this.user = User.empty,
  });

  final PermissionsFutureStatus futureStatus;
  final PermissionsStreamStatus streamStatus;
  final List<Permission> permissions;
  final List<Category> categories;
  final User user;

  PermissionsState copyWith({
    PermissionsFutureStatus? futureStatus,
    PermissionsStreamStatus? streamStatus,
    List<Permission>? permissions,
    List<Category>? categories,
    User? user,
  }) {
    return PermissionsState(
      futureStatus: futureStatus ?? this.futureStatus,
      streamStatus: streamStatus ?? this.streamStatus,
      permissions: permissions ?? this.permissions,
      categories: categories ?? this.categories,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props =>
      [futureStatus, streamStatus, permissions, categories, user];
}
