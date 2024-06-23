import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required CategoriesRepository categoriesRepository,
    required DeadlinesRepository deadlinesRepository,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        super(CategoriesState(user: user)) {
    _subscribeToCategories();
  }

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  void _subscribeToCategories() {
    _categoriesSubscription = _categoriesRepository
        .observeCategoriesByUserEmail(state.user.email)
        .listen(
      (categories) {
        categories.sort((a, b) => a.name.compareTo(b.name));
        emit(state.copyWith(
            categories: categories, status: CategoriesStatus.success));
      },
      onError: (e) {
        emit(state.copyWith(status: CategoriesStatus.failure));
      },
    );
  }

  void deleteCategoryWithDeadlines(String id) async {
    try {
      await _categoriesRepository.deleteCategory(id);
      final deadlines =
          await _deadlinesRepository.observeDeadlinesByCategory(id).first;
      for (final deadline in deadlines) {
        await _deadlinesRepository.deleteDeadline(deadline.id ?? '');
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
