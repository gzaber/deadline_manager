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
    _readDeadlines();
  }

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  final PermissionsRepository _permissionsRepository;

  void _readDeadlines() async {
    emit(state.copyWith(status: SummaryStatus.loading));
    try {
      final userCategories = await _categoriesRepository
          .readCategoriesByUserEmail(state.user.email);
      final sharedCategoryIds = await _permissionsRepository
          .readCategoryIdsByReceiver(state.user.email);
      final categoryIds = sharedCategoryIds;
      categoryIds.addAll(userCategories.map((c) => c.id ?? ''));

      if (categoryIds.isNotEmpty) {
        final deadlines =
            await _deadlinesRepository.readDeadlinesByCategoryIds(categoryIds);
        deadlines.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
        emit(
          state.copyWith(
            status: SummaryStatus.success,
            deadlines: deadlines,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: SummaryStatus.failure));
    }
  }
}
