import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

part 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  CategoryDetailsCubit({
    required CategoriesRepository categoriesRepository,
    required DeadlinesRepository deadlinesRepository,
    required String categoryId,
  })  : _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        super(
          const CategoryDetailsState(
            category: Category(
              userEmail: '',
              name: '',
              icon: 0,
              color: 0,
            ),
          ),
        ) {
    _subscribeToCategory(categoryId);
    _subscribeToDeadlines(categoryId);
  }

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  late final StreamSubscription<Category> _categorySubscription;
  late final StreamSubscription<List<Deadline>> _deadlinesSubscription;

  void _subscribeToCategory(String categoryId) {
    _categorySubscription = _categoriesRepository
        .observeCategoryById(categoryId)
        .listen((category) {
      emit(state.copyWith(
          status: CategoryDetailsStatus.success, category: category));
    }, onError: (_) {
      emit(state.copyWith(status: CategoryDetailsStatus.failure));
    });
  }

  void _subscribeToDeadlines(String categoryId) {
    _deadlinesSubscription = _deadlinesRepository
        .observeDeadlinesByCategory(categoryId)
        .listen((deadlines) {
      deadlines.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
      emit(state.copyWith(
          status: CategoryDetailsStatus.success, deadlines: deadlines));
    }, onError: (_) {
      emit(state.copyWith(status: CategoryDetailsStatus.failure));
    });
  }

  void deleteDeadline(String id) async {
    try {
      await _deadlinesRepository.deleteDeadline(id);
      emit(
        state.copyWith(status: CategoryDetailsStatus.success),
      );
    } catch (_) {
      emit(
        state.copyWith(status: CategoryDetailsStatus.failure),
      );
    }
  }

  @override
  Future<void> close() {
    _categorySubscription.cancel();
    _deadlinesSubscription.cancel();
    return super.close();
  }
}
