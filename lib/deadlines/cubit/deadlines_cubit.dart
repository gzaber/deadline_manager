import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

part 'deadlines_state.dart';

class DeadlinesCubit extends Cubit<DeadlinesState> {
  DeadlinesCubit({
    required DeadlinesRepository deadlinesRepository,
    required Category category,
  })  : _deadlinesRepository = deadlinesRepository,
        super(DeadlinesState(category: category)) {
    _subscribeToDeadlines(category.id ?? '');
  }

  final DeadlinesRepository _deadlinesRepository;
  late final StreamSubscription<List<Deadline>> _deadlinesSubscription;

  void _subscribeToDeadlines(String categoryId) {
    _deadlinesSubscription = _deadlinesRepository
        .observeDeadlinesByCategory(categoryId)
        .listen((deadlines) {
      emit(state.copyWith(
          status: DeadlinesStatus.success, deadlines: deadlines));
    }, onError: (_) {
      emit(state.copyWith(status: DeadlinesStatus.failure));
    });
  }

  @override
  Future<void> close() {
    _deadlinesSubscription.cancel();
    return super.close();
  }
}
