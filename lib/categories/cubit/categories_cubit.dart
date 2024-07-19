import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:permissions_repository/permissions_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required CategoriesRepository categoriesRepository,
    required DeadlinesRepository deadlinesRepository,
    required PermissionsRepository permissionsRepository,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        _permissionsRepository = permissionsRepository,
        super(CategoriesState(user: user)) {
    _subscribeToCategories();
  }

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  final PermissionsRepository _permissionsRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  void _subscribeToCategories() {
    emit(state.copyWith(status: CategoriesStatus.loading));

    _categoriesSubscription = _categoriesRepository
        .observeCategoriesByUserEmail(state.user.email)
        .listen(
      (categories) {
        categories.sort((a, b) => a.name.compareTo(b.name));
        emit(
          state.copyWith(
            status: CategoriesStatus.success,
            categories: categories,
          ),
        );
      },
      onError: (e) {
        emit(state.copyWith(status: CategoriesStatus.failure));
      },
    );
  }

  void deleteCategory(String id) async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    try {
      await _categoriesRepository.deleteCategory(id);
      final deadlines =
          await _deadlinesRepository.readDeadlinesByCategoryId(id);
      for (final deadline in deadlines) {
        await _deadlinesRepository.deleteDeadline(deadline.id ?? '');
      }
      final permissions =
          await _permissionsRepository.readPermissionsByCategoryId(id);
      for (final permission in permissions) {
        var categoryIds = permission.categoryIds;
        categoryIds.remove(id);
        await _permissionsRepository
            .updatePermission(permission.copyWith(categoryIds: categoryIds));
      }
      emit(state.copyWith(status: CategoriesStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CategoriesStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    return super.close();
  }
}
