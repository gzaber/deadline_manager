part of 'category_details_cubit.dart';

enum CategoryDetailsStatus { initial, success, failure }

final class CategoryDetailsState extends Equatable {
  const CategoryDetailsState({
    this.status = CategoryDetailsStatus.initial,
    required this.category,
    this.deadlines = const [],
  });

  final CategoryDetailsStatus status;
  final Category category;
  final List<Deadline> deadlines;

  @override
  List<Object> get props => [status, category, deadlines];

  CategoryDetailsState copyWith({
    CategoryDetailsStatus? status,
    Category? category,
    List<Deadline>? deadlines,
  }) {
    return CategoryDetailsState(
      status: status ?? this.status,
      category: category ?? this.category,
      deadlines: deadlines ?? this.deadlines,
    );
  }
}
