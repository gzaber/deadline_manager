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
        super(CategoryDetailsState());

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  late final StreamSubscription<List<Deadline>> _deadlinesSubscription;

  void readCategory(String categoryId) async {
    emit(state.copyWith(futureStatus: CategoryDetailsFutureStatus.loading));
    try {
      final category = await _categoriesRepository.readCategoryById(categoryId);
      emit(
        state.copyWith(
          futureStatus: CategoryDetailsFutureStatus.success,
          category: category,
        ),
      );
    } catch (_) {
      emit(state.copyWith(futureStatus: CategoryDetailsFutureStatus.failure));
    }
  }

  void subscribeToDeadlines(String categoryId) {
    emit(state.copyWith(streamStatus: CategoryDetailsStreamStatus.loading));
    _deadlinesSubscription = _deadlinesRepository
        .observeDeadlinesByCategoryId(categoryId)
        .listen((deadlines) {
      deadlines.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
      emit(
        state.copyWith(
          streamStatus: CategoryDetailsStreamStatus.success,
          deadlines: deadlines,
        ),
      );
    }, onError: (_) {
      emit(state.copyWith(streamStatus: CategoryDetailsStreamStatus.failure));
    });
  }

  void deleteDeadline(String id) async {
    emit(state.copyWith(futureStatus: CategoryDetailsFutureStatus.loading));
    try {
      await _deadlinesRepository.deleteDeadline(id);
      emit(
        state.copyWith(futureStatus: CategoryDetailsFutureStatus.success),
      );
    } catch (_) {
      emit(
        state.copyWith(futureStatus: CategoryDetailsFutureStatus.failure),
      );
    }
  }

  @override
  Future<void> close() {
    _deadlinesSubscription.cancel();
    return super.close();
  }
}
