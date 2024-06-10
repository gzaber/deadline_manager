import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

part 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  CategoryDetailsCubit({
    required DeadlinesRepository deadlinesRepository,
    required String categoryId,
    required String categoryName,
  })  : _deadlinesRepository = deadlinesRepository,
        super(
          CategoryDetailsState(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        ) {
    _subscribeToDeadlines(categoryId);
  }

  final DeadlinesRepository _deadlinesRepository;
  late final StreamSubscription<List<Deadline>> _deadlinesSubscription;

  void _subscribeToDeadlines(String categoryId) {
    _deadlinesSubscription = _deadlinesRepository
        .observeDeadlinesByCategory(categoryId)
        .listen((deadlines) {
      emit(state.copyWith(
          status: CategoryDetailsStatus.success, deadlines: deadlines));
    }, onError: (_) {
      emit(state.copyWith(status: CategoryDetailsStatus.failure));
    });
  }

  @override
  Future<void> close() {
    _deadlinesSubscription.cancel();
    return super.close();
  }
}
