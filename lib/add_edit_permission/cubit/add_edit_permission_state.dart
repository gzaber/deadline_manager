part of 'add_edit_permission_cubit.dart';

enum AddEditPermissionStatus { initial, loading, success, failure, saved }

final class AddEditPermissionState extends Equatable {
  const AddEditPermissionState({
    this.status = AddEditPermissionStatus.initial,
    this.initialPermission,
    this.user = User.empty,
    this.receiver = '',
    this.categoryIds = const [],
    this.categories = const [],
  });

  final AddEditPermissionStatus status;
  final Permission? initialPermission;
  final User user;
  final String receiver;
  final List<String> categoryIds;
  final List<Category> categories;

  AddEditPermissionState copyWith({
    AddEditPermissionStatus? status,
    Permission? initialPermission,
    User? user,
    String? receiver,
    List<String>? categoryIds,
    List<Category>? categories,
  }) {
    return AddEditPermissionState(
      status: status ?? this.status,
      initialPermission: initialPermission ?? this.initialPermission,
      user: user ?? this.user,
      receiver: receiver ?? this.receiver,
      categoryIds: categoryIds ?? this.categoryIds,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props =>
      [status, initialPermission, user, receiver, categoryIds, categories];
}
