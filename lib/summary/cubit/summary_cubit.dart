import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';

part 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit({
    required DeadlinesRepository deadlinesRepository,
    required CategoriesRepository categoriesRepository,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        super(SummaryState(user: user)) {
    _subscribeToDeadlines();
  }

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  late final StreamSubscription<List<Deadline>> _deadlinesSubscription;

  void _subscribeToDeadlines() async {
    List<String> categoryIds = [];
    await _categoriesRepository
        .observeCategoriesByUserEmail(state.user.email)
        .first
        .then((value) {
      categoryIds = value.map((category) => category.id ?? '').toList();
    });

    if (categoryIds.isNotEmpty) {
      _deadlinesSubscription =
          _deadlinesRepository.observeDeadlinesByCategories(categoryIds).listen(
        (deadlines) {
          emit(
            state.copyWith(status: SummaryStatus.success, deadlines: deadlines),
          );
        },
        onError: (_) {
          emit(
            state.copyWith(status: SummaryStatus.failure),
          );
        },
      );
    }
  }

  @override
  Future<void> close() {
    _deadlinesSubscription.cancel();
    return super.close();
  }
}
