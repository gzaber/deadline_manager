import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:permissions_repository/permissions_repository.dart';

part 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit({
    required CategoriesRepository categoriesRepository,
    required PermissionsRepository permissionsRepository,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        _permissionsRepository = permissionsRepository,
        super(PermissionsState(user: user));

  final CategoriesRepository _categoriesRepository;
  final PermissionsRepository _permissionsRepository;
  late final StreamSubscription<List<Permission>> _permissionsSubscription;

  void readCategories() async {
    emit(state.copyWith(status: PermissionsStatus.loading));
    try {
      final categories =
          await _categoriesRepository.readCategoriesByOwner(state.user.email);
      categories.sort((a, b) => a.name.compareTo(b.name));
      emit(
        state.copyWith(
          status: PermissionsStatus.asyncSuccess,
          categories: categories,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PermissionsStatus.failure));
    }
  }

  void subscribeToPermissions() {
    emit(state.copyWith(status: PermissionsStatus.loading));
    _permissionsSubscription = _permissionsRepository
        .observePermissionsByGiver(state.user.email)
        .listen(
      (permissions) {
        permissions.sort((a, b) => a.receiver.compareTo(b.receiver));
        emit(
          state.copyWith(
            status: PermissionsStatus.streamSuccess,
            permissions: permissions,
          ),
        );
      },
      onError: (_) {
        emit(state.copyWith(status: PermissionsStatus.failure));
      },
    );
  }

  List<Category> getPermissionCategories(Permission permission) {
    final categories = permission.categoryIds
        .map((id) => state.categories.firstWhere((c) => c.id == id))
        .toList();
    categories.sort((a, b) => a.name.compareTo(b.name));

    return categories;
  }

  void deletePermission(String id) async {
    emit(state.copyWith(status: PermissionsStatus.loading));
    try {
      await _permissionsRepository.deletePermission(id);
      emit(state.copyWith(status: PermissionsStatus.asyncSuccess));
    } catch (_) {
      emit(state.copyWith(status: PermissionsStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _permissionsSubscription.cancel();
    return super.close();
  }
}
