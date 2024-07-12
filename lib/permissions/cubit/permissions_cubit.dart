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
        super(PermissionsState(user: user)) {
    _subscribeToCategories();
    _subscribeToPermissions();
  }

  final CategoriesRepository _categoriesRepository;
  final PermissionsRepository _permissionsRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;
  late final StreamSubscription<List<Permission>> _permissionsSubscription;

  void _subscribeToCategories() {
    _categoriesSubscription = _categoriesRepository
        .observeCategoriesByUserEmail(state.user.email)
        .listen((categories) {
      emit(state.copyWith(
          status: PermissionsStatus.success, categories: categories));
    }, onError: (_) {
      emit(state.copyWith(status: PermissionsStatus.failure));
    });
  }

  void _subscribeToPermissions() {
    _permissionsSubscription = _permissionsRepository
        .observePermissionsByGiver(state.user.email)
        .listen(
      (permissions) {
        permissions.sort((a, b) => a.receiver.compareTo(b.receiver));
        emit(
          state.copyWith(
              status: PermissionsStatus.success, permissions: permissions),
        );
      },
      onError: (_) {
        emit(state.copyWith(status: PermissionsStatus.failure));
      },
    );
  }

  void deletePermission(String id) async {
    try {
      await _permissionsRepository.deletePermission(id);
      emit(state.copyWith(status: PermissionsStatus.success));
    } catch (_) {
      emit(state.copyWith(status: PermissionsStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    _permissionsSubscription.cancel();
    return super.close();
  }
}
