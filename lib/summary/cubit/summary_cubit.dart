import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:permissions_repository/permissions_repository.dart';

part 'summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit({
    required DeadlinesRepository deadlinesRepository,
    required CategoriesRepository categoriesRepository,
    required PermissionsRepository permissionsRepository,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        _permissionsRepository = permissionsRepository,
        super(SummaryState(user: user)) {
    _subscribeToDeadlines();
  }

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  final PermissionsRepository _permissionsRepository;
  late final StreamSubscription<List<Deadline>> _deadlinesSubscription;

  void _subscribeToDeadlines() async {
    try {
      final categories = await _categoriesRepository
          .observeCategoriesByUserEmail(state.user.email)
          .first;
      final permissions = await _permissionsRepository
          .observePermissionsByReceiver(state.user.email)
          .first;

      final categoryIds = <String>[];
      categoryIds.addAll(categories.map((c) => c.id ?? ''));
      for (final permission in permissions) {
        categoryIds.addAll(permission.categoryIds);
      }

      if (categoryIds.isNotEmpty) {
        _deadlinesSubscription = _deadlinesRepository
            .observeDeadlinesByCategories(categoryIds)
            .listen(
          (deadlines) {
            deadlines
                .sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
            emit(
              state.copyWith(
                  status: SummaryStatus.success, deadlines: deadlines),
            );
          },
        );
      }
    } catch (_) {
      emit(state.copyWith(status: SummaryStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _deadlinesSubscription.cancel();
    return super.close();
  }
}
