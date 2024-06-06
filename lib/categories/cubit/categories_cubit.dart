import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:equatable/equatable.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required CategoriesRepository categoriesRepository,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        super(CategoriesState(user: user)) {
    _subscribeToCategories();
  }

  final CategoriesRepository _categoriesRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  void _subscribeToCategories() {
    _categoriesSubscription = _categoriesRepository
        .observeCategoriesByUserEmail(state.user.email)
        .listen(
      (categories) {
        emit(state.copyWith(
            categories: categories, status: CategoriesStatus.success));
      },
      onError: (e) {
        emit(state.copyWith(status: CategoriesStatus.failure));
      },
    );
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    return super.close();
  }
}
