part of 'add_edit_category_cubit.dart';

enum AddEditCategoryStatus { initial, loading, success, failure }

class AddEditCategoryState extends Equatable {
  const AddEditCategoryState({
    this.status = AddEditCategoryStatus.initial,
    this.initialCategory,
    required this.user,
    required this.name,
    required this.icon,
    required this.color,
  });

  final AddEditCategoryStatus status;
  final Category? initialCategory;
  final User user;
  final String name;
  final int icon;
  final int color;

  AddEditCategoryState copyWith({
    AddEditCategoryStatus? status,
    Category? initialCategory,
    User? user,
    String? name,
    int? icon,
    int? color,
  }) {
    return AddEditCategoryState(
      status: status ?? this.status,
      initialCategory: initialCategory ?? this.initialCategory,
      user: user ?? this.user,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [status, initialCategory, user, name, icon, color];
}
