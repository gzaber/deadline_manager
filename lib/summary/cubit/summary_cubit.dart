import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/summary/summary.dart';
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
        super(SummaryState(user: user));

  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  final PermissionsRepository _permissionsRepository;

  void toggleShowDetails() {
    emit(
      state.copyWith(
        showDetails: !state.showDetails,
      ),
    );
  }

  void toggleShowShared() {
    emit(
      state.copyWith(
        showShared: !state.showShared,
      ),
    );
  }

  void readDeadlines() async {
    emit(state.copyWith(status: SummaryStatus.loading));
    try {
      final userCategories =
          await _categoriesRepository.readCategoriesByOwner(state.user.email);
      final sharedCategoryIds = await _permissionsRepository
          .readCategoryIdsByReceiver(state.user.email);
      final sharedCategories = <Category>[];
      for (final id in sharedCategoryIds) {
        sharedCategories.add(await _categoriesRepository.readCategoryById(id));
      }

      final categories = [...userCategories, ...sharedCategories];
      final categoryIds = List<String>.from(sharedCategoryIds);
      categoryIds.addAll(userCategories.map((c) => c.id));

      if (categoryIds.isEmpty) {
        emit(state.copyWith(status: SummaryStatus.initial));
        return;
      }

      final deadlines =
          await _deadlinesRepository.readDeadlinesByCategoryIds(categoryIds);
      deadlines.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

      final summaryDeadlines = deadlines
          .map(
            (d) => SummaryDeadline(
              name: d.name,
              expirationDate: d.expirationDate,
              isShared: sharedCategoryIds.contains(d.categoryId),
              categoryName:
                  categories.firstWhere((c) => c.id == d.categoryId).name,
              sharedBy:
                  categories.firstWhere((c) => c.id == d.categoryId).owner,
            ),
          )
          .toList();

      final userDeadlines = summaryDeadlines.where((d) => !d.isShared).toList();

      emit(
        state.copyWith(
          status: SummaryStatus.success,
          userDeadlines: userDeadlines,
          summaryDeadlines: summaryDeadlines,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SummaryStatus.failure));
    }
  }
}
