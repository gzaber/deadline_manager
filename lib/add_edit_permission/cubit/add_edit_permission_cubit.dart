import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:permissions_repository/permissions_repository.dart';

part 'add_edit_permission_state.dart';

class AddEditPermissionCubit extends Cubit<AddEditPermissionState> {
  AddEditPermissionCubit({
    required CategoriesRepository categoriesRepository,
    required PermissionsRepository permissionsRepository,
    required Permission? permission,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        _permissionsRepository = permissionsRepository,
        super(
          AddEditPermissionState(
            user: user,
            initialPermission: permission,
            receiver: permission?.receiver ?? '',
            categoryIds: permission?.categoryIds ?? const [],
          ),
        ) {
    _readCategories();
  }

  final CategoriesRepository _categoriesRepository;
  final PermissionsRepository _permissionsRepository;

  void _readCategories() async {
    emit(state.copyWith(status: AddEditPermissionStatus.loading));
    try {
      final categories = await _categoriesRepository
          .readCategoriesByUserEmail(state.user.email);
      emit(
        state.copyWith(
          status: AddEditPermissionStatus.success,
          categories: categories,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: AddEditPermissionStatus.failure));
    }
  }

  void onReceiverChanged(String receiver) {
    emit(state.copyWith(receiver: receiver));
  }

  void onCategoryChanged(String categoryId) {
    var categoryIds = Set<String>.from(state.categoryIds);
    categoryIds.contains(categoryId)
        ? categoryIds.remove(categoryId)
        : categoryIds.add(categoryId);
    emit(state.copyWith(categoryIds: categoryIds.toList()));
  }

  void savePermission() async {
    emit(state.copyWith(status: AddEditPermissionStatus.loading));

    final permission = Permission(
      id: state.initialPermission?.id,
      giver: state.initialPermission?.giver ?? state.user.email,
      receiver: state.receiver,
      categoryIds: state.categoryIds,
    );

    try {
      state.initialPermission == null
          ? await _permissionsRepository.createPermission(permission)
          : await _permissionsRepository.updatePermission(permission);

      emit(state.copyWith(status: AddEditPermissionStatus.saved));
    } catch (_) {
      emit(state.copyWith(status: AddEditPermissionStatus.failure));
    }
  }
}
