import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:equatable/equatable.dart';

part 'add_edit_category_state.dart';

class AddEditCategoryCubit extends Cubit<AddEditCategoryState> {
  AddEditCategoryCubit({
    required CategoriesRepository categoriesRepository,
    required Category? category,
    required User user,
  })  : _categoriesRepository = categoriesRepository,
        super(
          AddEditCategoryState(
            user: user,
            initialCategory: category,
            name: category?.name ?? '',
            color: category?.color ?? AppColors.categoryColors.first.value,
            icon: category?.icon ?? AppIcons.categoryIcons.first.codePoint,
          ),
        );

  final CategoriesRepository _categoriesRepository;

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void onIconChanged(int icon) {
    emit(state.copyWith(icon: icon));
  }

  void onColorChanged(int color) {
    emit(state.copyWith(color: color));
  }

  void saveCategory() async {
    emit(
      state.copyWith(status: AddEditCategoryStatus.loading),
    );

    final category = Category(
      id: state.initialCategory?.id,
      owner: state.initialCategory?.owner ?? state.user.email,
      name: state.name,
      icon: state.icon,
      color: state.color,
    );

    try {
      state.initialCategory == null
          ? await _categoriesRepository.createCategory(category)
          : await _categoriesRepository.updateCategory(category);
      emit(
        state.copyWith(status: AddEditCategoryStatus.success),
      );
    } catch (_) {
      emit(
        state.copyWith(status: AddEditCategoryStatus.failure),
      );
    }
  }
}
