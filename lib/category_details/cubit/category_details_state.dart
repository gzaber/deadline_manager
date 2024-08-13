part of 'category_details_cubit.dart';

enum CategoryDetailsStatus {
  initial,
  loading,
  asyncSuccess,
  streamSuccess,
  failure,
}

final class CategoryDetailsState extends Equatable {
  CategoryDetailsState({
    this.status = CategoryDetailsStatus.initial,
    Category? category,
    this.deadlines = const [],
  }) : category = category ?? Category(owner: '', name: '', icon: 0, color: 0);

  final CategoryDetailsStatus status;
  final Category category;
  final List<Deadline> deadlines;

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

  @override
  List<Object> get props => [status, category, deadlines];
}
